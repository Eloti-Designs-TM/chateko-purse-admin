import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Users {
  String userID;
  String referralCode;
  String referrarCode;

  String email;
  bool isNew;

  String fullName;
  String phone;
  String address;
  String imageUrl;
  double serviceValues;
  String password;
  String activateRefarral;

  String paidFirstInvestment;
  String bankName;
  String accountName;
  String accountNumber;
  bool isAdmin;

  Users(
      {this.activateRefarral,
      this.userID,
      this.email,
      this.referralCode,
      this.isNew,
      this.referrarCode,
      this.isAdmin,
      this.fullName,
      this.phone,
      this.address,
      this.serviceValues,
      this.password,
      this.accountName,
      this.accountNumber,
      this.paidFirstInvestment,
      this.bankName,
      this.imageUrl});

  factory Users.fromDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return Users(
      userID: doc.id,
      referralCode: data['referalCode'],
      referrarCode: data['referrarCode'],
      fullName: data['fullName'],
      phone: data['phone'],
      address: data['address'],
      isNew: data['new'],
      isAdmin: data['isAdmin'],
      email: data['email'],
      imageUrl: data['imageUrl'],
      password: data['password'],
      activateRefarral: data['activateRefarral'],
      serviceValues: data['serviceValue'],
      accountName: data['accountName'],
      accountNumber: data['accountNumber'],
      paidFirstInvestment: data['paidFirstInvestment'],
      bankName: data['bankName'],
    );
  }

  Map<String, dynamic> toDoc() {
    var data = Map<String, dynamic>();
    data['userID'] = this.userID;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['email'] = this.email;
    data['imageUrl'] =
        'https://firebasestorage.googleapis.com/v0/b/chateko-app.appspot.com/o/app_data%2Fapp_const_profile_image%2Fface.png?alt=media&token=41487622-65db-4b5b-9308-934f00780c79';
    data['serviceValue'] = this.serviceValues;
    return data;
  }

  Map<String, dynamic> userToDoc({
    @required String userID,
    @required String fullName,
    @required String email,
    @required String referralCode,
    String referrarCodes,
    @required String phone,
    String address,
    String imageUrl,
    double serviceValues,
    String accountName,
    String accountNumber,
    String bankName,
  }) {
    var data = Map<String, dynamic>();
    data['userID'] = userID;
    data['referalCode'] = referralCode;
    data['referrarCode'] = referrarCodes.isEmpty || referrarCodes == null
        ? 'ref-9522780'
        : referrarCodes;
    data['new'] = true;
    data['fullName'] = fullName;
    data['phone'] = phone ?? '';
    data['address'] = address ?? '';
    data['email'] = email;
    data['isAdmin'] = false;
    data['activateRefarral'] = 'pending';
    data['paidFirstInvestment'] = 'pending';
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['bankName'] = bankName;
    data['imageUrl'] = imageUrl == null
        ? 'https://firebasestorage.googleapis.com/v0/b/chateko-app.appspot.com/o/app_data%2Fapp_const_profile_image%2Fface.png?alt=media&token=41487622-65db-4b5b-9308-934f00780c79'
        : imageUrl;

    return data;
  }
}
