import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { QueryRitualsDto } from './dto/query-rituals.dto';

const RITUAL_LIST_SELECT = {
  id: true,
  slug: true,
  name: true,
  nameHi: true,
  category: true,
  tradition: true,
  isFree: true,
  durationMinutes: true,
  imageUrl: true,
  description: true,
} satisfies Prisma.RitualSelect;

const RITUAL_DETAIL_SELECT = {
  ...RITUAL_LIST_SELECT,
  steps: {
    select: {
      id: true,
      order: true,
      title: true,
      titleHi: true,
      description: true,
      descHi: true,
    },
    orderBy: { order: 'asc' as const },
  },
  samagri: {
    select: {
      id: true,
      name: true,
      nameHi: true,
      quantity: true,
      optional: true,
    },
  },
};

@Injectable()
export class RitualsService {
  constructor(private prisma: PrismaService) {}

  async list(dto: QueryRitualsDto, userId?: string) {
    const { page = 1, pageSize = 20, category, tradition, language, free } = dto;

    const where: Prisma.RitualWhereInput = {
      ...(category && { category }),
      ...(tradition && { tradition }),
      ...(language && { language }),
      ...(free !== undefined && { isFree: free }),
    };

    const [data, total] = await Promise.all([
      this.prisma.ritual.findMany({
        where,
        select: RITUAL_LIST_SELECT,
        orderBy: { name: 'asc' },
        skip: (page - 1) * pageSize,
        take: pageSize,
      }),
      this.prisma.ritual.count({ where }),
    ]);

    const entitledTraditions = userId
      ? await this.getEntitledTraditions(userId)
      : new Set<string>();

    return {
      data: data.map((r) => this.applyLock(r, entitledTraditions)),
      total,
      page,
      pageSize,
    };
  }

  async search(q: string, userId?: string) {
    const term = q.trim();
    if (!term) return { data: [], total: 0 };

    const where: Prisma.RitualWhereInput = {
      OR: [
        { name: { contains: term, mode: 'insensitive' } },
        { nameHi: { contains: term } },
        { description: { contains: term, mode: 'insensitive' } },
      ],
    };

    const data = await this.prisma.ritual.findMany({
      where,
      select: RITUAL_LIST_SELECT,
      orderBy: { name: 'asc' },
      take: 50,
    });

    const entitledTraditions = userId
      ? await this.getEntitledTraditions(userId)
      : new Set<string>();

    return {
      data: data.map((r) => this.applyLock(r, entitledTraditions)),
      total: data.length,
    };
  }

  async findBySlug(slug: string, userId?: string) {
    const ritual = await this.prisma.ritual.findUnique({
      where: { slug },
      select: RITUAL_DETAIL_SELECT,
    });

    if (!ritual) throw new NotFoundException('Ritual not found');

    if (!ritual.isFree) {
      const entitled =
        userId !== undefined &&
        (await this.isEntitled(userId, ritual.tradition));

      if (!entitled) {
        // Return stub — show locked ritual without steps or samagri
        return {
          ...this.applyLock(ritual, new Set()),
          isLocked: true,
          steps: [],
          samagri: [],
        };
      }
    }

    return { ...ritual, isLocked: false };
  }

  async bundle(tradition: string, userId: string) {
    const entitled = await this.isEntitled(userId, tradition);
    if (!entitled) {
      throw new ForbiddenException(
        `No entitlement for tradition: ${tradition}`,
      );
    }

    const rituals = await this.prisma.ritual.findMany({
      where: { tradition },
      select: RITUAL_DETAIL_SELECT,
      orderBy: { name: 'asc' },
    });

    return {
      tradition,
      exportedAt: new Date().toISOString(),
      rituals: rituals.map((r) => ({ ...r, isLocked: false })),
    };
  }

  private async getEntitledTraditions(userId: string): Promise<Set<string>> {
    const rows = await this.prisma.userEntitlement.findMany({
      where: { userId },
      select: { tradition: true },
    });
    return new Set(rows.map((r) => r.tradition));
  }

  private async isEntitled(userId: string, tradition: string): Promise<boolean> {
    const row = await this.prisma.userEntitlement.findUnique({
      where: { userId_tradition: { userId, tradition } },
    });
    return row !== null;
  }

  private applyLock<T extends { isFree: boolean; tradition: string }>(
    ritual: T,
    entitledTraditions: Set<string>,
  ): T & { isLocked: boolean } {
    const isLocked = !ritual.isFree && !entitledTraditions.has(ritual.tradition);
    return { ...ritual, isLocked };
  }
}
