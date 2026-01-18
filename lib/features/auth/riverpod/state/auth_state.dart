class AuthState {
  final String? userId;
  final String? userEmail;
  final String? displayName;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.userId,
    this.userEmail,
    this.displayName,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => userId != null;

  AuthState copyWith({
    String? userId,
    String? userEmail,
    String? displayName,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      displayName: displayName ?? this.displayName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
