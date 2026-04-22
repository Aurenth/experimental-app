import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import 'auth_notifier.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
            passwordResetSent: (email) => _SuccessState(email: email),
            orElse: () => _ForgotPasswordForm(
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

class _ForgotPasswordForm extends ConsumerStatefulWidget {
  const _ForgotPasswordForm({this.errorMessage});

  final String? errorMessage;

  @override
  ConsumerState<_ForgotPasswordForm> createState() =>
      _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<_ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).forgotPassword(
          email: _emailController.text.trim(),
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
          Icon(
            Icons.lock_reset_outlined,
            size: 64,
            color: scheme.primary,
          ),
          const SizedBox(height: AppSpacing.xl2),
          Text(
            'Forgot your password?',
            style: textTheme.headlineSmall?.copyWith(color: scheme.secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter your email and we\'ll send you a link to reset your password.',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl3),
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'you@example.com',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
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
            label: 'Send Reset Link',
            onPressed: _submit,
            width: double.infinity,
            size: AppButtonSize.large,
          ),
          const SizedBox(height: AppSpacing.xl3),
          AppButton.ghost(
            label: 'Back to Sign In',
            onPressed: () => context.go('/login'),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl4),
        Icon(
          Icons.mark_email_read_outlined,
          size: 72,
          color: MuhurtamColours.success,
        ),
        const SizedBox(height: AppSpacing.xl2),
        Text(
          'Check your email',
          style: textTheme.headlineSmall?.copyWith(color: scheme.secondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We sent a password reset link to\n$email',
          style: textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl4),
        AppButton.filled(
          label: 'Back to Sign In',
          onPressed: () => context.go('/login'),
          width: double.infinity,
          size: AppButtonSize.large,
        ),
      ],
    );
  }
}
