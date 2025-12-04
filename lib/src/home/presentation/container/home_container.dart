import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notes_app/core/di/injector.dart';
import '../../../../core/mobx/mobx_listener.dart';
import '../../../auh/presentation/controller/register_controller.dart';
import '../../../auh/presentation/states/register_state.dart';
import '../screens/home_screen.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector<RegisterController>();

    return MobxStateListener<IRegisterState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is IRegisterListener,
      onListen: (context, state) {},
      child: Observer(
        builder: (_) {
          return HomeScreen();
        },
      ),
    );
  }
}
