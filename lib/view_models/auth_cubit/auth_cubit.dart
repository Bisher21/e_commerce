import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_data.dart';
import '../../utils/api_paths.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServicesImpl authServices = AuthServicesImpl();
  final firestoreServices = FirestoreServices.instance;
  Future<void> _saveUserData(String email,String name)async{
    final userData = UserData(
      id: authServices.currentUser()!.uid,
      email: email,
      name: name,
      createdAt: DateTime.now().toIso8601String(),
    );
    await firestoreServices.setData(
      path: ApiPaths.users(userData.id),
      data: userData.toMap(),
    );
  }

  Future<void> loginWithYourInfo(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await authServices.loginWithYourInfo(email, password);
      if (result) {
        emit(const AuthDone());
      } else {
        emit(const AuthError("Login Failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerWithYourInfo(
    String email,
    String password,
    String name,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authServices.registerWithYourInfo(email, password);
      if (result) {
       await _saveUserData(email, name);
        emit(const AuthDone());
      } else {
        emit(const AuthError("Register Failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void checkAuth() {
    final user = authServices.currentUser();
    if (user != null) {
      emit(const AuthDone());
    }
  }

  Future<void> logout() async {
    emit(const AuthLoggingOut());
    try {
      await authServices.logout();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthLoggingOutFailed(state.toString()));
    }
  }

  Future<void> authenticateWithGoogle() async {
    emit(GoogleAuthLoading());
    try {
      final result = await authServices.loginWithGoogle();
      if (result) {
        emit(const GoogleAuthDone());
      } else {
        emit(const GoogleAuthError("Login Failed"));
      }
    } catch (e) {
      emit(GoogleAuthError(e.toString()));
    }
  }
}
