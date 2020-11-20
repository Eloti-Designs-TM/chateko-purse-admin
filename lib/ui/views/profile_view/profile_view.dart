import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/ui/views/profile_view/widget/select_image.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/text_field_wid.dart';
import 'package:chateko_purse_admin/view_models/profile_view_model/profile_view_model.dart';
import 'package:chateko_purse_admin/view_models/start_view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final Users users;
  const ProfileView({Key key, this.users}) : super(key: key);
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<ProfileViewModel>(context);

    widget.users == null ? null : profileModel.setUserToField(widget.users);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            child: profileModel.profileState ==
                                    ProfileState.Loading
                                ? Center(child: CircularProgressIndicator())
                                : null,
                            backgroundImage: widget.users == null
                                ? null
                                : NetworkImage(widget.users.imageUrl),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: 90,
                          child: Tooltip(
                            message: 'Add Image',
                            child: MaterialButton(
                              onPressed: () =>
                                  selectImage(context, widget.users),
                              color: Colors.white,
                              shape: CircleBorder(),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.add_a_photo,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Change Photo',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    TextFieldWidRounded(
                      title: 'Full Name',
                      leadingIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      controller: profileModel.fullNameController,
                    ),
                    TextFieldWidRounded(
                      title: 'Phone',
                      leadingIcon: Icons.person_outline,
                      keyboardType: TextInputType.phone,
                      controller: profileModel.phoneController,
                    ),
                    TextFieldWidRounded(
                      title: 'Email',
                      leadingIcon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      controller: profileModel.emailController,
                    ),
                    TextFieldWidRounded(
                      title: 'Address',
                      leadingIcon: Icons.person_outline,
                      keyboardType: TextInputType.streetAddress,
                      controller: profileModel.addressController,
                      maxLine: 2,
                    ),
                    Divider(height: 20),
                    TextFieldWidRounded(
                      title: 'Bank Name',
                      keyboardType: TextInputType.name,
                      controller: profileModel.bankNameController,
                      validator: AuthViewModel.validateName,
                    ),
                    TextFieldWidRounded(
                      title: 'Account Name',
                      keyboardType: TextInputType.name,
                      validator: AuthViewModel.validateName,
                      controller: profileModel.acctNameController,
                    ),
                    TextFieldWidRounded(
                      title: 'Account Number',
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return 'Account Number can\'t be empty.';
                        }
                        if (v.trim().length < 10) {
                          return 'Account Number must be 10 digit';
                        }
                        if (v.trim().length > 20) {
                          return 'Account Number must be 10 digit';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: profileModel.acctNumberController,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GradiantButton(
                        isOutline: false,
                        title: 'Update',
                        onPressed: () {
                          profileModel.updateProfile(context, widget.users);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
