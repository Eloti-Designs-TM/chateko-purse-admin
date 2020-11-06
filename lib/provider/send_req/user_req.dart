import 'package:bed_admin/models/user/user.dart';
import 'package:bed_admin/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final usersRef = Firestore.instance.collection('users');

class UserReqs with ChangeNotifier {
  User currentUser;
  Stream<QuerySnapshot> resultFromUserColloection;
  TextEditingController searchController = TextEditingController();


   getAllUsersFromFirestore() {
    final data = usersRef.snapshots();
    resultFromUserColloection = data;
    notifyListeners();
  }

  handleSearch(String query) async {
    Stream<QuerySnapshot> search =
        userRef.where('email', isEqualTo: query).snapshots();
    resultFromUserColloection = search;
    print(search);
    notifyListeners();
  }

  getCurrentUser(context, {String userID}) async {
    DocumentSnapshot documents = await userRef.document(userID).get();
    currentUser = User.fromDocument(documents);
    notifyListeners();
  }

  updateProfileInfo({
    String firstName,
    @required String uid,
    String lastName,
    String email,
    String phone,
    String address,
  }) async {
    try {
      await userRef.document(uid).updateData({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'fullname': '$firstName $lastName',
        'address': address,
      });
      print('200');
      Fluttertoast.showToast(
        backgroundColor: Colors.black.withOpacity(.8),
        msg: "Updated",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        timeInSecForIosWeb: 8,
      );
    } catch (e) {
      print('Not sent');
       Fluttertoast.showToast(
        backgroundColor: Colors.black.withOpacity(.8),
        msg: "Not Updated",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        timeInSecForIosWeb: 8,
      );
    }
    notifyListeners();
  }
}
