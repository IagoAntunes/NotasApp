import 'package:dartz/dartz.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';

import '../../../../core/utils/result_error.dart';

abstract class IAuthRepository {
  Future<Either<ResultError, UserCredentialModel>> signInWithEmailAndPassword({required String email, required String password});
  Future<Either<ResultError, UserCredentialModel>> registerWithEmailAndPassword({required String email, required String password});
  Future<Either<ResultError, bool>> signOut();
}
