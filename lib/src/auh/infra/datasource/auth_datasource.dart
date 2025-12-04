import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';

abstract class IAuthDataSource {
  Future<Either<ResultError, UserCredentialModel>> signInWithEmailAndPassword({required String email, required String password});
  Future<Either<ResultError, UserCredentialModel>> registerWithEmailAndPassword({required String email, required String password});
  Future<Either<ResultError, bool>> signOut();
  Future<Either<ResultError, bool>> registerUserDatabase({required String id, required String email});
}
