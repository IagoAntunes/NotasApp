import 'package:notes_app/src/home/domain/models/note_model.dart';

sealed class IHomeState {}

sealed class IHomeListener extends IHomeState {}

class HomeIdle extends IHomeState {}

class HomeLoading extends IHomeState {}

class HomeComplete extends IHomeState {
  final List<NoteModel> notes;

  HomeComplete({required this.notes});
}

class HomeErrorListener extends IHomeState {
  HomeErrorListener(this.message);
  final String message;
}

class HomeLogoutSuccessListener extends IHomeListener {
  HomeLogoutSuccessListener();
}
