import 'package:url_launcher/url_launcher.dart';

Future<void> launchProfileURL(String profileUrl) async {

  final Uri uri = Uri.parse(profileUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('Could not launch $profileUrl');
  }
}
Future<void> launchURL( String url) async {
  final Uri uri = Uri.parse(url);  // Parse the URL properly
  if (await canLaunchUrl(uri)) {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);  // Open in the browser
    } catch (e) {
      print('Could not launch $url: $e');
    }
  } else {
    print('Invalid URL or no app available to handle the URL: $url');
  }
}
