import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/home.dart';
import 'package:oryzn/provider/theme_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        colorSchemeSeed: isDark ? Colors.blue : Colors.amber,
      ),

      home: Home(),
    );
  }
}
