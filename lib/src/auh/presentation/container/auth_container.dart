import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notes_app/core/mobx/mobx_listener.dart';
import 'package:notes_app/core/router/routes.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/src/auh/presentation/controller/auth_controller.dart';
import 'package:notes_app/src/auh/presentation/screens/auth_screen.dart';
import 'package:notes_app/src/auh/presentation/states/auth_state.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector<AuthController>();

    return MobxStateListener<IAuthState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is IAuthListener,
      onListen: (context, state) {
        if (state is AuthErrorListener) {
          String message = state.message;
          if (state.message.isNotEmpty) {
            if (state.message == 'invalid-credential') {
              message = 'Credenciais inválidas. Por favor, verifique seu e-mail e senha.';
            } else {
              message = 'Credenciais inválidas.';
            }
          }
          final snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is AuthSuccessLoginListener) {
          context.go(AppRoutes.home);
          controller.resetState();
        }
      },
      child: Observer(
        builder: (_) {
          final state = controller.state;
          final isLoading = state is AuthLoading;

          return AuthScreen(
            onLoginTap: (email, password) {
              FocusScope.of(context).unfocus();
              controller.login(email, password);
            },
            onRegisterTap: () {
              context.push(AppRoutes.register);
            },
            isLoading: isLoading,
          );
        },
      ),
    );
  }
}
