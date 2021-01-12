import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/auth/auth.dart';
import 'package:sphere/providers/auth/auth_provider.dart';
import 'package:sphere/screens/home_screen.dart';
import 'package:sphere/widgets/rounded_button.dart';


class AuthScreen extends StatefulWidget {
  static String id = 'auth_screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  AuthService authService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authService = Provider.of<AuthService>(context);
    if(Auth.sharedPreferences.getString('SIGN_IN_METHOD') == GoogleAuthProvider.GOOGLE_SIGN_IN_METHOD) {
      authService.signIn().then((value) => Navigator.popAndPushNamed(context, HomeScreen.id)).catchError((error) {
        showDialog(context: context, builder: (context) => AlertDialog(content: Text('Error occured while trying to login')));
        return error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: authService.auth.isAuthenticating,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/collage.jpg'),
                fit: BoxFit.fill,
              )),
          child: Container(
            color: Colors.black.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButton(
                  onPressed: () async {
                    await authService.signIn();
                    if(authService.auth.isAuthenticated) {
                      Navigator.popAndPushNamed(context, HomeScreen.id);
                    }
                  },
                  child: Text(
                    'Google Sign In',
                    style: TextStyle(color: Colors.black87),
                  ),
                  width: 200.0,
                  height: 42.0,
                  radius: 30.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


