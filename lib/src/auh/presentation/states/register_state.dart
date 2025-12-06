sealed class IRegisterState {}

sealed class IRegisterListener extends IRegisterState {}

class RegisterIdle extends IRegisterState {}

class RegisterLoading extends IRegisterState {}

class RegisterComplete extends IRegisterState {}

class RegisterErrorListener extends IRegisterListener {
  RegisterErrorListener(this.message);
  final String message;
}

class RegisterSuccessListener extends IRegisterListener {
  RegisterSuccessListener();
}
