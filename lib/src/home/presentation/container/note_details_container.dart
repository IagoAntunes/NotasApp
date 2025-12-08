import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/core/di/injector.dart';
import 'package:notes_app/core/router/routes.dart';
import 'package:notes_app/core/styles/app_note_color.dart';
import 'package:notes_app/src/home/presentation/controller/note_details_controller.dart';
import 'package:notes_app/src/home/presentation/screens/note_details_screen.dart';
import '../../../../services/stateManager/mobx/mobx_listener.dart';
import '../../../auh/presentation/controller/auth_notifier.dart';
import '../../domain/models/note_details_params.dart';
import '../screens/note_stats_screen.dart';
import '../states/note_details_state.dart';

class NoteDetailsContainer extends StatefulWidget {
  const NoteDetailsContainer({
    super.key,
    required this.params,
  });
  final NoteDetailsParams params;

  @override
  State<NoteDetailsContainer> createState() => _NoteDetailsContainerState();
}

class _NoteDetailsContainerState extends State<NoteDetailsContainer> {
  @override
  void initState() {
    super.initState();
    controller.updatedCount = widget.params.note?.updatedCount ?? 0;
    controller.note = widget.params.note;
    controller.isCreating = widget.params.creating;
    controller.indexNote = widget.params.index;
  }

  int calculateVisualLines({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    if (text.isEmpty) return 0;

    final span = TextSpan(text: text, style: style);

    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );

    tp.layout(maxWidth: maxWidth);

    return tp.computeLineMetrics().length;
  }

  final controller = injector<NoteDetailsController>();

  final authNotifier = injector<AuthNotifier>();

  @override
  Widget build(BuildContext context) {
    return MobxStateListener<INoteDetailsState>(
      getState: () => controller.state,
      listenWhen: (previous, current) => current is INoteDetailsListener,
      onListen: (context, state) {
        if (state is NeedRebuildHomeListener) {
          if (context.mounted) return context.pop(true);
        }
        if (state is NoteDetailsErrorListener) {
          final snackBar = SnackBar(content: Text('Ocorreu um problema'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is NeedLoginHomeListener) {
          authNotifier.signOut();
        }
      },
      child: Observer(
        builder: (_) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (controller.state is NoteDetailsIdle) {
                final idleState = controller.state as NoteDetailsIdle;
                context.pop(idleState.needRebuildHome);
              } else {
                context.pop(false);
              }
            },
            child: NoteDetailScreen(
              backgroundColor: AppNoteColors.getColor(controller.indexNote).base,
              content: controller.note?.text ?? '',
              index: controller.indexNote,
              isCreating: controller.isCreating,
              isLoading: controller.state is NoteDetailsLoading,
              onBack: () {
                if (controller.state is NoteDetailsIdle) {
                  final idleState = controller.state as NoteDetailsIdle;
                  context.pop(idleState.needRebuildHome);
                } else {
                  context.pop(false);
                }
              },
              onDelete: () {
                controller.deleteNote(uidNote: controller.note!.uid);
              },
              onSave: (value) async {
                if (controller.isCreating) {
                  await controller.saveNote(text: value);
                } else {
                  await controller.updateNote(newText: value, note: controller.note!);
                }
              },
              onTapStats: (width, text) {
                int totalLines = 0;

                // if (params.note!.text.isNotEmpty) {
                //   oldTotalLines = '\n'.allMatches(params.note!.text).length + 1;
                // }
                totalLines = calculateVisualLines(
                  maxWidth: width,
                  text: text,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                );
                final letters = RegExp(r'\p{L}', unicode: true).allMatches(text).length;

                final digits = RegExp(r'\p{N}', unicode: true).allMatches(text).length;

                final statsData = NoteStatsData(
                  totalChars: text.length,
                  totalLines: totalLines,
                  letters: letters,
                  digits: digits,
                  totalEdits: controller.updatedCount,
                  index: controller.indexNote,
                );

                context.push(
                  AppRoutes.noteStats,
                  extra: statsData,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
