import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/domain/auth_token.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/presentation/home_screen.dart';

part 'router.g.dart';

// ---------------------------------------------------------------------------
// Typed route definitions
// ---------------------------------------------------------------------------

@TypedGoRoute<HomeRoute>(path: '/')
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HomeScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final token = ref.watch(authTokenProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = token != null;
      final onLogin = state.matchedLocation == '/login';

      if (!loggedIn && !onLogin) return '/login';
      if (loggedIn && onLogin) return '/';
      return null;
    },
    routes: $appRoutes,
  );
}
