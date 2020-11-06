import 'package:bed_admin/models/user/user.dart';
import 'package:bed_admin/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final rideRef = Firestore.instance.collection('pickMeUp');

class RideReq with ChangeNotifier {
  User currentUser;
  Stream<QuerySnapshot> resultFromUserColloection;
  TextEditingController searchController = TextEditingController();

  void getAllRidesFromFirestore()  {
    final data = rideRef.snapshots();
    resultFromUserColloection = data;
    notifyListeners();
  }

  handleSearch(String query) async {
    Stream<QuerySnapshot> search =
    
        rideRef.where('email', isEqualTo: query).snapshots();
      resultFromUserColloection = search;
      notifyListeners();
  }



  // Future getDataFromFireStore(userID) async {

  // }
}
