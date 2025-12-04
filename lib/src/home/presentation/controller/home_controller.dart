// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:notes_app/shared/userData/domain/repository/user_data_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/database/keyvalue/app_sharedpreferences_keys.dart';
import '../../../auh/domain/repository/auth_repository.dart';
import '../states/home_state.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  _HomeControllerBase({
    required final IAuthRepository authRepository,
    required final IUserDataRepository userDataRepository,
    required final SharedPreferences sharedPreferences,
  })  : _authRepository = authRepository,
        _userDataRepository = userDataRepository,
        _sharedPreferences = sharedPreferences;

  final IAuthRepository _authRepository;
  final IUserDataRepository _userDataRepository;
  final SharedPreferences _sharedPreferences;

  @observable
  IHomeState state = HomeIdle();

  Future<void> fetchNotes() async {
    state = HomeLoading();
    _sharedPreferences.getString(AppSharedpreferencesKeys.userId);
    final result = await _userDataRepository.getNotesByUser(userId: 'currentUserId');
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
