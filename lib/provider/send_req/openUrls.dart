import 'package:flutter/foundation.dart';
// import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenUrls with ChangeNotifier {
  // openMap(String mapAddr) {
  //   MapsLauncher.launchQuery(mapAddr);
  // }
  

  Future<void> launchEmail(String emailUrl) async {
    if (await canLaunch("mailto:$emailUrl")) {
      await launch("mailto:$emailUrl");
    } else {
      throw 'Could not launch';
    }
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openUrls(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
