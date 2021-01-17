import 'package:flutter/material.dart';



class ProfileTabs extends StatelessWidget {
  final TabController  controller;
  final void Function(int index) onTabSelect;
 ProfileTabs({@required this.controller, @required this.onTabSelect});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: TabBar(
          onTap: onTabSelect,
          controller: controller,
          isScrollable: true,
          tabs: [
            Tab(child: Text('About'),),
            Tab(child: Text('Watchlist'),),
            Tab(child: Text('Reviews'),),
            Tab(child: Text('Friends'),)
          ]),
    );
  }
}
