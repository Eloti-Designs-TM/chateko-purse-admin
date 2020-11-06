import 'dart:io';
import 'package:bed_admin/models/user/user.dart';
import 'package:bed_admin/provider/text_provider/textcontroller_provider.dart';
import 'package:bed_admin/ui/page/auth_page/login_page/login.dart';
import 'package:bed_admin/ui/page/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRef = Firestore.instance.collection('users');
SharedPreferences localStorage;

class AuthService with ChangeNotifier {
  static final GlobalKey<ScaffoldState> registerScaffoldkey =
      GlobalKey<ScaffoldState>(debugLabel: '0');
  static final GlobalKey<ScaffoldState> loginScaffoldkey =
      GlobalKey<ScaffoldState>(debugLabel: '1');

  persistSave({String email, String password}) async {
    localStorage = await SharedPreferences.getInstance();
    // print('${localStorage.get('email').toString()}');
    await localStorage.setString('email', email);
    await localStorage.setString('password', password);
  }

  User user;
  String message;
  bool isLoading = false;

  AuthService() {
    user = User();
  }

  String userUID;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<String> currentUSER() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  // Email & Password Sign Up
  // createUserWithEmailAndPassword(context,
  //     {String email, String password, String name}) async {
  //   final sendRequest = Provider.of<SendRequests>(context, listen: false);
  //   final auth = Provider.of<AuthService>(context, listen: false);
  //   isLoading = true;

  //   try {
  //     isLoading = true;

  //     final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     userUID = currentUser.user.uid;

  //     await sendRequest.createNewUserInFirestore(
  //       context,
  //       uid: auth.userUID,
  //       firstName: TextController.firstname.text,
  //       lastName: TextController.lastname.text,
  //       address: '',
  //       fullname:
  //           "${TextController.firstname.text} ${TextController.lastname.text}",
  //       phone: TextController.phone.text,
  //       email: TextController.email.text,
  //       isAdmin: false,
  //     );

  //     await persistSave(
  //         email: TextController.email.text.toString(),
  //         password: TextController.password.text.toString());

  //     DocumentSnapshot documents = await userRef.document(auth.userUID).get();
  //     user = User.fromDocument(documents);

  //     // Update the username
  //     // await updateUserName(name, currentUser.user);
  //     print(currentUser.user.email);
  //     SnackBar snackbar = SnackBar(
  //       content: Text(
  //         'Hello ${user.fullname}!',
  //         style: TextStyle(
  //           color: Colors.green,
  //         ),
  //       ),
  //       duration: Duration(seconds: 4),
  //     );
  //     await getCurrentUser();
  //     registerScaffoldkey.currentState.showSnackBar(snackbar);
  //     isLoading = false;

  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (ctx) => AddressPage()));

  //     print(currentUser.user.email);
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     message = e.message;
  //     isLoading = false;
  //     SnackBar snackbar = SnackBar(
  //       content: Text(message),
  //       duration: Duration(seconds: 4),
  //     );
  //     registerScaffoldkey.currentState.showSnackBar(snackbar);
  //   }
  //   notifyListeners();
  // }

  // Future updateUserName(String name, FirebaseUser currentUser) async {
  //   var userUpdateInfo = UserUpdateInfo();
  //   userUpdateInfo.displayName = name;
  //   await currentUser.updateProfile(userUpdateInfo);
  //   await currentUser.reload();
  // }

  // Email & Password Sign In
  signInWithEmailAndPassword(context, {String email, String password}) async {
    try {
      isLoading = true;

      final currentUser = (await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
      userUID = currentUser.user.uid;

      var currentAdmin = await userRef.document(userUID).get();

      user = User.fromDocument(currentAdmin);
      print(user.isAdmin);

      if (user.isAdmin == true) {
        await persistSave(
            email: TextController.email.text.toString(),
            password: TextController.password.text.toString());
        SnackBar snackbar = SnackBar(
          content: Text(
            'Welcome back, BED Admin!',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          duration: Duration(seconds: 4),
        );

        loginScaffoldkey.currentState.showSnackBar(snackbar);
        isLoading = false;
        navigateToHome(context);
      } else {
        _firebaseAuth.signOut();
        SnackBar snackbar = SnackBar(
          content: Text(
            'You are not an Admin',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 4),
        );
        loginScaffoldkey.currentState.showSnackBar(snackbar);
        isLoading = false;
      }

      notifyListeners();
    } catch (e) {
      print(e);
      message = e.message;
      isLoading = false;
      SnackBar snackbar = SnackBar(
        content: Text(message),
        duration: Duration(seconds: 4),
      );
      loginScaffoldkey.currentState.showSnackBar(snackbar);
    }
    notifyListeners();
  }

  navigateToHome(context) {
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
    });
  }

  // Sign Out
  signOut(context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    localStorage.clear();
    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future resetEmailNPassword({String email}) async {
    try {
      FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
      await firebaseUser.updateEmail(email);
      Fluttertoast.showToast(
        backgroundColor: Colors.black.withOpacity(.8),
        msg: "Updated Email",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        timeInSecForIosWeb: 8,
      );
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        backgroundColor: Colors.black.withOpacity(.8),
        msg: "${e.message}",
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        timeInSecForIosWeb: 8,
      );
    }
  }

  // Create Anonymous User
  // Future singInAnonymously() {
  //   return _firebaseAuth.signInAnonymously();
  // }

  // Future convertUserWithEmail(
  //     String email, String password, String name) async {
  //   final currentUser = await _firebaseAuth.currentUser();

  //   final credential =
  //       EmailAuthProvider.getCredential(email: email, password: password);
  //   await currentUser.linkWithCredential(credential);
  //   await updateUserName(name, currentUser);
  // }

  // Future convertWithGoogle() async {
  //   final currentUser = await _firebaseAuth.currentUser();
  //   final GoogleSignInAccount account = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication _googleAuth = await account.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     idToken: _googleAuth.idToken,
  //     accessToken: _googleAuth.accessToken,
  //   );
  //   await currentUser.linkWithCredential(credential);
  //   await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  // }

  // GOOGLE
  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount account = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication _googleAuth = await account.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     idToken: _googleAuth.idToken,
  //     accessToken: _googleAuth.accessToken,
  //   );
  //   return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  // }

  signInWithEmailAndPasswordForSharedPref(context,
      {String email, String password}) async {
    try {
      final currentUser = (await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
      userUID = currentUser.user.uid;

      navigateToHome(context);
      notifyListeners();
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('ERROR'),
                content: Text(e.message.toString()),
                actions: [
                  FlatButton(onPressed: () => exit(0), child: Text('OK')),
                  FlatButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                      child: Text('Try Again')),
                ],
              ));
    }
    notifyListeners();
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class AddressValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Address can't be empty";
    }
    if (value.length < 5) {
      return "Address must be at least 5 characters long";
    }
    if (value.length > 100) {
      return "Address must be less than 100 characters long";
    }
    return null;
  }
}

class PhoneValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Number can't be empty";
    }
    if (value.trim().length < 9) {
      return "Invalid number";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    if (!value.contains('@')) {
      return 'invalid email';
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    if (value.trim().length <= 7) {
      return "Password must not be less than 8";
    }
    return null;
  }
}

class QtyWeightValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Field can't be empty";
    }
    return null;
  }
}
