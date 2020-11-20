import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlsApi {
  static Future<void> launchEmail(String emailUrl) async {
    if (await canLaunch("mailto:$emailUrl")) {
      await launch("mailto:$emailUrl");
    } else {
      throw 'Could not launch';
    }
  }

  static Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openUrls(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
