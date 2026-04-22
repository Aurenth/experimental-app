import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class OptionalJwtAuthGuard extends AuthGuard('jwt') {
  // Never throw — just set req.user to undefined if no valid token
  override canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  override handleRequest<T>(_err: unknown, user: T): T {
    return user;
  }
}
