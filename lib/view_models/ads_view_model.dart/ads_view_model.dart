import 'dart:io';
import 'package:chateko_purse_admin/services/ads_api/ads_api.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/snacks.dart';
import 'package:chateko_purse_admin/ui/views/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../base_view_model.dart';
import 'package:image/image.dart' as Im;

class AdsViewModel extends BaseViewModel {
  int pageIndex = 0;
  PageController pageController;
  TextEditingController linkUrlcontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AdsViewModel() {
    pageController = PageController(viewportFraction: 0.8);
  }

  void onPageChanged(int pageIndex) {
    this.pageIndex = pageIndex;
    notifyListeners();
  }

  void onTapChangePageView(int pageIndeX) {
    pageController.animateToPage(
      pageIndeX,
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
    notifyListeners();
  }

  final StorageReference storageRef = FirebaseStorage.instance.ref();
  final adsApi = GetIt.I.get<AdsApi>();

  File imagefile;
  final picker = ImagePicker();
  String postId = Uuid().v4();
  bool isUploadingForImage = false;
  bool isUploading = false;
  String message;
  String imageUrl;
  // ProfileState profileState = ProfileState.Initial;

  ButtonState buttonState = ButtonState.Initial;

  uplaodAds(context) async {
    final form = formKey.currentState;
    buttonState = ButtonState.Loading;
    if (form.validate()) {
      buttonState = ButtonState.Loading;
      await compresImage();
      await uploadImage(file: imagefile);
      await adsApi.uploadAds(
          DateTime.now().toString(), imageUrl, linkUrlcontroller.text);
      imagefile = null;
      imageUrl = '';
      buttonState = ButtonState.Initial;
      notifyListeners();
      linkUrlcontroller.clear();
      showSnackbarSuccess(context, msg: 'Successfully, added image!');
    } else {}
  }

  handleTakePhoto(BuildContext context) async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    imagefile = File(pickedFile.path);
    isUploadingForImage = true;
    notifyListeners();
    await compresImage();

    notifyListeners();
  }

  handleChoosePhoto(BuildContext context) async {
    notifyListeners();
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imagefile = File(pickedFile.path);
    isUploadingForImage = true;
    await compresImage();

    // profileState = ProfileState.Loading;
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

  uploadImage({File file}) async {
    try {
      isUploadingForImage = true;
      StorageUploadTask uploadTask =
          storageRef.child("app_data/ads/$postId.jpg").putFile(file);
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

  loop(context) {}
}
