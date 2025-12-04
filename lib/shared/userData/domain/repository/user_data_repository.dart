import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';

import '../../../../src/home/domain/models/note_model.dart';

abstract class IUserDataRepository {
  Future<Either<ResultError, List<NoteModel>>> getNotesByUser({required String userId});
}
