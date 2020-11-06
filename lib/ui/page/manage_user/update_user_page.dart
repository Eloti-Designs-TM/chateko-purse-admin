import 'package:bed_admin/models/user/user.dart';
import 'package:bed_admin/provider/send_req/user_req.dart';
import 'package:bed_admin/provider/text_provider/textcontroller_provider.dart';
import 'package:bed_admin/services/auth_services.dart';
import 'package:bed_admin/ui/page/widget/button.dart';
import 'package:bed_admin/ui/page/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserPage extends StatefulWidget {
  final String userID;
  const UpdateUserPage({Key key, this.userID}) : super(key: key);
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: '12345');
  User currentUser;

  bool sendingUpdateReq = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser(context);
  }

  getCurrentUser(context) async {
    DocumentSnapshot documents = await userRef.document(widget.userID).get();
    if (!mounted) return;

    setState(() {
      currentUser = User.fromDocument(documents);
      TextController.firstname.text = currentUser.firstName;
      TextController.lastname.text = currentUser.lastName;
      TextController.phone.text = currentUser.phoneNo;
      TextController.email.text = currentUser.email;
      TextController.address.text = currentUser.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userReq = Provider.of<UserReqs>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(TextController.firstname.text),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFieldWid(
              title: 'First name',
              validator: NameValidator.validate,
              keyboardType: TextInputType.name,
              controller: TextController.firstname,
            ),
            TextFieldWid(
              title: 'Last name',
              validator: NameValidator.validate,
              keyboardType: TextInputType.name,
              controller: TextController.lastname,
            ),
            TextFieldWid(
              title: 'Email',
              validator: NameValidator.validate,
              keyboardType: TextInputType.name,
              controller: TextController.email,
            ),
            TextFieldWid(
              title: 'Phone',
              validator: NameValidator.validate,
              keyboardType: TextInputType.name,
              controller: TextController.phone,
            ),
            TextFieldWid(
              title: 'Address',
              validator: NameValidator.validate,
              keyboardType: TextInputType.name,
              controller: TextController.address,
            ),
            sendingUpdateReq
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            FlatButtonWid(
              buttonTitle: 'Update User',
              onTap: sendingUpdateReq
                  ? null
                  : () =>
                      _submit(context, userID: widget.userID, userReq: userReq),
            ),
          ]),
        ),
      ),
    );
  }

  _submit(BuildContext context, {String userID, UserReqs userReq}) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final form = _form.currentState;

    setState(() => sendingUpdateReq = true);
    if (form.validate()) {
      setState(() => sendingUpdateReq = true);
      if (currentUser.email != TextController.email.text) {
        auth.resetEmailNPassword(
          email: TextController.email.text,
        );
      }
      userReq.updateProfileInfo(
        uid: userID,
        firstName: TextController.firstname.text,
        lastName: TextController.lastname.text,
        phone: TextController.phone.text,
        email: TextController.email.text,
        address: TextController.address.text,
      );
      setState(() => sendingUpdateReq = false);
    } else {
      print('not validated');
      setState(() => sendingUpdateReq = false);
    }
  }
}
