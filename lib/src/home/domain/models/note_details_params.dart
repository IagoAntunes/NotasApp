import 'package:notes_app/src/home/domain/models/note_model.dart';

class NoteDetailsParams {
  final NoteModel? note;
  final int index;
  final bool creating;

  NoteDetailsParams({
    required this.note,
    required this.index,
    required this.creating,
  });
}
