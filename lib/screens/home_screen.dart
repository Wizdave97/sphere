import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/screens/feed.dart';
import 'package:sphere/screens/profile_screen.dart';
import 'package:sphere/screens/thoughts_screen.dart';
import 'package:sphere/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final titles = ['Feed', 'Thoughts', 'Profile'];
  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      backgroundColor: Color(kScaffoldBackground),
      body: IndexedStack(
        index: _currentIndex,
        children: [FeedScreen(), ThoughtsScreen(), ProfileScreen()],
      ),
      bottomNavigationBar:
          BottomNav(index: _currentIndex, setIndex: setCurrentIndex),
    );
  }
}
