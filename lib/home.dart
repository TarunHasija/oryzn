import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/counter_provider.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("build");
    // 👇 WATCH STATE (rebuilds UI)
    final counterState = ref.watch(counterProvider);
    final counterNotifer = ref.read(counterProvider.notifier);
    // final counterController = Get.find<CounterController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              counterState.count.toString(),
              // counterController.count.toString();
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    counterNotifer.decrement();
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    counterNotifer.increment();
                  },
                  child: const Text('+'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                counterNotifer.reset();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
