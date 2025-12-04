// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/repository/auth_repository.dart';
import '../states/auth_state.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  _AuthControllerBase({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository;

  final IAuthRepository _authRepository;
  @observable
  IAuthState state = AuthIdle();

  @action
  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await _authRepository.signInWithEmailAndPassword(email: email, password: password);
    result.fold(
      (l) {
        state = AuthErrorListener(l.code ?? '');
      },
      (r) {
        state = AuthSuccessLoginListener();
      },
    );
  }

  @action
  void resetState() {
    state = AuthIdle();
  }
}
