import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentService {
  /// Launch Midtrans Snap URL using the device browser / custom tab.
  static Future<void> launchSnapUrl(String snapRedirectUrl) async {
    print('🌐 PaymentService: Launching URL: $snapRedirectUrl');
    print('🌐 PaymentService: Platform - Web: $kIsWeb');

    final uri = Uri.tryParse(snapRedirectUrl);

    if (uri == null) {
      print('❌ PaymentService: Invalid URL');
      throw ArgumentError('URL Midtrans tidak valid: $snapRedirectUrl');
    }

    // For Flutter Web, use window.open
    if (kIsWeb) {
      try {
        print('🚀 PaymentService: Opening URL in new window (Web)...');
        // Use launchUrl with externalApplication for web
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_blank', // Open in new tab
        );
        print('✅ PaymentService: URL opened successfully in new window');
        return;
      } catch (e) {
        print('⚠️ PaymentService: Failed to open URL in web: $e');
        // Fallback: try to open using window.open directly
        try {
          // This will be handled by the browser
          await launchUrl(uri, mode: LaunchMode.platformDefault);
          print('✅ PaymentService: URL opened using platform default');
          return;
        } catch (e2) {
          print('❌ PaymentService: All web methods failed: $e2');
          throw Exception(
            'Tidak bisa membuka Midtrans Snap di web. URL: $snapRedirectUrl\nError: $e2',
          );
        }
      }
    }

    // For mobile platforms (Android/iOS)
    // Note: canLaunchUrl can return false on Android emulator even when URL can be launched
    // So we'll try to launch directly without checking first

    // Try different launch modes for better compatibility
    // Priority: In-app browser first (better for payment flows), then external
    String lastError = '';

    // Try 1: In-app browser (WebView) - BEST for payment flows
    // This ensures JavaScript works properly and handles redirects better
    try {
      print(
        '🚀 PaymentService: Trying in-app browser (WebView) - recommended for payments...',
      );
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
      print('✅ PaymentService: URL launched successfully in in-app browser');
      return;
    } catch (e) {
      print('⚠️ PaymentService: In-app browser failed: $e');
      lastError = e.toString();
    }

    // Try 2: External application (opens in default browser)
    // Good fallback, but may have issues with JavaScript on some emulators
    try {
      print(
        '🚀 PaymentService: Trying external application (default browser)...',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      print(
        '✅ PaymentService: URL launched successfully with external application',
      );
      return;
    } catch (e) {
      print('⚠️ PaymentService: External application failed: $e');
      lastError = e.toString();
    }

    // Try 3: Platform default (last resort)
    try {
      print('🚀 PaymentService: Trying platform default...');
      await launchUrl(uri, mode: LaunchMode.platformDefault);
      print(
        '✅ PaymentService: URL launched successfully with platform default',
      );
      return;
    } catch (e) {
      print('⚠️ PaymentService: Platform default failed: $e');
      lastError = e.toString();
    }

    // If all methods failed, throw exception
    print('❌ PaymentService: All launch methods failed');
    throw Exception(
      'Tidak bisa membuka Midtrans Snap. URL: $snapRedirectUrl\nError: $lastError',
    );
  }
}
