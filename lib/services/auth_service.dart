import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User getUser() {
    return _auth.currentUser;
  }

  Future<User> loginWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User user = userCredential.user;
      return user;
    } catch (error) {
      print('[ERROR] $error');
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
      return true;
    } catch (error) {
      print('[ERROR] $error');
      return false;
    }
  }

  factory AuthService() {
    return _singleton;
  }
}
