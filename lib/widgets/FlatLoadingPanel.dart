import 'package:flutter/material.dart';

class LoadingPanel extends StatelessWidget {
  const LoadingPanel({
    Key key,
    @required this.animationController,
    @required this.height,
  }) : super(key: key);

  final AnimationController animationController;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey.withOpacity(animationController.value),
    );
  }
}
