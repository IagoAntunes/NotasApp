import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/src/auh/presentation/screens/register_screen.dart';

import '../../../../services/stateManager/mobx/mobx_listener.dart';
import '../controller/register_controller.dart';
import '../states/register_state.dart';

class RegisterContainer extends StatelessWidget {
  const RegisterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector<RegisterController>();

    return MobxStateListener<IRegisterState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is IRegisterListener,
      onListen: (context, state) {
        if (state is RegisterErrorListener) {
          String errorMessage = 'Ocorreu um erro no registro.';
          if (state.message == 'network-request-failed') {
            errorMessage = 'Falha na conexão. Verifique sua internet e tente novamente.';
          }
          final snackBar = SnackBar(content: Text(errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          controller.resetState();
        }
        if (state is RegisterSuccessListener) {
          final snackBar = SnackBar(content: Text('Registro realizado com sucesso!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.pop();
          controller.resetState();
        }
      },
      child: Observer(
        builder: (_) {
          final state = controller.state;
          final isLoading = state is RegisterLoading;

          return RegisterScreen(
            onRegisterTap: (email, password) {
              FocusScope.of(context).unfocus();
              controller.register(email, password);
            },
            onAlreadyHaveAccountTap: () {
              context.pop();
            },
            isLoading: isLoading,
          );
        },
      ),
    );
  }
}
