import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/provider/counter_notifier.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Build");
    return Scaffold(
      appBar: AppBar(title: Text("Hello World!")),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterNotifier);
              return Text(count.toString());
            },
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(counterNotifier.notifier).increment();
                },
                child: Text("+"),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(counterNotifier.notifier).decrement();
                },
                child: Text("-"),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(counterNotifier.notifier).reset();
                },
                child: Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
