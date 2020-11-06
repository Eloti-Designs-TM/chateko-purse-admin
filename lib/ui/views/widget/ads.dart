import 'package:chateko_purse_admin/models/ads/ads.dart';
import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/services/ads_api/ads_api.dart';
import 'package:chateko_purse_admin/ui/image_assets/images_assets.dart';
import 'package:chateko_purse_admin/ui/views/widget/custom_pageview.dart';
import 'package:chateko_purse_admin/ui/views/widget/slide_dots.dart';
import 'package:chateko_purse_admin/view_models/ads_view_model.dart/ads_view_model.dart';
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
                  children: [
                    Container(
                      color: Colors.pink[900].withOpacity(.5),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: CustomPageView.builder(
                        viewportDirection: false,
                        itemCount: ads.length,
                        controller: adsModel.pageController,
                        onPageChanged: adsModel.onPageChanged,
                        itemBuilder: (_, i) => Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(ads[i].imageUrl),
                            ),
                          ),
                        ),
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
