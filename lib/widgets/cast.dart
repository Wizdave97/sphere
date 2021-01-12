import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';

class Cast extends StatelessWidget {
  const Cast({
    Key key,
    @required this.credit
  }) : super(key: key);
  final dynamic credit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 100,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: [
          Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(
                      '$assetBaseUrl${credit['profile_path']}',
                    ),
                    fit: BoxFit.cover)),
            clipBehavior: Clip.hardEdge,
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            credit['name'],
            style: kMovieGenreTextStyle,
            softWrap: true,
            textWidthBasis: TextWidthBasis.parent,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
