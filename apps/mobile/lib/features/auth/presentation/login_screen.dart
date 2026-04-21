import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_notifier.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: authState.when(
            initial: () => const _LoginForm(),
            loading: () => const Center(child: CircularProgressIndicator()),
            unauthenticated: () => const _LoginForm(),
            authenticated: (_) => const Center(child: Text('Authenticated')),
            error: (msg) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(msg, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                const _LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => ref.read(authNotifierProvider.notifier).signIn(
                email: _emailController.text,
                password: _passwordController.text,
              ),
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
