library alghwalbi_core;

import 'package:share_plus/share_plus.dart';

//TODO: add DYNAMIC LINK Service
class DynamicLinksServices {
  static Future shareLink(String link) async {
    return Share.share(link);
  }

  static Future<String> generateShortLinkList(
      String title, String message, String type, String id) async {
    return "";
  }

  static Future<String> retrieveDynamicLink() async {
    return "";
  }
}
