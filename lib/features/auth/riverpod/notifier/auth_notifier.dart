import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oryzn/core/services/services.dart';
import 'package:oryzn/features/auth/data/auth_service.dart';
import 'package:oryzn/features/auth/riverpod/state/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signInWithGoogle();
      log('User from signInWithGoogle: $user', name: 'AuthNotifier');
      if (user != null) {
        log('Setting state with userId: ${user.uid}', name: 'AuthNotifier');
        state = state.copyWith(
          isLoading: false,
          userId: user.uid,
          userEmail: user.email,
          displayName: user.displayName,
        );
        log(
          'State updated, isAuthenticated: ${state.isAuthenticated}',
          name: 'AuthNotifier',
        );
        StorageService.setUserLoggedIn(true);
        StorageService.setUserName(user.displayName ?? 'User');
      } else {
        log('User was null, cancelled?', name: 'AuthNotifier');
        state = state.copyWith(isLoading: false);
      }
    } catch (e, stackTrace) {
      log(
        'Error in signInWithGoogle: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signInAnonymously() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signInAnonymously();
      log(user.toString(), name: "Anonymous user login user: ");
      if (user != null) {
        state = state.copyWith(isLoading: false, userId: user.uid);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
