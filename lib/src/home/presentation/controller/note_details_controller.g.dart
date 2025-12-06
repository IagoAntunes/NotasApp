// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_details_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NoteDetailsController on _NoteDetailsControllerBase, Store {
  late final _$stateAtom =
      Atom(name: '_NoteDetailsControllerBase.state', context: context);

  @override
  INoteDetailsState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(INoteDetailsState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$saveNoteAsyncAction =
      AsyncAction('_NoteDetailsControllerBase.saveNote', context: context);

  @override
  Future<void> saveNote({required String text}) {
    return _$saveNoteAsyncAction.run(() => super.saveNote(text: text));
  }

  late final _$updateNoteAsyncAction =
      AsyncAction('_NoteDetailsControllerBase.updateNote', context: context);

  @override
  Future<void> updateNote(
      {required String text, required String uidNote, required int createdAt}) {
    return _$updateNoteAsyncAction.run(() =>
        super.updateNote(text: text, uidNote: uidNote, createdAt: createdAt));
  }

  late final _$deleteNoteAsyncAction =
      AsyncAction('_NoteDetailsControllerBase.deleteNote', context: context);

  @override
  Future<void> deleteNote({required String uidNote}) {
    return _$deleteNoteAsyncAction
        .run(() => super.deleteNote(uidNote: uidNote));
  }

  late final _$_NoteDetailsControllerBaseActionController =
      ActionController(name: '_NoteDetailsControllerBase', context: context);

  @override
  void resetState() {
    final _$actionInfo = _$_NoteDetailsControllerBaseActionController
        .startAction(name: '_NoteDetailsControllerBase.resetState');
    try {
      return super.resetState();
    } finally {
      _$_NoteDetailsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
