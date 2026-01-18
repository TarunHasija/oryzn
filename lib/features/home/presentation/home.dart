import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oryzn/core/router/app_routes.dart';
import 'package:oryzn/core/services/services.dart';
import 'package:oryzn/features/auth/riverpod/provider/auth_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(child: Text("Hi ${StorageService.getUserName()}")),
    );
  }
}
