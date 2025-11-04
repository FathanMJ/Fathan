class ApiConfig {
  // Base URL untuk Laravel Backend
  // Gunakan alamat sesuai platform:
  // - Android Emulator: 10.0.2.2 (mengarah ke localhost mesin host)
  // - iOS Simulator/Windows/Mac/Linux desktop: 127.0.0.1 atau localhost
  // - Device fisik: IP komputer Anda di jaringan lokal
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Local development (XAMPP)
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
  // static const String baseUrl = 'http://192.168.x.x:8000/api'; // Device (ganti dengan IP komputer Anda)

  // Production
  // static const String baseUrl = 'https://your-domain.com/api';

  // API Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String produk = '/produk';
  static const String pesanan = '/pesanan';
  static const String customOrder = '/custom-order';
  static const String chatRooms = '/chat/rooms';
}





