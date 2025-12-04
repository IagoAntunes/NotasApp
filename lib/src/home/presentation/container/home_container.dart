import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/core/router/app_router.dart';
import 'package:notes_app/core/router/routes.dart';
import 'package:notes_app/src/home/presentation/controller/home_controller.dart';
import 'package:notes_app/src/home/presentation/states/home_state.dart';
import '../../../../core/mobx/mobx_listener.dart';
import '../screens/home_screen.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector<HomeController>();

    return MobxStateListener<IHomeState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is IHomeListener,
      onListen: (context, state) {
        if (state is HomeLogoutSuccessListener) {
          context.go(AppRoutes.auth);
        }
      },
      child: Observer(
        builder: (_) {
          return HomeScreen(
            onTapDocumentation: () {},
            onTapLogout: () {
              controller.logOut();
            },
            onTapNoteDetails: (title, content, backgroundColor, index) {
              context.push(AppRoutes.noteDetails, extra: {
                'title': title,
                'content': content,
                'backgroundColor': backgroundColor,
                'index': index,
              });
            },
            onTapCreateNote: () {
              final color = const Color(0xFFFFFDE7);
              context.push(AppRoutes.noteDetails, extra: {
                'title': 'Nova Nota',
                'content': '',
                'backgroundColor': color,
                'index': -1,
                'creating': true,
              });
            },
          );
        },
      ),
    );
  }
}
