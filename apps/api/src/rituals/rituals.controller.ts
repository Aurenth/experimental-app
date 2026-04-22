import {
  Controller,
  Get,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { RitualsService } from './rituals.service';
import { QueryRitualsDto } from './dto/query-rituals.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { OptionalJwtAuthGuard } from '../auth/guards/optional-jwt-auth.guard';

interface RequestWithUser extends Request {
  user?: { id: string };
}

@ApiTags('rituals')
@Controller('rituals')
export class RitualsController {
  constructor(private ritualsService: RitualsService) {}

  @Get()
  @UseGuards(OptionalJwtAuthGuard)
  @ApiOperation({ summary: 'List rituals (paginated, filterable)' })
  @ApiQuery({ name: 'category', required: false })
  @ApiQuery({ name: 'tradition', required: false })
  @ApiQuery({ name: 'language', required: false })
  @ApiQuery({ name: 'free', required: false, type: Boolean })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'pageSize', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Paginated ritual list with isLocked flag' })
  list(@Query() dto: QueryRitualsDto, @Request() req: RequestWithUser) {
    return this.ritualsService.list(dto, req.user?.id);
  }

  @Get('search')
  @UseGuards(OptionalJwtAuthGuard)
  @ApiOperation({ summary: 'Full-text search across ritual names and descriptions' })
  @ApiQuery({ name: 'q', required: true, description: 'Search query' })
  @ApiResponse({ status: 200, description: 'Matching rituals with isLocked flag' })
  search(@Query('q') q: string, @Request() req: RequestWithUser) {
    return this.ritualsService.search(q ?? '', req.user?.id);
  }

  @Get('bundle/:tradition')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Download offline JSON bundle for an unlocked tradition' })
  @ApiResponse({ status: 200, description: 'Bundle with all rituals + steps + samagri' })
  @ApiResponse({ status: 403, description: 'No entitlement for this tradition' })
  bundle(@Param('tradition') tradition: string, @Request() req: RequestWithUser) {
    return this.ritualsService.bundle(tradition, req.user!.id);
  }

  @Get(':slug')
  @UseGuards(OptionalJwtAuthGuard)
  @ApiOperation({ summary: 'Get full ritual detail (steps + samagri, gated for non-free)' })
  @ApiResponse({ status: 200, description: 'Full ritual. Non-free + non-entitled returns empty steps/samagri.' })
  @ApiResponse({ status: 404, description: 'Ritual not found' })
  findOne(@Param('slug') slug: string, @Request() req: RequestWithUser) {
    return this.ritualsService.findBySlug(slug, req.user?.id);
  }
}
