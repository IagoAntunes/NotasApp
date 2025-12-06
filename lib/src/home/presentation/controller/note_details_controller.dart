// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:notes_app/services/database/keyvalue/app_sharedpreferences_keys.dart';
import 'package:notes_app/shared/userData/domain/repository/user_data_repository.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../states/note_details_state.dart';

part 'note_details_controller.g.dart';

class NoteDetailsController = _NoteDetailsControllerBase with _$NoteDetailsController;

abstract class _NoteDetailsControllerBase with Store {
  _NoteDetailsControllerBase({
    required IUserDataRepository userDataRepository,
    required SharedPreferences sharedPreferences,
  })  : _userDataRepository = userDataRepository,
        _sharedPreferences = sharedPreferences;

  var uuid = Uuid();
  final IUserDataRepository _userDataRepository;
  final SharedPreferences _sharedPreferences;

  @observable
  INoteDetailsState state = NoteDetailsIdle();

  @action
  Future<void> saveNote({required String text}) async {
    final uid = uuid.v4();
    final newNote = NoteModel(uid: uid, text: text);
    final userId = _sharedPreferences.getString(AppSharedpreferencesKeys.userId);
    final result = await _userDataRepository.createNote(note: newNote, userId: userId!);
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
  Future<void> updateNote({required String text, required String uidNote}) async {
    final updatedNote = NoteModel(uid: uidNote, text: text);
    final userId = _sharedPreferences.getString(AppSharedpreferencesKeys.userId);
    final result = await _userDataRepository.updateNote(note: updatedNote, userId: userId!);
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
