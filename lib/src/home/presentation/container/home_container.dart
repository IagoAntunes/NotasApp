import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/core/router/routes.dart';
import 'package:notes_app/src/home/domain/models/note_details_params.dart';
import 'package:notes_app/src/home/presentation/controller/home_controller.dart';
import 'package:notes_app/src/home/presentation/states/home_state.dart';
import '../../../../core/mobx/mobx_listener.dart';
import '../screens/home_screen.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  void initState() {
    super.initState();
    final controller = injector<HomeController>();
    controller.fetchNotes();
  }

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
            notes: controller.state is HomeComplete ? (controller.state as HomeComplete).notes : [],
            isLoading: controller.state is HomeLoading,
            onTapDocumentation: () {},
            onTapLogout: () {
              controller.logOut();
            },
            onTapNoteDetails: (title, note, backgroundColor, index) async {
              final params = NoteDetailsParams(
                note: note,
                index: index,
                creating: false,
              );

              final result = await context.push<bool?>(
                AppRoutes.noteDetails,
                extra: params,
              );

              if (result == true) {
                controller.fetchNotes();
              }
            },
            onTapCreateNote: () async {
              final params = NoteDetailsParams(
                note: null,
                index: (controller.state as HomeComplete).notes.length,
                creating: true,
              );
              final result = await context.push<bool?>(AppRoutes.noteDetails, extra: params);

              if (result == true) {
                controller.fetchNotes();
              }
            },
          );
        },
      ),
    );
  }
}
