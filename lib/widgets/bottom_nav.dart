import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';



class BottomNav extends StatelessWidget {
  final int index;
  final void Function(int index) setIndex;
  BottomNav({this.index, this.setIndex}) : super();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      elevation: 5.0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.comment,
          ),
          label: 'Reviews'
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          label: 'Profile'
        ),
      ],
      onTap: (index) => setIndex(index),
      currentIndex: index,
      selectedItemColor: Colors.black54,
      unselectedItemColor: Colors.white,
      backgroundColor: Color(kBottomNavColor),
    );
  }
}
