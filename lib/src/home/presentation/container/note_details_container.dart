import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/core/router/routes.dart';
import 'package:notes_app/core/styles/app_note_color.dart';
import 'package:notes_app/src/home/presentation/controller/note_details_controller.dart';
import 'package:notes_app/src/home/presentation/screens/note_details_screen.dart';
import '../../../../core/mobx/mobx_listener.dart';
import '../../domain/models/note_details_params.dart';
import '../screens/note_stats_screen.dart';
import '../states/note_details_state.dart';

class NoteDetailsContainer extends StatelessWidget {
  const NoteDetailsContainer({
    super.key,
    required this.params,
  });
  final NoteDetailsParams params;

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
        if (state is NoteDetailsErrorListener) {
          final snackBar = SnackBar(content: Text('Ocorreu um problema'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Observer(
        builder: (_) {
          return NoteDetailScreen(
            backgroundColor: AppNoteColors.getColor(params.index).base,
            content: params.note?.text ?? '',
            index: params.index,
            isCreating: params.creating,
            onDelete: () {
              controller.deleteNote(uidNote: params.note!.uid);
            },
            onSave: (value) async {
              if (params.creating) {
                await controller.saveNote(text: value);
              } else {
                await controller.updateNote(newText: value, note: params.note!);
              }
            },
            onTapStats: () {
              int totalLines = 0;
              int letters = 0;
              int digits = 0;

              if (params.note!.text.isNotEmpty) {
                totalLines = '\n'.allMatches(params.note!.text).length + 1;
              }

              for (final charCode in params.note!.text.codeUnits) {
                if ((charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122)) {
                  letters++;
                } else if (charCode >= 48 && charCode <= 57) {
                  digits++;
                }
              }

              final statsData = NoteStatsData(
                totalChars: params.note!.text.length,
                totalLines: totalLines,
                letters: letters,
                digits: digits,
                totalEdits: params.note!.updatedCount,
                index: params.index,
              );

              context.push(
                AppRoutes.noteStats,
                extra: statsData,
              );
            },
          );
        },
      ),
    );
  }
}
