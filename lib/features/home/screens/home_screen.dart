import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';
import 'package:oryzn/core/theme/theme_provider.dart';
import 'package:oryzn/extensions/style_extension.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Screen', style: context.titleMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
