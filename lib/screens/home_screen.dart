import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/screens/feed_screen.dart';
import 'package:sphere/screens/profile_screen.dart';
import 'package:sphere/screens/reviews_screen.dart';
import 'package:sphere/screens/search_screen.dart';
import 'package:sphere/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final titles = ['Feed', 'Reviews', 'Profile'];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen(
                          type: SEARCH_TYPE.people,
                        )));
          },
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.person_add),
        ),
        appBar: AppBar(
          title: Text(titles[_currentIndex]),
          centerTitle: true,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      type: SEARCH_TYPE.movies,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        backgroundColor: Color(kScaffoldBackground),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            FeedScreen(),
            ReviewsScreen(),
            ProfileScreen(
              userId: _firebaseAuth.currentUser.uid,
            )
          ],
        ),
        bottomNavigationBar:
            BottomNav(index: _currentIndex, setIndex: setCurrentIndex),
      ),
    );
  }
}
