import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openLinks({required String url}) {
    return _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      print('launching $url');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future openEmail(
      {required String to, required String subject, String body = ""}) async {
    String url =
        'mailto:${Uri.encodeFull(to)}?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }
}
