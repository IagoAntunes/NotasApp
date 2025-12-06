sealed class INoteDetailsState {}

sealed class INoteDetailsListener extends INoteDetailsState {}

class NoteDetailsIdle extends INoteDetailsState {}

class NoteDetailsLoading extends INoteDetailsState {}

class NoteDetailsComplete extends INoteDetailsState {}

class NoteDetailsErrorListener extends INoteDetailsListener {
  NoteDetailsErrorListener(this.message);
  final String message;
}

class NeedRebuildHomeListener extends INoteDetailsListener {
  NeedRebuildHomeListener();
}
