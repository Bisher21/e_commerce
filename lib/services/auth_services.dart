import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthServices {
  Future<bool> loginWithYourInfo(String email, String password);
  Future<bool> registerWithYourInfo(String email, String password);
  Future<bool> loginWithGoogle();
  User? currentUser();
  Future<void> logout();
}

class AuthServicesImpl implements AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> loginWithYourInfo(String email, String password) async {
    final userInfo = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userInfo.user;

    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> registerWithYourInfo(String email, String password) async {
    final userInfo = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userInfo.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn.instance.signOut();
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        print('Sign-in canceled by user.');
        return false;
      }

      final String? idToken = googleUser.authentication.idToken;

      final clientAuth = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);
      final String? accessToken = clientAuth.accessToken;

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return true;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return false;
    }
  }
}
