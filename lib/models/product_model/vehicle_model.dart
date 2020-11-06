import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class VehicleModel {
  final String vehicleID;
  final String vehicleName;
  final String vehicleDescription;
  final int vehicleValuePrice;
  final List<String> vehicleWeightValue;
  final String imageUrl;
  final IconData icon;


  VehicleModel({this.vehicleWeightValue, this.imageUrl, this.icon, this.vehicleID, this.vehicleName, this.vehicleDescription, this.vehicleValuePrice});

  factory VehicleModel.fromFirestore(DocumentSnapshot doc){
    var data = doc.data;

    return VehicleModel(
      vehicleID: data['vehicleID'] as String,
      vehicleName: data['vehicleName'] as String,
      vehicleDescription: data['vehicleDescription'] as String,
      vehicleValuePrice: data['vehicleValuePrice'],
      vehicleWeightValue: List.from(data['vehicleWeightValue']),
      imageUrl: data['imageUrl'] as String,

    );
  }
}


