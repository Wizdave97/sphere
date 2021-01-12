import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final double radius;
  final Color color;
  final double width;
  final double height;
  RoundedButton(
      {this.onPressed,
      this.child,
      this.radius = 10,
      this.color = Colors.redAccent,
      this.height,
      this.width}): super();
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      clipBehavior: Clip.hardEdge,
      color: color,
      borderRadius: BorderRadius.circular(radius),
      child: MaterialButton(
        minWidth: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
