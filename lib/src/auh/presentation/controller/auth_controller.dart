// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../states/auth_state.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  @observable
  IAuthState state = AuthIdle();

  @action
  Future<void> login(String email, String password) async {
    state = AuthLoading();
    await Future.delayed(const Duration(seconds: 3));
    state = AuthComplete();
  }

  @action
  void resetState() {
    state = AuthIdle();
  }
}
