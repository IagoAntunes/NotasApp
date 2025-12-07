// ignore_for_file: library_private_types_in_public_api
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:notes_app/shared/note/domain/repository/note_data_repository.dart';
import '../../../auh/domain/repository/auth_repository.dart';
import '../states/home_state.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  _HomeControllerBase({
    required final IAuthRepository authRepository,
    required final INoteDataRepository userDataRepository,
    required final FirebaseAuth firebaseAuth,
  })  : _authRepository = authRepository,
        _userDataRepository = userDataRepository,
        _firebaseAuth = firebaseAuth;

  final IAuthRepository _authRepository;
  final INoteDataRepository _userDataRepository;
  final FirebaseAuth _firebaseAuth;

  @observable
  IHomeState state = HomeIdle();

  @action
  Future<void> fetchNotes() async {
    state = HomeLoading();
    final userId = _firebaseAuth.currentUser?.uid;
    final result = await _userDataRepository.getNotesByUser(userId: userId!);
    result.fold(
      (l) {
        state = HomeErrorListener(l.message);
      },
      (r) {
        state = HomeComplete(notes: List.from(r));
      },
    );
  }

  @action
  Future<void> logOut() async {
    final result = await _authRepository.signOut();

    result.fold(
      (l) {
        state = HomeErrorListener(l.message);
      },
      (r) {
        state = HomeLogoutSuccessListener();
      },
    );
  }

  @action
  void resetState() {
    state = HomeIdle();
  }
}
