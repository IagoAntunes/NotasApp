import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/shared/userData/domain/repository/user_data_repository.dart';
import 'package:notes_app/shared/userData/infra/datasource/user_data_datasource.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

class UserDataRepositoryImpl implements IUserDataRepository {
  UserDataRepositoryImpl({required IUserDataDatasource datasource}) : _datasource = datasource;

  final IUserDataDatasource _datasource;

  @override
  Future<Either<ResultError, List<NoteModel>>> getNotesByUser({required String userId}) async {
    try {
      return await _datasource.getNotesByUser(userId: userId);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }
}
