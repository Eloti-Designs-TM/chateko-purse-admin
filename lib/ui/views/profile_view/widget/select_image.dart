import 'package:chateko_purse_admin/models/user/user.dart';
import 'package:chateko_purse_admin/ui/views/widget/button.dart';
import 'package:chateko_purse_admin/view_models/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

selectImage(context, Users users) {
  final uploadProvider = Provider.of<ProfileViewModel>(context, listen: false);

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
                      uploadProvider.handleTakePhoto(context, users);
                    }),
                circleButton(
                    icon: Icons.collections,
                    text: 'Gallery',
                    onPressed: () async {
                      await uploadProvider.handleChoosePhoto(context, users);
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
