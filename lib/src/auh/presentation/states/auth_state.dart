sealed class IAuthState {}

sealed class IAuthListener extends IAuthState {}

class AuthIdle extends IAuthState {}

class AuthLoading extends IAuthState {}

class AuthComplete extends IAuthState {}

class AuthErrorListener extends IAuthListener {
  AuthErrorListener(this.message);
  final String message;
}

class AuthSuccessLoginListener extends IAuthListener {
  AuthSuccessLoginListener();
}
