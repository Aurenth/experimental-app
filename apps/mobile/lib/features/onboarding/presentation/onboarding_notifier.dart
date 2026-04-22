import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks whether the user has completed the onboarding flow.
///
/// Defaults to false (not complete). Set to true when the user taps
/// "Get Started" or "Skip" on the last onboarding page.
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);
