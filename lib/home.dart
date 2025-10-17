import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hello = Provider<String>((ref) {
  return 'Hello, Riverpod!';
});

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(hello);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(child: Text(text)),
    );
  }
}
