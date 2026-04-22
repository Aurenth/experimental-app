import {
  BadRequestException,
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Prisma } from '@prisma/client';
import { createHash } from 'crypto';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtPayload } from './strategies/jwt.strategy';

const BCRYPT_ROUNDS = 12;

function hashForStorage(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

// Parse a duration string like "30d", "7d", "1h" into milliseconds.
// Supports d (days), h (hours), m (minutes), s (seconds).
function parseDurationMs(duration: string): number {
  const match = /^(\d+)([dhms])$/.exec(duration);
  if (!match) return 30 * 24 * 60 * 60 * 1000; // default 30d
  const value = parseInt(match[1], 10);
  const unit = match[2];
  const multipliers: Record<string, number> = {
    d: 86_400_000,
    h: 3_600_000,
    m: 60_000,
    s: 1_000,
  };
  return value * multipliers[unit];
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private config: ConfigService,
  ) {}

  async register(dto: RegisterDto): Promise<TokenPair> {
    if (!dto.email && !dto.phone) {
      throw new BadRequestException('email or phone is required');
    }

    const hashed = await bcrypt.hash(dto.password, BCRYPT_ROUNDS);

    try {
      const user = await this.prisma.user.create({
        data: {
          email: dto.email,
          phone: dto.phone,
          password: hashed,
          name: dto.name,
        },
      });
      return this.issueTokens(
        user.id,
        user.email ?? undefined,
        user.phone ?? undefined,
      );
    } catch (e) {
      if (
        e instanceof Prisma.PrismaClientKnownRequestError &&
        e.code === 'P2002'
      ) {
        throw new ConflictException('email or phone already registered');
      }
      throw e;
    }
  }

  async login(dto: LoginDto): Promise<TokenPair> {
    const identifier = dto.identifier.trim();
    const isEmail = identifier.includes('@');

    const user = await this.prisma.user.findFirst({
      where: isEmail ? { email: identifier } : { phone: identifier },
    });

    if (!user) throw new UnauthorizedException('invalid credentials');

    const passwordMatch = await bcrypt.compare(dto.password, user.password);
    if (!passwordMatch) throw new UnauthorizedException('invalid credentials');

    return this.issueTokens(
      user.id,
      user.email ?? undefined,
      user.phone ?? undefined,
    );
  }

  async refresh(userId: string, rawRefreshToken: string): Promise<TokenPair> {
    const tokenHash = hashForStorage(rawRefreshToken);

    // findUnique is O(1) on the UNIQUE token column; verify ownership separately
    const stored = await this.prisma.refreshToken.findUnique({
      where: { token: tokenHash },
      include: { user: { select: { id: true, email: true, phone: true } } },
    });

    if (!stored || stored.userId !== userId) {
      // Token not found or belongs to a different user — potential reuse attack
      await this.prisma.refreshToken.deleteMany({ where: { userId } });
      throw new UnauthorizedException('refresh token invalid');
    }

    if (stored.expiresAt < new Date()) {
      await this.prisma.refreshToken.delete({ where: { id: stored.id } });
      throw new UnauthorizedException('refresh token expired');
    }

    // Rotate: delete old token before issuing new pair
    await this.prisma.refreshToken.delete({ where: { id: stored.id } });

    return this.issueTokens(
      userId,
      stored.user.email ?? undefined,
      stored.user.phone ?? undefined,
    );
  }

  async logout(userId: string, rawRefreshToken: string): Promise<void> {
    const tokenHash = hashForStorage(rawRefreshToken);
    await this.prisma.refreshToken.deleteMany({
      where: { userId, token: tokenHash },
    });
  }

  private async issueTokens(
    userId: string,
    email?: string,
    phone?: string,
  ): Promise<TokenPair> {
    const payload: JwtPayload = { sub: userId, email, phone };
    const refreshExpiresIn = this.config.get<string>(
      'JWT_REFRESH_EXPIRES_IN',
      '30d',
    );

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, {
        secret: this.config.getOrThrow<string>('JWT_SECRET'),
        expiresIn: this.config.get<string>('JWT_EXPIRES_IN', '15m'),
      }),
      this.jwtService.signAsync(payload, {
        secret: this.config.getOrThrow<string>('JWT_REFRESH_SECRET'),
        expiresIn: refreshExpiresIn,
      }),
    ]);

    const expiresAt = new Date(Date.now() + parseDurationMs(refreshExpiresIn));

    await this.prisma.refreshToken.create({
      data: {
        userId,
        token: hashForStorage(refreshToken),
        expiresAt,
      },
    });

    return { accessToken, refreshToken };
  }
}
