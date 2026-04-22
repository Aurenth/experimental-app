import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/domain/auth_token.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/phone_otp_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_notifier.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/rituals/presentation/rituals_screen.dart';

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

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
@immutable
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<RegisterRoute>(path: '/register')
@immutable
class RegisterRoute extends GoRouteData {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}

@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
@immutable
class ForgotPasswordRoute extends GoRouteData {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

@TypedGoRoute<PhoneOtpRoute>(path: '/phone-otp')
@immutable
class PhoneOtpRoute extends GoRouteData {
  const PhoneOtpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PhoneOtpScreen();
}

@TypedGoRoute<RitualsRoute>(path: '/rituals')
@immutable
class RitualsRoute extends GoRouteData {
  const RitualsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RitualsScreen();
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------

/// Auth-related paths that unauthenticated users may access freely.
const _authPaths = {'/login', '/register', '/forgot-password', '/phone-otp'};

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final token = ref.watch(authTokenProvider);
  final onboardingComplete = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = token != null;
      final path = state.matchedLocation;
      final onAuthScreen = _authPaths.contains(path);
      final onOnboarding = path == '/onboarding';

      if (loggedIn) {
        // Authenticated users shouldn't see onboarding or auth screens.
        if (onOnboarding || onAuthScreen) return '/';
        return null;
      }

      // Unauthenticated: direct to onboarding first, then login.
      if (!onboardingComplete && !onOnboarding) return '/onboarding';
      if (onboardingComplete && !onAuthScreen && !onOnboarding) return '/login';
      return null;
    },
    routes: $appRoutes,
  );
}
