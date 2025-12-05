/// Pusher Configuration
///
/// Update credentials ini sesuai dengan .env di Laravel backend
/// Credentials dari Pusher Dashboard: https://dashboard.pusher.com
class PusherConfig {
  // Credentials dari Pusher Dashboard
  // Update sesuai dengan credentials Anda
  static const String appKey = 'af480d882007f0d206f1';
  static const String cluster = 'ap1';

  // Pusher menggunakan host otomatis berdasarkan cluster
  // Tidak perlu set manual, Pusher akan handle
  static const bool encrypted = true;

  // Untuk development/testing, bisa override host (optional)
  // static const String host = 'ws-ap1.pusher.com';
  // static const int port = 443;
}
