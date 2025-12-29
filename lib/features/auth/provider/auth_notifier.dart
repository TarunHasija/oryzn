import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/features/auth/provider/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  AuthState build() => AuthState();
}
