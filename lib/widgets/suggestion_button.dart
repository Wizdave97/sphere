import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';

class SuggestionButton extends StatelessWidget {
  final String title;
  final bool selected;
  SuggestionButton({@required this.title, this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      alignment: Alignment.center,
      constraints: BoxConstraints.tightFor(width: 140.0, height: 30.0),
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: selected ? Colors.redAccent : Color(0xff2F2F30),
      ),
      child: Center(
        child: Text(
          title,
          style: kSuggestionButtonTextStyle,
        ),
      ),
    );
  }
}
