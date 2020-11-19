import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateko_purse_admin/models/ads/ads.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/ads_api/ads_api.dart';
import 'package:chateko_purse_admin/ui/image_assets/images_assets.dart';
import 'package:chateko_purse_admin/ui/views/ads_view/widget/select_image.dart';
import 'package:chateko_purse_admin/ui/views/widget/alert_dialog.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_pageview.dart';
import 'package:chateko_purse_admin/ui/views/widget/slide_dots.dart';
import 'package:chateko_purse_admin/ui/views/widget/text_field_wid.dart';
import 'package:chateko_purse_admin/view_models/ads_view_model.dart/ads_view_model.dart';
import 'package:chateko_purse_admin/view_models/start_view_model/auth_view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdsView extends StatelessWidget {
  final Users users;

  const AdsView({Key key, this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AdsInjector(
      child: Consumer2<AdsApi, AdsViewModel>(
        builder: (BuildContext context, adsApi, adsModel, Widget child) {
          return StreamBuilder<QuerySnapshot>(
              stream: adsApi.getAds(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var doc = snapshot.data.docs;
                Ads ad = Ads();
                List<Ads> ads = [];
                doc.map((e) {
                  ad = Ads.fromDoc(e);
                  ads.add(ad);
                }).toList();

                if (ads.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Image.asset(ImageAssets.logoWhite),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadAds(),
                        )),
                        color: Colors.white,
                        shape: StadiumBorder(),
                        child: Text('Create ads'),
                      ),
                    ),
                    Container(
                      color: Colors.pink[900].withOpacity(.5),
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: CustomPageView.builder(
                        viewportDirection: false,
                        itemCount: ads.length,
                        controller: adsModel.pageController,
                        onPageChanged: adsModel.onPageChanged,
                        itemBuilder: (_, i) => AdsCard(ads: ads[i]),
                      ),
                    ),
                    Container(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < ads.length; i++)
                            if (i == adsModel.pageIndex)
                              SlideDotsAds(true)
                            else
                              SlideDotsAds(false)
                        ],
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}

class UploadAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdsInjector(
      child: Consumer<AdsViewModel>(
        builder: (context, ads, child) => Scaffold(
          appBar: AppBar(
            title: Text('Upload Ads'),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: ads.formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ads.imagefile != null
                        ? Image.file(ads.imagefile)
                        : circleButton(
                            color: Colors.grey[600],
                            icon: Icons.add_a_photo,
                            size: 30,
                            text: 'Add Image',
                            onPressed: () {
                              selectImageForAds(context);
                            }),
                    SizedBox(height: 20),
                    TextFieldWidRounded(
                      title: 'Link Url',
                      validator: AuthViewModel.validateLink,
                      controller: ads.linkUrlcontroller,
                    ),
                    SizedBox(height: 50),
                    GradiantButton(
                      isOutline: false,
                      buttonState: ads.buttonState,
                      title: 'Upload',
                      onPressed: ads.imagefile == null
                          ? null
                          : () async {
                              await ads.uplaodAds(context);
                              Navigator.of(context).pop();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdsCard extends StatelessWidget {
  const AdsCard({
    Key key,
    @required this.ads,
  }) : super(key: key);

  final Ads ads;

  @override
  Widget build(BuildContext context) {
    return AdsInjector(
        child: Consumer<AdsViewModel>(
      builder: (context, adsModel, child) => Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(ads.imageUrl),
          ),
        ),
        child: Container(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.black.withOpacity(.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ImagePreview(imageUrl: ads.imageUrl))),
                          color: Colors.white,
                          icon: Icon(Icons.remove_red_eye),
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                    title: 'Delete',
                                    content: 'Do you want to delete this ads',
                                    onTapYes: () async {
                                      await adsModel.adsApi
                                          .deleteAds(ads.adsID);
                                      Navigator.pop(context);
                                    },
                                  )),
                          color: Colors.white,
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    ));
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Image Preview'),
      ),
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: '$imageUrl',
              )
            : CircularNotchedRectangle(),
      )),
    );
  }
}

class AdsInjector extends StatelessWidget {
  final Widget child;

  const AdsInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AdsViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: AdsApi(),
        ),
      ],
      child: child,
    );
  }
}
