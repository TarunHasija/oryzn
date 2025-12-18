import 'package:oryzn/provider/counter_notifier.dart';
import 'package:oryzn/provider/counter_state.dart';
import 'package:riverpod/riverpod.dart';

// Think of this like Get.put(CounterController())
final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>(
  (ref) => CounterNotifier(),
);
