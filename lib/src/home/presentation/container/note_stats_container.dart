import 'package:flutter/material.dart';
import 'package:notes_app/src/home/presentation/screens/note_stats_screen.dart';

class NoteStatsContainer extends StatelessWidget {
  const NoteStatsContainer({
    super.key,
    required NoteStatsData data,
  }) : _data = data;

  final NoteStatsData _data;

  @override
  Widget build(BuildContext context) {
    return NoteStatsScreen(
      data: NoteStatsData(
        totalEdits: _data.totalEdits,
        totalLines: _data.totalLines,
        digits: _data.digits,
        letters: _data.letters,
        totalChars: _data.totalChars,
        index: _data.index,
      ),
    );
  }
}
