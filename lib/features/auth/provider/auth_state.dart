class AuthState {
  final String? userId;

  const AuthState({this.userId});

  AuthState copyWith({String? userId}) {
    return AuthState(userId: userId ?? this.userId);
  }
}
