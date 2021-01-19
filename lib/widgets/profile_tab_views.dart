import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/widgets/add_thoughts_list.dart';
import 'package:sphere/models/users.dart' as UserModel;
import 'package:sphere/widgets/person_card.dart';

class ProfileTabViews extends StatelessWidget {
  final int selectedIndex;
  final String userId;
  final UserModel.User user;
  final void Function() reloadFuture;

  ProfileTabViews(
      {this.selectedIndex, this.userId, this.user, this.reloadFuture});
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        About(userId: userId, user: user),
        WatchList(
          userId: userId,
        ),
        Reviews(userId: userId),
        Friends(
          userId: userId,
          user: user,
        )
      ],
    );
  }
}

class WatchList extends StatefulWidget {
  final String userId;
  WatchList({@required this.userId});
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _future;

  @override
  void initState() {
    _future = _firestore
        .collection('watchlist')
        .where(
          'userId',
          isEqualTo: widget.userId,
        )
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context, listen: false);
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: _future,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Unable to fetch reviews',
            style: TextStyle(color: Colors.amber),
          ));
        }
        if (ConnectionState.waiting == snapshot.connectionState) {
          return Center(
            child: SpinKitCircle(
              size: 20.0,
              color: Colors.lightBlue,
            ),
          );
        }
        if (snapshot.data.docs.length <= 0) {
          return Center(
              child: Text(
            'Your watchlist is empty',
            style: kMovieGenreTextStyle.copyWith(fontWeight: FontWeight.normal),
          ));
        }
        return Container(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              dynamic data = snapshot.data.docs[index].data();
              int movieId = data['movieId'];
              appService.fetchMovie(movieId);
              return GestureDetector(
                child: MovieTile(movieId: movieId),
                onLongPress: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return AddThoughtsList(
                          movieId: movieId,
                        );
                      });
                },
              );
            },
          ),
        );
      },
    ));
  }
}
class Reviews extends StatefulWidget {
  final String userId;
  Reviews({@required this.userId});
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _future;

  @override
  void initState() {
    _future = _firestore
        .collection('reviews')
        .where(
      'userId',
      isEqualTo: widget.userId,
    )
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context, listen: false);
    return Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _future,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                    'Unable to fetch reviews',
                    style: TextStyle(color: Colors.amber),
                  ));
            }
            if (ConnectionState.waiting == snapshot.connectionState) {
              return Center(
                child: SpinKitCircle(
                  size: 20.0,
                  color: Colors.lightBlue,
                ),
              );
            }
            if (snapshot.data.docs.length <= 0) {
              return Center(
                  child: Text(
                    'You have not reviewed any movie yet',
                    style: kMovieGenreTextStyle.copyWith(fontWeight: FontWeight.normal),
                  ));
            }
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  dynamic data = snapshot.data.docs[index].data();
                  int movieId = data['movieId'];
                  appService.fetchMovie(movieId);
                  return Card(
                      color: Color(0xff2F2F30),
                      child: GestureDetector(
                        onLongPress: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AddThoughtsList(
                                  movieId: movieId,
                                );
                              });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MovieTile(movieId: movieId),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                data['review'],
                                softWrap: true,
                                textWidthBasis: TextWidthBasis.parent,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            );
          },
        ));
  }
}
class About extends StatefulWidget {
  final String userId;
  final UserModel.User user;
  About({@required this.userId, @required this.user});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;
  TextEditingController movieQuoteController;
  TextEditingController favMovieController;
  bool updatingProfile = false;
  String docId;
  @override
  void initState() {
    movieQuoteController = TextEditingController(text: widget.user.movieQuote);
    favMovieController =
        TextEditingController(text: widget.user.favouriteMovie);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant About oldWidget) {
      if(oldWidget.user != widget.user) {
        movieQuoteController.text = widget.user.movieQuote;
        favMovieController.text =   widget.user.favouriteMovie;
      }
    super.didUpdateWidget(oldWidget);
  }
@override
  void deactivate() {
    movieQuoteController.dispose();
    favMovieController.dispose();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    UserModel.User user = widget.user;
    return Container(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.email,
              color: Colors.white,
            ),
            title: Text(
              user.email,
              style: kMovieGenreTextStyle.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Favourite movie quote',
              style: kMovieGenreTextStyle,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: movieQuoteController,
              maxLines: 3,
              maxLength: 150,
              readOnly: currentUserId != widget.userId,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.0, color: Colors.blueGrey))),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Favourite Movie',
              style: kMovieGenreTextStyle,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: favMovieController,
              maxLines: 1,
              readOnly: currentUserId != widget.userId,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.0, color: Colors.blueGrey))),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          if (currentUserId == widget.userId)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: FlatButton(
                onPressed: updateProfile,
                color: updatingProfile
                    ? Colors.teal.withOpacity(0.3)
                    : Colors.teal,
                child: Text('Update Profile'),
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    if (updatingProfile) return;
    setState(() {
      updatingProfile = true;
    });
    try {
      await UserModel.User.updateProfile(currentUserId, {
        'favouriteMovie': favMovieController.text,
        'movieQuote': movieQuoteController.text
      });
      SnackBar _snackbar = SnackBar(content: Text('Profile update successful'));
      Scaffold.of(context).showSnackBar(_snackbar);
      setState(() {
        updatingProfile = false;
      });
    } catch (e) {
      setState(() {
        updatingProfile = false;
      });
      SnackBar _snackbar = SnackBar(content: Text('Profile update failed'));
      Scaffold.of(context).showSnackBar(_snackbar);
    }
  }
}

class Friends extends StatefulWidget {
  final String userId;
  final UserModel.User user;
  Friends({this.userId, this.user});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  Stream<QuerySnapshot> future;
  @override
  void initState() {
    future = UserModel.User.fetchUsers(
        widget.user.friends.isNotEmpty ? widget.user.friends : ['']);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Friends oldWidget) {
    if (oldWidget.user != widget.user) {
      setState(() {
        future = UserModel.User.fetchUsers(
            widget.user.friends.isNotEmpty ? widget.user.friends : ['']);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: future,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred, try again'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitCircle(
            color: Colors.lightBlue,
            size: 10.0,
          ));
        }
        List<QueryDocumentSnapshot> docs = snapshot.data.docs;
        if (docs.length <= 0) {
          return Center(
            child: Text(
              'Try making more friends',
              style:
                  kMovieGenreTextStyle.copyWith(fontWeight: FontWeight.normal),
            ),
          );
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final user = UserModel.User.fromMap(docs[index].data());
            return PersonCard(
              photoURL: user.photoURL,
              displayName: user.displayName,
              movieQuote: user.movieQuote,
              userId: user.userId,
            );
          },
        );
      },
    );
  }
}
