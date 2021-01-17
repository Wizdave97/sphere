import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sphere/models/users.dart' as UserModel;

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: _firebaseAuth.currentUser.uid).get();
      if(snapshot.docs.length >= 1) return;
      await UserModel.User.createUser(_firebaseAuth.currentUser);
    } catch (e) {
      isAuthenticating = false;
      authError = true;
      isAuthenticated = false;
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
