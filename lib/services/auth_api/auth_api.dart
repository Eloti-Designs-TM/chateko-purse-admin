import 'package:chateko_purse_admin/models/referrals/referral.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi with ChangeNotifier {
  var userRef = FirebaseFirestore.instance.collection('users');
  var referRef = FirebaseFirestore.instance.collection('refer_system');

  SharedPreferences localStorage;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Users users = Users();
  User currentFirebase;
  bool isAnonymous;
  String message;

  saveCredentials({String email, String password}) async {
    localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('email', email);
    await localStorage.setString('password', password);
  }

  Future<Users> getCurrentUser(String userID) async {
    DocumentSnapshot documents = await userRef.doc(userID).get();
    users = Users.fromDoc(documents);
    notifyListeners();

    return users;
  }

  Future<void> loginUser(context,
      {@required String email, @required String password}) async {
    final currentUser = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    await saveCredentials(email: email, password: password);
    await getCurrentUser(currentUser.user.uid);
    currentFirebase = currentUser.user;
    notifyListeners();
  }

  Future<void> signUpUser({
    @required String email,
    @required String password,
    @required String firstName,
    @required String phone,
    @required String lastName,
    @required String referralCode,
    @required String referrarCode,
  }) async {
    var referral = ReferSystem();
    final currentUser = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await userRef.doc(currentUser.user.uid).set(users.userToDoc(
        referralCode: referralCode,
        referrarCode: referrarCode,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        userID: currentUser.user.uid));
    referral.activePayment = 0;
    referral.activeReferralCount = 0;
    referral.pedingPayment = 0;
    referral.pendingReferralCount = 0;
    referral.referralCode = referralCode;
    referral.userID = currentUser.user.uid;
    await getCurrentUser(currentUser.user.uid);
    await saveCredentials(email: email, password: password);
    await referRef.doc(referralCode).set(referral.toDoc());
    currentFirebase = currentUser.user;
    notifyListeners();
  }

  void showMessage(String message) {
    message = message;
  }

  Stream<String> get onAuthStateChanged => firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  Future<void> signOut(context) async {
    await firebaseAuth.signOut();
    users = Users();
    notifyListeners();
    await localStorage.clear();
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute(builder: (ctx) => SignUpLogin()));
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  convertToEmailAndPassword({
    @required String email,
    @required String password,
    @required String firstName,
    @required String phone,
    @required String lastName,
  }) async {
    final currentUser = firebaseAuth.currentUser;
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    currentUser.linkWithCredential(credential);

    await userRef.doc(currentUser.uid).set(users.userToDoc(
        referralCode: '',
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        userID: currentUser.uid));
    await getCurrentUser(currentUser.uid);
  }

  Future<void> signInAnonymously() async {
    await firebaseAuth.signInAnonymously();
  }

  Future<void> signInWithEmailAndPasswordForSharedPref(
      {String email, String password}) async {
    final currentUser = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    await saveCredentials(email: email, password: password);
    await getCurrentUser(currentUser.user.uid);
    currentFirebase = currentUser.user;
    notifyListeners();
  }

  checkAuth() {
    firebaseAuth.authStateChanges().listen((event) {
      isAnonymous = event.isAnonymous;
      notifyListeners();
    });
  }

  updateEmail(email) async {
    User user = firebaseAuth.currentUser;
    await user.updateEmail(email);
  }

  resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
