sealed class INoteDetailsState {}

sealed class INoteDetailsListener extends INoteDetailsState {}

class NoteDetailsLoading extends INoteDetailsState {}

class NoteDetailsIdle extends INoteDetailsState {
  NoteDetailsIdle({required this.needRebuildHome});
  bool needRebuildHome = false;
}

class NoteDetailsErrorListener extends INoteDetailsListener {
  NoteDetailsErrorListener(this.message);
  final String message;
}

class NeedRebuildHomeListener extends INoteDetailsListener {
  NeedRebuildHomeListener();
}

class NeedLoginHomeListener extends INoteDetailsListener {
  NeedLoginHomeListener();
}
