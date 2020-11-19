import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdsApi extends ChangeNotifier {
  var adsRef = FirebaseFirestore.instance.collection('ads');
  Stream<QuerySnapshot> getAds() {
    return adsRef.snapshots();
  }

  uploadAds(String id, String imageUrl, String linkUrl) async {
    await adsRef.doc().set({
      "id": id,
      "imageUrl": imageUrl,
      "linkUrl ": linkUrl,
    });
  }

  deleteAds(String id) async {
    await adsRef.doc(id).delete();
  }
}
