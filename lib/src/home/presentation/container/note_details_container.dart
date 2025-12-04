import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/src/home/presentation/controller/note_details_controller.dart';
import 'package:notes_app/src/home/presentation/screens/note_details_screen.dart';
import '../../../../core/mobx/mobx_listener.dart';
import '../states/note_details_state.dart';

class NoteDetailsContainer extends StatelessWidget {
  const NoteDetailsContainer({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.index,
    this.creating = false,
  });

  final String title;
  final String content;
  final Color backgroundColor;
  final int index;
  final bool creating;

  @override
  Widget build(BuildContext context) {
    final controller = injector<NoteDetailsController>();

    return MobxStateListener<INoteDetailsState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is INoteDetailsListener,
      onListen: (context, state) {},
      child: Observer(
        builder: (_) {
          return NoteDetailScreen(
            backgroundColor: backgroundColor,
            content: content,
            index: index,
            title: title,
            isCreating: creating,
            onDelete: () {
              // TODO: implement delete
            },
            onSave: (value) async {
              if (creating) {
                await controller.saveNote();
                if (context.mounted) context.pop();
              } else {
                await controller.saveNote();
                if (context.mounted) context.pop();
              }
            },
          );
        },
      ),
    );
  }
}
