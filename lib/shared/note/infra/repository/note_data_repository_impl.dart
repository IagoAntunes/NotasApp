import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/shared/note/domain/repository/note_data_repository.dart';
import 'package:notes_app/shared/note/infra/datasource/note_data_datasource.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

class NoteDataRepositoryImpl implements INoteDataRepository {
  NoteDataRepositoryImpl({required INoteDataDatasource datasource}) : _datasource = datasource;

  final INoteDataDatasource _datasource;

  @override
  Future<Either<ResultError, List<NoteModel>>> getNotesByUser({required String userId}) async {
    try {
      return await _datasource.getNotesByUser(userId: userId);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }

  @override
  Future<Either<ResultError, bool>> createNote({required NoteModel note, required String userId}) async {
    try {
      return await _datasource.createNote(note: note, userId: userId);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }

  @override
  Future<Either<ResultError, bool>> updateNote({required NoteModel note, required String userId}) async {
    try {
      return await _datasource.updateNote(note: note, userId: userId);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }

  @override
  Future<Either<ResultError, bool>> deleteNote({required String uidNote, required String userId}) async {
    try {
      return await _datasource.deleteNote(uidNote: uidNote, userId: userId);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }
}
