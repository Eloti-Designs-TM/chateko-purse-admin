import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/view_models/ads_view_model.dart/ads_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

selectImageForAds(context) {
  final uploadProvider = Provider.of<AdsViewModel>(context, listen: false);

  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(
              child: Text(
            'Upload Image',
            style: TextStyle(fontSize: 25),
          )),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                circleButton(
                    icon: Icons.camera,
                    text: 'Camera',
                    onPressed: () {
                      uploadProvider.handleTakePhoto(context);
                    }),
                circleButton(
                    icon: Icons.collections,
                    text: 'Gallery',
                    onPressed: () async {
                      await uploadProvider.handleChoosePhoto(context);
                    }),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text('Close')
              ],
            ),
          ],
        );
      });
}
