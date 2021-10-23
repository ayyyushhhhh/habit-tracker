// ignore_for_file: file_names

import 'package:url_launcher/url_launcher.dart';

// ignore: avoid_classes_with_only_static_members
class Utils {
  static Future openLinks({required String url}) {
    return _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future openEmail({
    required String to,
    required String subject,
    String body = "",
  }) async {
    final String url =
        'mailto:${Uri.encodeFull(to)}?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }
}
