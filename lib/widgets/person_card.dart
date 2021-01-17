import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/screens/profile_screen.dart';

class PersonCard extends StatelessWidget {
  final String photoURL;
  final String displayName;
  final String movieQuote;
  final String userId;
  PersonCard({this.photoURL, this.displayName, this.movieQuote, this.userId}) : super();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(title: Text('Profile'), backgroundColor: Colors.black,),
            body: ProfileScreen(userId: userId,),
        );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.black,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.blueGrey))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(photoURL),
              backgroundColor: Colors.black12,
              radius: 20.0,
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: kMovieTitleTextStyle.copyWith(
                      fontWeight: FontWeight.normal
                    ),
                    textWidthBasis: TextWidthBasis.parent,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    movieQuote,
                    style: kMovieGenreTextStyle.copyWith(
                        fontWeight: FontWeight.w300),
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
