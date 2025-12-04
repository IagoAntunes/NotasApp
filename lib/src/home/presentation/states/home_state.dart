sealed class IHomeState {}

sealed class IHomeListener extends IHomeState {}

class HomeIdle extends IHomeState {}

class HomeLoading extends IHomeState {}

class HomeComplete extends IHomeState {}

class HomeErrorListener extends IHomeState {
  HomeErrorListener(this.message);
  final String message;
}

class HomeLogoutSuccessListener extends IHomeListener {
  HomeLogoutSuccessListener();
}
