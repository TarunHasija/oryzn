import 'package:oryzn/provider/counter_state.dart';
import 'package:riverpod/riverpod.dart';

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState(count: 0));

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  void decrement() {
    state = state.copyWith(count: state.count - 1);
  }

  void reset(){
    state = state.copyWith(count: 0);
  }
}
