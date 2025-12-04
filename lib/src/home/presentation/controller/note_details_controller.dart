// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import '../states/note_details_state.dart';

part 'note_details_controller.g.dart';

class NoteDetailsController = _NoteDetailsControllerBase with _$NoteDetailsController;

abstract class _NoteDetailsControllerBase with Store {
  _NoteDetailsControllerBase();

  @observable
  INoteDetailsState state = NoteDetailsIdle();

  @action
  Future<void> saveNote() async {}

  @action
  void resetState() {
    state = NoteDetailsIdle();
  }
}
