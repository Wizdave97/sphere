import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sphere/models/users.dart';
import 'package:sphere/widgets/profile_picture.dart';
import 'package:sphere/widgets/profile_tab_views.dart';
import 'package:sphere/widgets/profile_tabs.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';
  final String userId;
  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {

  TabController _controller;
  int selectedTab = 0;
  Stream<QuerySnapshot> stream;
  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);
    stream = User.fetchUser(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
        if(snapshot.hasError) {
          return Center(child: Text('An error occurred', style: TextStyle(color: Colors.white),),);
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SpinKitCircle(color: Colors.lightBlue, size: 10.0,));
        }
        if(snapshot.hasData) {
          User user = User.fromMap(snapshot.data.docs[0].data());
          return Column(
            children: [
              ProfilePicture(userId: widget.userId, user: user,),
              ProfileTabs(
                controller: _controller,
                onTabSelect: onTabSelect,
              ),
              Expanded(child: ProfileTabViews(selectedIndex: selectedTab, userId: widget.userId, user: user,))
            ],
          );

        }
        else {
          return Center(child: SpinKitCircle(color: Colors.lightBlue, size: 10.0,));
        }
      }
    );
  }

  void onTabSelect(int index) {
    setState(() {
      selectedTab = index;
    });

  }
}
