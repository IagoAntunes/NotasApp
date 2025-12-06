// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:notes_app/services/database/keyvalue/app_sharedpreferences_keys.dart';
import 'package:notes_app/shared/note/domain/repository/note_data_repository.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../states/note_details_state.dart';

part 'note_details_controller.g.dart';

class NoteDetailsController = _NoteDetailsControllerBase with _$NoteDetailsController;

abstract class _NoteDetailsControllerBase with Store {
  _NoteDetailsControllerBase({
    required INoteDataRepository noteRepository,
    required SharedPreferences sharedPreferences,
  })  : _noteRepository = noteRepository,
        _sharedPreferences = sharedPreferences;

  var uuid = Uuid();
  final INoteDataRepository _noteRepository;
  final SharedPreferences _sharedPreferences;

  @observable
  INoteDetailsState state = NoteDetailsIdle();

  @action
  Future<void> saveNote({required String text}) async {
    final uid = uuid.v4();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    final userId = _sharedPreferences.getString(AppSharedpreferencesKeys.userId);
    if (userId == null) {
      state = NeedLoginHomeListener();
      return;
    }
    final newNote = NoteModel(uid: uid, text: text, createdAt: createdAt, updatedCount: 0);
    final result = await _noteRepository.createNote(note: newNote, userId: userId);
    result.fold(
      (l) {
        state = NoteDetailsErrorListener(l.message);
      },
      (r) {
        state = NeedRebuildHomeListener();
      },
    );
  }

  @action
  Future<void> updateNote({
    required String newText,
    required NoteModel note,
  }) async {
    final updatedNote = NoteModel(uid: note.uid, text: newText, createdAt: note.createdAt, updatedCount: note.updatedCount + 1);
    final userId = _sharedPreferences.getString(AppSharedpreferencesKeys.userId);
    if (userId == null) {
      state = NeedLoginHomeListener();
      return;
    }
    final result = await _noteRepository.updateNote(note: updatedNote, userId: userId);
    result.fold(
      (l) {
        state = NoteDetailsErrorListener(l.message);
      },
      (r) async {
        state = NeedRebuildHomeListener();
      },
    );
  }

  @action
  Future<void> deleteNote({required String uidNote}) async {
    final userId = _sharedPreferences.getString(AppSharedpreferencesKeys.userId);
    final result = await _noteRepository.deleteNote(uidNote: uidNote, userId: userId!);
    result.fold(
      (l) {
        state = NoteDetailsErrorListener(l.message);
      },
      (r) {
        state = NeedRebuildHomeListener();
      },
    );
  }

  @action
  void resetState() {
    state = NoteDetailsIdle();
  }
}
