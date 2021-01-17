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


  @override
  void initState() {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    if(Auth.sharedPreferences.getString('SIGN_IN_METHOD') == GoogleAuthProvider.GOOGLE_SIGN_IN_METHOD &&
        !authService.auth.isAuthenticating) {
      authService.signIn().then((isAuthenticated) {
        if(!isAuthenticated) {
          showDialog(context: context, builder: (context) => AlertDialog(content: Text('Could not login')));
          return;
        }
        Navigator.popAndPushNamed(context, HomeScreen.id);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
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
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 15.0, offset: Offset.infinite)],
                    color: Colors.white.withAlpha(120),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  child: Center(
                    child: RoundedButton(
                      onPressed: () async {
                        await authService.signIn();
                        if(authService.auth.isAuthenticated) {
                          Navigator.popAndPushNamed(context, HomeScreen.id);
                        }
                        else if(authService.auth.authError) {
                          showDialog(context: context, builder: (context) => AlertDialog(content: Text('Could not login')));
                        }
                      },
                      child: Text(
                        'Google Sign In',
                        style: TextStyle(color: Colors.black87),
                      ),
                      width: 200.0,
                      height: 42.0,
                      radius: 30.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


