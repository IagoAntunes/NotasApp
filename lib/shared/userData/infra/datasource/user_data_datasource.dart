import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

abstract class IUserDataDatasource {
  Future<Either<ResultError, List<NoteModel>>> getNotesByUser({required String userId});
}
