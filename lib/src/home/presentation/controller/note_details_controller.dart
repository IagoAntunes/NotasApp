// ignore_for_file: library_private_types_in_public_api
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:notes_app/shared/note/domain/repository/note_data_repository.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';
import 'package:uuid/uuid.dart';
import '../states/note_details_state.dart';

part 'note_details_controller.g.dart';

class NoteDetailsController = _NoteDetailsControllerBase with _$NoteDetailsController;

abstract class _NoteDetailsControllerBase with Store {
  _NoteDetailsControllerBase({
    required INoteDataRepository noteRepository,
    required FirebaseAuth firebaseAuth,
  })  : _noteRepository = noteRepository,
        _firebaseAuth = firebaseAuth;

  var uuid = Uuid();
  final INoteDataRepository _noteRepository;
  final FirebaseAuth _firebaseAuth;

  @observable
  INoteDetailsState state = NoteDetailsIdle(needRebuildHome: false);

  int updatedCount = 0;

  NoteModel? note;
  bool isCreating = false;
  int indexNote = 0;

  @action
  Future<void> saveNote({required String text}) async {
    state = NoteDetailsLoading();
    final uid = uuid.v4();
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    final userId = _firebaseAuth.currentUser?.uid;
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
        note = newNote;
        updatedCount = newNote.updatedCount;
        isCreating = false;
        state = NoteDetailsIdle(needRebuildHome: true);
      },
    );
  }

  @action
  Future<void> updateNote({
    required String newText,
    required NoteModel note,
  }) async {
    state = NoteDetailsLoading();
    final updatedNote = NoteModel(uid: note.uid, text: newText, createdAt: note.createdAt, updatedCount: updatedCount + 1);
    final userId = _firebaseAuth.currentUser?.uid;
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
        updatedCount = updatedNote.updatedCount;
        state = NoteDetailsIdle(needRebuildHome: true);
      },
    );
  }

  @action
  Future<void> deleteNote({required String uidNote}) async {
    state = NoteDetailsLoading();
    final userId = _firebaseAuth.currentUser?.uid;
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
    state = NoteDetailsIdle(needRebuildHome: false);
  }
}
