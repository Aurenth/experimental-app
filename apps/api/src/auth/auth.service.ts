import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { createHash } from 'crypto';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtPayload } from './strategies/jwt.strategy';

const BCRYPT_ROUNDS = 12;
const REFRESH_TOKEN_EXPIRY_DAYS = 30;

function hashForStorage(token: string): string {
  return createHash('sha256').update(token).digest('hex');
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
      throw new UnauthorizedException('email or phone is required');
    }

    if (dto.email) {
      const existing = await this.prisma.user.findUnique({
        where: { email: dto.email },
      });
      if (existing) throw new ConflictException('email already registered');
    }

    if (dto.phone) {
      const existing = await this.prisma.user.findUnique({
        where: { phone: dto.phone },
      });
      if (existing) throw new ConflictException('phone already registered');
    }

    const hashed = await bcrypt.hash(dto.password, BCRYPT_ROUNDS);
    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        phone: dto.phone,
        password: hashed,
        name: dto.name,
      },
    });

    return this.issueTokens(user.id, user.email ?? undefined, user.phone ?? undefined);
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

    return this.issueTokens(user.id, user.email ?? undefined, user.phone ?? undefined);
  }

  async refresh(userId: string, rawRefreshToken: string): Promise<TokenPair> {
    const tokenHash = hashForStorage(rawRefreshToken);

    const stored = await this.prisma.refreshToken.findFirst({
      where: { userId, token: tokenHash },
      include: { user: { select: { email: true, phone: true } } },
    });

    if (!stored || stored.expiresAt < new Date()) {
      // Revoke all tokens for this user if token not found — potential reuse attack
      if (!stored) {
        await this.prisma.refreshToken.deleteMany({ where: { userId } });
      }
      throw new UnauthorizedException('refresh token invalid or expired');
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

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, {
        secret: this.config.getOrThrow<string>('JWT_SECRET'),
        expiresIn: this.config.get<string>('JWT_EXPIRES_IN', '15m'),
      }),
      this.jwtService.signAsync(payload, {
        secret: this.config.getOrThrow<string>('JWT_REFRESH_SECRET'),
        expiresIn: this.config.get<string>(
          'JWT_REFRESH_EXPIRES_IN',
          '30d',
        ),
      }),
    ]);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + REFRESH_TOKEN_EXPIRY_DAYS);

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
