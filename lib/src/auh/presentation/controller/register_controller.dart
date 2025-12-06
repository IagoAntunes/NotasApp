// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/repository/auth_repository.dart';
import '../states/register_state.dart';

part 'register_controller.g.dart';

class RegisterController = _RegisterControllerBase with _$RegisterController;

abstract class _RegisterControllerBase with Store {
  _RegisterControllerBase({
    required final IAuthRepository authRepository,
  }) : _authRepository = authRepository;

  final IAuthRepository _authRepository;

  @observable
  IRegisterState state = RegisterIdle();

  @action
  Future<void> register(String email, String password) async {
    state = RegisterLoading();
    final result = await _authRepository.registerWithEmailAndPassword(email: email, password: password);

    result.fold(
      (l) {
        state = RegisterErrorListener(l.code ?? '');
      },
      (r) {
        state = RegisterSuccessListener();
      },
    );
  }

  @action
  void resetState() {
    state = RegisterIdle();
  }
}
