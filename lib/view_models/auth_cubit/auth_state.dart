part of 'auth_cubit.dart';


sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState{}

final class AuthDone extends AuthState{

  const AuthDone();
}

final class AuthError extends AuthState{
  final String message;

   const AuthError(this.message);

}

final class AuthLoggingOut extends AuthState{
  const AuthLoggingOut();
}

final class AuthLoggedOut extends AuthState{
  const AuthLoggedOut();
}

final class AuthLoggingOutFailed extends AuthState{
  final String message;

  const AuthLoggingOutFailed(this.message);
}

final class GoogleAuthLoading extends AuthState{}

final class GoogleAuthDone extends AuthState{

  const GoogleAuthDone();
}

final class GoogleAuthError extends AuthState{
  final String message;

  const GoogleAuthError(this.message);

}
