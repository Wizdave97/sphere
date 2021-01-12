import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/auth/auth.dart';
import 'package:sphere/providers/auth/auth_provider.dart';
import 'package:sphere/screens/auth_screen.dart';
import 'package:sphere/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Auth.init();
  runApp(Sphere());
}

class Sphere extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
        ChangeNotifierProvider<AppService>(create: (context) => AppService())
      ],
      child: MaterialApp(
        title: 'Sphere',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AuthScreen.id,
        routes: {
          AuthScreen.id: (context) => AuthScreen(),
          HomeScreen.id: (context) => HomeScreen()
        },
      ),
    );
  }
}


