import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String fullname;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String photoUrl;
  final String address;
  final String state;
  bool isAdmin;

  
  
  
    User({
      this.uid,
      this.fullname,
      this.phoneNo,
      this.photoUrl,
      this.email,
      this.firstName,
      this.lastName,
      this.address, 
      this.state, 
      this.isAdmin,

    });
  
    factory User.fromDocument(DocumentSnapshot doc) {
      return User(
        uid: doc['uid'],
        firstName: doc['firstName'],
        lastName: doc['lastName'],
        fullname: doc['fullname'],
        phoneNo: doc['phone'],
        address: doc['address'],
        state: doc['state'],
        email: doc['email'],
        photoUrl: doc['photoUrl'],
        isAdmin: doc['isAdmin'],
      );
    }
  }

