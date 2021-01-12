import 'package:flutter/material.dart';
import 'package:sphere/providers/auth/auth.dart';

class AuthService extends ChangeNotifier {
  final Auth auth = Auth();

  Future<void> signIn() async {
    await auth.login();
    update();
  }

  Future<void> signOut() async {
    await auth.signOut();
    update();
  }
  void update() {
    notifyListeners();
  }
}