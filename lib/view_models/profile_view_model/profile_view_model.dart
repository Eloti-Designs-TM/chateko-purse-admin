import 'dart:io';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/auth_api/auth_api.dart';
import 'package:chateko_purse_admin/services/users_api/users_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/snacks.dart';
import 'package:chateko_purse_admin/ui/views/widget/toast.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Im;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../base_view_model.dart';

enum ProfileState { Initial, Loading, Done }

class ProfileViewModel extends BaseViewModel {
  final StorageReference storageRef = FirebaseStorage.instance.ref();

  TextEditingController fullNameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController acctNameController = TextEditingController();
  TextEditingController acctNumberController = TextEditingController();
  final authApi = GetIt.I.get<AuthApi>();
  final userApi = GetIt.I.get<UserApi>();

  File imagefile;
  final picker = ImagePicker();
  String postId = Uuid().v4();
  bool isUploadingForImage = false;
  bool isUploading = false;
  String message;
  String imageUrl;
  ProfileState profileState = ProfileState.Initial;

  setUserToField(Users users) {
    fullNameController.text = users.fullName;
    emailController.text = users.email;
    phoneController.text = users.phone;
    addressController.text = users.address;
    acctNameController.text = users.accountName;
    acctNumberController.text = users.accountNumber;
    bankNameController.text = users.bankName;

    passwordController.text = '******';
  }

  handleTakePhoto(BuildContext context, Users users) async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    imagefile = File(pickedFile.path);
    isUploadingForImage = true;
    profileState = ProfileState.Loading;
    notifyListeners();

    await compresImage();
    await uploadImage(file: imagefile, users: users);
    await userApi.updateProfilePicture(
        userId: users.userID, imageUrl: imageUrl);
    await authApi.getCurrentUser(users.userID);
    profileState = ProfileState.Initial;

    showToast('Image Added');
    notifyListeners();
  }

  handleChoosePhoto(BuildContext context, Users users) async {
    profileState = ProfileState.Loading;
    notifyListeners();

    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imagefile = File(pickedFile.path);
    isUploadingForImage = true;
    profileState = ProfileState.Loading;
    notifyListeners();

    await compresImage();
    await uploadImage(file: imagefile, users: users);
    await userApi.updateProfilePicture(
        userId: users.userID, imageUrl: imageUrl);
    await authApi.getCurrentUser(users.userID);
    profileState = ProfileState.Initial;
    showSnackbarSuccess(context, msg: 'Successfully, added image!');
    notifyListeners();
  }

  handleClearImage() {
    imagefile = null;
    imageUrl = '';
    showToast('Image Cleared');
    notifyListeners();
  }

  compresImage() async {
    if (imagefile != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      Im.Image imageFile = Im.decodeImage(imagefile.readAsBytesSync());
      final compressImageFile = File('$path/img_$postId.jpg')
        ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
      imagefile = compressImageFile;
      notifyListeners();
    } else {
      imagefile = File('');
    }
  }

  uploadImage({File file, Users users}) async {
    try {
      isUploadingForImage = true;
      StorageUploadTask uploadTask = storageRef
          .child("users_pictures/${users.userID}/${users.fullName}$postId.jpg")
          .putFile(file);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      imageUrl = downloadUrl;
      isUploadingForImage = false;
    } catch (e) {
      isUploadingForImage = false;
      message = e.toString();
      print(e);
    }
    notifyListeners();
  }

  changePicture() {}

  updateProfile(BuildContext context, Users users) async {
    if (users.fullName != fullNameController.text) {
      await authApi.userRef.doc(users.userID).update({
        'fullName': '${fullNameController.text}',
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Name');
    }

    if (users.phone != phoneController.text) {
      await authApi.userRef.doc(users.userID).update({
        'phone': phoneController.text,
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Phone Number');
    }
    if (users.address != addressController.text) {
      await authApi.userRef.doc(users.userID).update({
        'address': addressController.text,
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Address');
    }
    if (users.email != emailController.text) {
      await authApi.updateEmail(emailController.text);
      await authApi.userRef.doc(users.userID).update({
        'email': emailController.text,
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Email');
    }

    if (users.bankName != bankNameController.text) {
      await authApi.userRef.doc(users.userID).update({
        'bankName': bankNameController.text,
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Bank Name');
    }
    if (users.accountName != acctNameController.text) {
      await authApi.userRef.doc(users.userID).update({
        'accountName': acctNameController.text,
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Account Name');
    }
    if (users.accountNumber != acctNumberController.text) {
      await authApi.userRef.doc(users.userID).update({
        'accountNumber': acctNumberController.text,
      });
      showSnackbarSuccess(context, msg: 'Successfully Updated Account Number');
    }
  }
}
