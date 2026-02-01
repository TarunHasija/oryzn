import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/features/home/riverpod/notifier/home_notifier.dart';
import 'package:oryzn/features/home/riverpod/state/home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
