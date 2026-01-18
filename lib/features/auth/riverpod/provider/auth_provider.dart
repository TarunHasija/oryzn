import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/features/auth/data/auth_service.dart';
import 'package:oryzn/features/auth/riverpod/notifier/auth_notifier.dart';
import 'package:oryzn/features/auth/riverpod/state/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthService()),
);
