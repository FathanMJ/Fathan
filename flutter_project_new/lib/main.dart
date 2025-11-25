import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'services/push_notification_service.dart';
import 'welcome.dart'; // <-- tambahkan import ke HomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Init FCM only for mobile platforms (not web)
    if (!kIsWeb) {
      try {
        await PushNotificationService.instance.initialize();
      } catch (e) {
        debugPrint('⚠️ PushNotificationService initialization failed: $e');
        // Continue even if push notification fails
      }
    }
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
    // Continue even if Firebase fails (for web testing)
    if (kIsWeb) {
      debugPrint('⚠️ Running without Firebase on web');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF120606),
        useMaterial3: true,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(), // <-- Navigate ke Welcome Screen dulu
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B0B0B), Color(0xFF1A0707)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo + vertical separator seperti screenshot
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/LOGO-PUTIH.png',
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Column(
                        children: [
                          const Text(
                            'Asset tidak ditemukan',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            error.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Container(width: 2, height: 80, color: Colors.white24),
                ],
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(Color(0xFFB71C1C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// Layar utama: background gradasi gelap + garis‑garis merah via CustomPainter
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // buat appbar transparan agar fokus ke background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient gelap
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2B0B0B), // very dark red
                  Color(0xFF1A0707), // almost black
                ],
              ),
            ),
          ),

          // Garis-garis dekoratif merah
          CustomPaint(size: Size.infinite, painter: RedLinesPainter()),

          // Konten utama
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB71C1C),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Painter menggambar garis‑garis merah bergaya geometris
class RedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFFB71C1C).withOpacity(0.95)
      ..isAntiAlias = true;

    final Paint glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = const Color(0xFFB71C1C).withOpacity(0.06)
      ..isAntiAlias = true;

    // jumlah garis (5 atau 6)
    final int lines = 5;
    // amplitude jag (seberapa "jigjag")
    final double amp = w * 0.06;
    // jumlah segmen per garis
    final int segments = 12;
    // jarak horizontal antar garis (renggang)
    final double gap = w / (lines + 1);

    for (int i = 0; i < lines; i++) {
      final double startX = gap * (i + 1);
      final Path p = Path();
      p.moveTo(startX, -h * 0.05);

      for (int s = 1; s <= segments; s++) {
        // posisi vertikal segmen
        final double y = (h + h * 0.1) * (s / segments) - h * 0.05;
        // zigzag offset bergantian
        final double x = startX + (s.isOdd ? amp : -amp);
        p.lineTo(x, y);
      }

      // tambahan sedikit ekstensi ke tepi bawah
      p.lineTo(startX, h + h * 0.05);

      // draw glow lalu garis utama untuk efek soft
      canvas.drawPath(p, glow);
      canvas.drawPath(p, linePaint);
    }

    // opsional: satu shape kecil kiri-bawah untuk aksen (lebih tipis)
    final Paint accent = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFFB71C1C).withOpacity(0.85)
      ..isAntiAlias = true;

    final double cx = w * 0.18;
    final double cy = h * 0.78;
    final double sizeBox = min(w, h) * 0.14;

    final Path hex = Path();
    for (int k = 0; k < 6; k++) {
      final double angle = pi / 3 * k - pi / 6;
      final double x = cx + cos(angle) * sizeBox;
      final double y = cy + sin(angle) * (sizeBox * 0.6);
      if (k == 0) {
        hex.moveTo(x, y);
      } else {
        hex.lineTo(x, y);
      }
    }
    hex.close();
    canvas.drawPath(hex, accent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
