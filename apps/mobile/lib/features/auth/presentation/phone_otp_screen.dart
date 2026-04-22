import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import 'auth_notifier.dart';

class PhoneOtpScreen extends ConsumerWidget {
  const PhoneOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In with Phone'),
        leading: BackButton(onPressed: () => context.go('/login')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl2),
          child: authState.maybeWhen(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl5),
                child: CircularProgressIndicator(),
              ),
            ),
            otpSent: (phone) => _OtpVerifyForm(phone: phone),
            orElse: () => _PhoneEntryForm(
              errorMessage: authState.maybeWhen(
                error: (msg) => msg,
                orElse: () => null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phase 1 — Phone number entry
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneEntryForm extends ConsumerStatefulWidget {
  const _PhoneEntryForm({this.errorMessage});

  final String? errorMessage;

  @override
  ConsumerState<_PhoneEntryForm> createState() => _PhoneEntryFormState();
}

class _PhoneEntryFormState extends ConsumerState<_PhoneEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).sendPhoneOtp(
          phone: _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Enter your phone number',
            style: textTheme.headlineSmall?.copyWith(color: scheme.secondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'We\'ll send a one-time password to verify your number.',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl3),
          AppTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '+91 98765 43210',
            prefixIcon: const Icon(Icons.phone_outlined),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _sendOtp(),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Phone number is required';
              if (v.replaceAll(RegExp(r'[ +]'), '').length < 10) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: AppRadii.smAll,
              ),
              child: Text(
                widget.errorMessage!,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onErrorContainer,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl2),
          AppButton.filled(
            label: 'Send OTP',
            onPressed: _sendOtp,
            width: double.infinity,
            size: AppButtonSize.large,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phase 2 — OTP verification
// ─────────────────────────────────────────────────────────────────────────────

class _OtpVerifyForm extends ConsumerStatefulWidget {
  const _OtpVerifyForm({required this.phone});

  final String phone;

  @override
  ConsumerState<_OtpVerifyForm> createState() => _OtpVerifyFormState();
}

class _OtpVerifyFormState extends ConsumerState<_OtpVerifyForm> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verify() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).verifyOtp(
          phone: widget.phone,
          otp: _otpController.text.trim(),
        );
  }

  void _resend() {
    ref
        .read(authNotifierProvider.notifier)
        .sendPhoneOtp(phone: widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Enter the OTP',
            style: textTheme.headlineSmall?.copyWith(color: scheme.secondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              children: [
                const TextSpan(text: 'We sent a 6-digit code to '),
                TextSpan(
                  text: widget.phone,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl3),
          AppTextField(
            controller: _otpController,
            label: 'One-Time Password',
            hint: '123456',
            prefixIcon: const Icon(Icons.pin_outlined),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _verify(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (v) {
              if (v == null || v.isEmpty) return 'OTP is required';
              if (v.length != 6) return 'Enter the 6-digit OTP';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl2),
          AppButton.filled(
            label: 'Verify',
            onPressed: _verify,
            width: double.infinity,
            size: AppButtonSize.large,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive it? ",
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: _resend,
                child: Text(
                  'Resend OTP',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
