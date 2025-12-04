// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../states/register_state.dart';

part 'register_controller.g.dart';

class RegisterController = _RegisterControllerBase with _$RegisterController;

abstract class _RegisterControllerBase with Store {
  @observable
  IRegisterState state = RegisterIdle();

  @action
  Future<void> register(String email, String password) async {
    state = RegisterLoading();
    await Future.delayed(const Duration(seconds: 3));

    state = RegisterSuccessListener();
  }

  @action
  void resetState() {
    state = RegisterIdle();
  }
}
