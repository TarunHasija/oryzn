import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.signup),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
