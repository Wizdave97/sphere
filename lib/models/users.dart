import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String displayName;
  final String userId;
  final String movieQuote;
  final String favouriteMovie;
  final String photoURL;
  final String email;
  final List<dynamic> friends;

  User({
    this.userId,
    this.displayName,
    this.email,
    this.photoURL,
    this.movieQuote,
    this.favouriteMovie,
    this.friends
  });

  factory User.fromMap(Map data) {
    return User(
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoURL: data['photoURL'] ?? '',
      movieQuote: data['movieQuote'] ?? '',
      favouriteMovie: data['favouriteMovie'] ?? '',
      friends: data['friends'] ?? []
    );
  }

  static Stream<QuerySnapshot> searchUsers(String query)  {
    return _firestore.collection('users').where('nameIndex', arrayContainsAny: [query.toLowerCase()]).snapshots();
  }

  static Stream<QuerySnapshot> fetchUser(String id) {
      return  _firestore.collection('users').where('userId', isEqualTo: id).snapshots();
  }


  static Future<void> createUser(firebase_auth.User user) async {
    try {
      await _firestore.collection('users').add({
        'userId': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'favouriteMovie': '',
        'movieQuote': '',
        'friends': [],
        'nameIndex': setSearchParam(user.displayName)
      });
    } catch(e) {}
  }

  static Stream<QuerySnapshot> fetchUsers(List<dynamic> ids)  {
      return _firestore.collection('users').where('userId', whereIn: ids).snapshots();
  }
  static List<String> setSearchParam(String query) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < query.length; i++) {
      temp = temp + query[i];
      caseSearchList.add(temp.toLowerCase());
    }
    return caseSearchList;
  }

  static Future<void> addFriend(String currentUserId, String friendId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: currentUserId).get();
      dynamic data = snapshot.docs[0].data();
      String docId = snapshot.docs[0].id;
      (data['friends'] as List<dynamic>).add(friendId);
      await _firestore.collection('users').doc(docId).update({'friends': data['friends']});
    }catch(e) {print(e);}
  }

  static Future<void> removeFriend(String currentUserId, String friendId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: currentUserId).get();
      dynamic data = snapshot.docs[0].data();
      String docId = snapshot.docs[0].id;
      (data['friends'] as List<dynamic>).removeWhere((element) => element == friendId);
      await _firestore.collection('users').doc(docId).update({'friends': data['friends']});
    }catch(e) {}
  }

  static Future<bool> getIsFriend(String friendId, String currentUserId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: currentUserId)
          .where('friends', arrayContainsAny: [friendId]).get();
      if(snapshot.docs.length >= 1) return true;
      else {
        return false;
      }
    } catch(e) {
      return false;
    }
  }

  static Future<void> updateProfile(String currentUserId, Map<String, dynamic> data) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('userId',
        isEqualTo: currentUserId)
        .get();
    await _firestore
        .collection('users')
        .doc(snapshot.docs[0].id)
        .update(data);
  }
}