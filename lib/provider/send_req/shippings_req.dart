import 'package:bed_admin/models/user/user.dart';
import 'package:bed_admin/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final shippingsRef = Firestore.instance.collection('shipments');

class ShippinReqs with ChangeNotifier {
  User currentUser;
  Stream<QuerySnapshot> resultFromUserColloection;
  TextEditingController searchController = TextEditingController();

 

  getAllShippingsFromFirestore() {
    final data = shippingsRef.snapshots();
    resultFromUserColloection = data;
    print(data);
    notifyListeners();
  }

  handleSearch(String query) async {
    Stream<QuerySnapshot> search = 
        shippingsRef.where('orderID', isEqualTo: query).snapshots();
    resultFromUserColloection =  search;
 
    notifyListeners();
  }

  updateShippingStatus({String shippingID, String updateStatus}) async {
    try {
      await shippingsRef.document(shippingID).updateData({
        'status': updateStatus,
      });
      print('done');
      Fluttertoast.showToast(
        backgroundColor: Colors.black.withOpacity(.8),
        msg: "$updateStatus status Updated",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        timeInSecForIosWeb: 8,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: Colors.black.withOpacity(.8),
        msg: "$updateStatus NOT status Updated",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        timeInSecForIosWeb: 8,
      );
    }
    notifyListeners();
  }

  // getCurrentUser(context) async {
  //   final auth = Provider.of<AuthService>(context, listen: false);
  //   DocumentSnapshot documents = await userRef.document(auth.userUID).get();
  //     currentUser = User.fromDocument(documents);

  //   // getDataFromFireStore(currentUser.uid);
  // }

  // Future getDataFromFireStore(userID) async {

  // }
}
