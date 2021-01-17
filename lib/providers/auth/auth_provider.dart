import 'package:flutter/material.dart';
import 'package:sphere/providers/auth/auth.dart';

class AuthService extends ChangeNotifier {
  final Auth auth = Auth();

  Future<bool> signIn() async {
    await auth.login();
    notifyListeners();
    return auth.isAuthenticated;
  }

  Future<bool> signOut() async {
    await auth.signOut();
    notifyListeners();
    return auth.isAuthenticated;
  }
}