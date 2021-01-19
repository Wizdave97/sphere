import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/models/users.dart' as UserModel;

class ProfilePicture extends StatefulWidget {
  final String userId;
  final UserModel.User user;
  ProfilePicture({this.userId, this.user});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {

  final currentUserId = FirebaseAuth.instance.currentUser.uid;
  bool isFriend = false;
  bool updatingFriendStatus = false;
  @override
  void initState() {
    initializeState();
    super.initState();
  }
  void initializeState() async {
    bool status = await UserModel.User.getIsFriend(widget.userId, currentUserId);
    setState(() {
      isFriend = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoURL),
              radius: 40.0),
          SizedBox(
            width: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.displayName,
                style: kMovieTitleTextStyle,
              ),
              SizedBox(
                height: 10.0,
              ),
              if (widget.userId != currentUserId)
                MaterialButton(
                  elevation: 0.0,
                  color: updatingFriendStatus ? Colors.lightBlue.withOpacity(0.3) :Colors.lightBlue,
                  onPressed: updateFriendStatus,
                  child: Text(isFriend ? 'following' : 'follow', style: TextStyle(color: Colors.white),),
                )
              else
                SizedBox()
            ],
          ),
        ]
      ),
    );
  }

  void updateFriendStatus() async {
    if(updatingFriendStatus) return;
    setState(() {
      updatingFriendStatus = true;
    });
    if(isFriend) await UserModel.User.removeFriend(currentUserId, widget.userId);
    else await UserModel.User.addFriend(currentUserId, widget.userId);
    bool friendStatus = await UserModel.User.getIsFriend(widget.userId, currentUserId);
    setState(() {
      isFriend = friendStatus;
      updatingFriendStatus = false;
    });
  }

}
