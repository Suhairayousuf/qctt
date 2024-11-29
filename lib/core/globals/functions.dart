import 'package:url_launcher/url_launcher.dart';

Future<void> launchProfileURL(String profileUrl) async {
  final Uri uri = Uri.parse(profileUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('Could not launch $profileUrl');
  }
}
