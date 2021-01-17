import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sphere/providers/app/app_provider.dart';
import 'package:sphere/widgets/add_thoughts_list.dart';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _future;
  @override
  void initState() {
    _future = _firestore
        .collection('reviews')
        .where('userId', isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppService appService = Provider.of<AppService>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
        stream: _future,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                size: 20.0,
                color: Colors.lightBlue,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'Unable to fetch reviews',
              style: TextStyle(color: Colors.amber),
            ));
          }
          if(snapshot.data.docs.length <= 0) {
            return Center(child: Text('You have no reviews yet', style: TextStyle(color: Colors.blueGrey),),);
          }
          return ListView.builder(
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
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          );
        });
  }
}
