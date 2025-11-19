import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  /// Launch Midtrans Snap URL using the device browser / custom tab.
  static Future<void> launchSnapUrl(String snapRedirectUrl) async {
    final uri = Uri.tryParse(snapRedirectUrl);

    if (uri == null) {
      throw ArgumentError('URL Midtrans tidak valid.');
    }

    final canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      throw Exception('Tidak bisa membuka Midtrans Snap.');
    }

    await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    );
  }
}

