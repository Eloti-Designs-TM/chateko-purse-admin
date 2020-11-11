import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserApi with ChangeNotifier {
  final usersRef = FirebaseFirestore.instance.collection('users');
  Users user;
  Stream<QuerySnapshot> resultFromUserColloection;
  TextEditingController searchController = TextEditingController();

  getAllUsersFromFirestore() {
    final data = usersRef.snapshots();
    resultFromUserColloection = data;
    notifyListeners();
  }

  handleSearch(String query) async {
    Stream<QuerySnapshot> search =
        usersRef.where('email', isEqualTo: query).snapshots();
    resultFromUserColloection = search;
    print(search);
    notifyListeners();
  }

  Stream<DocumentSnapshot> getCurrentUser({String userID}) async* {
    yield* usersRef.doc(userID).snapshots();
  }

  int userCount = 0;

  UserApi() {
    userLength();
  }

  userLength() {
    var userDoc = usersRef.get();
    userDoc.then((value) {
      userCount = value.docs.length;
      notifyListeners();
    });
  }

  Future<void> createUser({Map<String, dynamic> doc, String userId}) async {
    try {
      await usersRef.doc(userId).set(doc);
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> deleteUser({String userId, Map<String, dynamic> doc}) async {
    try {
      await usersRef.doc(userId).delete();
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> updateUser({String userId, Map<String, dynamic> doc}) async {
    try {
      await usersRef.doc(userId).update({});
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> updateProfilePicture({String userId, String imageUrl}) async {
    try {
      await usersRef.doc(userId).update({
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
