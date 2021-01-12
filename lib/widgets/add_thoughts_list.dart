import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/common/constants.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/providers/app/movie_data.dart';
import 'package:sphere/screens/movie_screen.dart';
import 'package:sphere/widgets/error_panel.dart';

class AddThoughtsList extends StatefulWidget {
  final int movieId;

  AddThoughtsList({this.movieId}) : super();
  @override
  _AddThoughtsListState createState() => _AddThoughtsListState();
}

class _AddThoughtsListState extends State<AddThoughtsList> {
  final TextEditingController reviewTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool publishingThought = false;
  bool watchListing = false;
  bool watchListed = false;
  bool reviewed = false;
  String reviewId;
  String watchListId;
  String review = '';
  @override
  void initState() {
    // TODO: implement initState
    initializeMovieReviews();
    initializeWatchlist();
    super.initState();
  }
  void initializeMovieReviews() async {
    try {
      QuerySnapshot review = await _firestore.collection('reviews')
          .where('movieId', isEqualTo: widget.movieId)
          .where('userId', isEqualTo: _firebaseAuth.currentUser.uid).get();
      List<QueryDocumentSnapshot> data = review.docs;
      if(data.isNotEmpty) {
        setState(() {
          reviewTextController.text = data.first.data()['review'];
          reviewed = true;
          reviewId = data.first.id;
        });
      }
      else {
        setState(() {
          reviewed = false;
        });
      }
    }
    catch(e) {}
  }

  void initializeWatchlist() async {
    try {
      QuerySnapshot watch = await _firestore.collection('watchlist')
          .where('movieId', isEqualTo: widget.movieId)
          .where('userId', isEqualTo: _firebaseAuth.currentUser.uid).get();
      if(watch.docs.isNotEmpty) {
        setState(() {
          watchListed = true;
          watchListId = watch.docs.first.id;
        });
      }
      else {
        setState(() {
          watchListed = false;
        });

      }
    } catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 320.0,
        color: Color(0xff2F2F30),
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            MovieTile(
              movieId: widget.movieId,
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: TextField(
                controller: reviewTextController,
                maxLines: 4,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  review = value;
                },
                decoration: InputDecoration(
                    hintText: 'Add your thoughts on the movie',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: Colors.blueGrey))),
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.bottom,
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: FlatButton(
                    minWidth: double.infinity,
                    onPressed: onPublishReview,
                    color: Colors.green.shade200,
                    child: Text(
                      reviewed ? 'Update review' : 'Publish review',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (publishingThought)
                  Center(
                      child: SpinKitDoubleBounce(
                    color: Colors.lightBlue,
                    size: 20.0,
                  ))
                else
                  Container()
              ],
            ),
            Stack(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.add,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  title: Text(
                    watchListed ? 'Unlist' : 'Watchlist',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: onWatchList,
                ),
                if (watchListing)
                  Center(
                      child: SpinKitDoubleBounce(
                    color: Colors.lightBlue,
                    size: 20.0,
                  ))
                else
                  Container()
              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void> onPublishReview() async {
    if (review.trim().isEmpty) return;
    try {
      setState(() {
        publishingThought = true;
      });
      if(reviewed) {
        await _firestore.collection('reviews').doc(reviewId).
        update({'review': review});
      }
      else {
        await _firestore.collection('reviews').add({
          'movieId': widget.movieId,
          'review': review,
          'userId': _firebaseAuth.currentUser.uid
        });
      }
      setState(() {
        publishingThought = false;
      });
      initializeMovieReviews();
    } catch (e) {
      setState(() {
        publishingThought = false;
      });
    }
  }

  Future<void> onWatchList() async {
    try {
      setState(() {
        watchListing = true;
      });
      if(!watchListed) {
        await _firestore.collection('watchlist').add({
          'movieId': widget.movieId,
          'userId': _firebaseAuth.currentUser.uid
        });
      } else {
        await _firestore.collection('watchlist').doc(watchListId)
            .delete();
      }
      setState(() {
        watchListing = false;
      });
      initializeWatchlist();
    } catch (e) {
      setState(() {
        watchListing = false;
      });
    }
  }
}

class MovieTile extends StatelessWidget {
  const MovieTile({Key key, @required this.movieId}) : super(key: key);

  final int movieId;

  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context);
    Movie movie = appService.movies[movieId];
    return ListTile(
      leading: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
            color: Color(0xff2F2F30),
            borderRadius: BorderRadius.circular(10.0),
            image: movie.movie != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        '$assetBaseUrl${movie.movie['poster_path']}'))
                : null),
        clipBehavior: Clip.hardEdge,
      ),
      title: renderTitle(movie),
      subtitle: renderGenres(appService),
      onTap: () {
        appService.fetchMovieCredits(movieId);
        appService.fetchMoviePosters(movieId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieScreen(
              movieId: movieId,
            ),
          ),
        );
      },
    );
  }

  Widget renderTitle(Movie movie) {
    if (movie.fetchingMovie)
      return SpinKitCircle(
        color: Colors.lightBlue,
        size: 10.0,
      );
    else if (movie.fetchingMovieFailed)
      return ErrorPanel();
    else
      return Text(
        movie.movie['title'],
        style: kMovieTitleTextStyle,
        overflow: TextOverflow.ellipsis,
      );
  }

  Widget renderGenres(AppService appService) {
    Movie movie = appService.movies[movieId];
    if (movie.fetchingMovie || movie.fetchingMovieFailed)
      return Text('');
    else {
      final genres = movie.movie['genres'].map((e) => e['name']).toList();
      return Text(
        genres.join(', '),
        style: kMovieGenreTextStyle,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}
