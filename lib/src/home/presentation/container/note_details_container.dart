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
    required this.uidNote,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.index,
    this.creating = false,
    this.createdAt,
  });
  final String uidNote;
  final String title;
  final String content;
  final Color backgroundColor;
  final int index;
  final bool creating;
  final int? createdAt;

  @override
  Widget build(BuildContext context) {
    final controller = injector<NoteDetailsController>();

    return MobxStateListener<INoteDetailsState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is INoteDetailsListener,
      onListen: (context, state) {
        if (state is NeedRebuildHomeListener) {
          if (context.mounted) context.pop(true);
        }
      },
      child: Observer(
        builder: (_) {
          return NoteDetailScreen(
            backgroundColor: backgroundColor,
            content: content,
            index: index,
            title: title,
            isCreating: creating,
            onDelete: () {
              controller.deleteNote(uidNote: uidNote);
            },
            onSave: (value) async {
              if (creating) {
                await controller.saveNote(text: value);
              } else {
                await controller.updateNote(text: value, uidNote: uidNote, createdAt: createdAt!);
              }
            },
          );
        },
      ),
    );
  }
}
