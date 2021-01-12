import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static SharedPreferences sharedPreferences;
  User user;
  bool isAuthenticating = false;
  bool isAuthenticated = false;
  bool authError = false;

  static Future<void> init() async {
    sharedPreferences =  await SharedPreferences.getInstance();
  }

  Future<void> login() async {
    try {
      isAuthenticating = true;
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication authentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;
      isAuthenticated = true;
      isAuthenticating = false;
      sharedPreferences.setString('SIGN_IN_METHOD', GoogleAuthProvider.GOOGLE_SIGN_IN_METHOD);
    } catch (e) {
      isAuthenticating = false;
      authError = false;
    }
  }


  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      isAuthenticated = false;
    }
    catch(e) {
      authError = true;
    }
  }
}
