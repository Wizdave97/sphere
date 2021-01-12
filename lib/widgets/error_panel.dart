import 'package:flutter/material.dart';

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Center(
        child: Text(
          'An error occured while fetching',
          softWrap: true,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}