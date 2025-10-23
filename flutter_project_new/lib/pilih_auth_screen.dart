import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'register_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'home_screen.dart';

class PilihAuthScreen extends StatelessWidget {
  const PilihAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.45, 0.6, 1.0],
                colors: [
                  Colors.white,
                  Colors.white,
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),

          // Wavy lines overlay
          CustomPaint(size: Size.infinite, painter: WavyPainter()),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Lanjutkan dengan',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  // Spacing yang lebih besar
                  SizedBox(height: size.height * 0.15),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Fixed height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Fixed height
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login dengan Google
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Fixed height
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _signInWithGoogle(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 22,
                            height: 22,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(width: 22, height: 22),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Login dengan Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Spacer dibiarkan untuk spacing yang lebih natural
                  const Spacer(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder layar Login
// Removed placeholder LoginScreen to use the real one from login_screen.dart

class WavyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0).withOpacity(0.06)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..isAntiAlias = true;

    final double left = 0;
    final double right = size.width;
    final double topOffset = 60;
    final double spacing = 28;

    for (int i = 0; i < 4; i++) {
      final Path path = Path();
      final double dy = topOffset + i * spacing;
      path.moveTo(left, dy);

      // create 3 bezier segments forming a smooth wave
      path.cubicTo(
        right * 0.15,
        dy - 10 - i * 6,
        right * 0.35,
        dy + 40 + i * 6,
        right * 0.5,
        dy + 20 + i * 4,
      );
      path.cubicTo(
        right * 0.65,
        dy - 4 - i * 4,
        right * 0.85,
        dy + 40 + i * 6,
        right,
        dy + 28 - i * 2,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> _signInWithGoogle(BuildContext context) async {
  try {
    UserCredential userCredential;
    if (kIsWeb) {
      // Web: gunakan popup provider langsung dari Firebase Auth
      final googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});
      userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Android/iOS: gunakan plugin google_sign_in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    }
    if (context.mounted) {
      // Opsional: info singkat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil login: ${userCredential.user?.displayName ?? 'Pengguna'}')),
      );
      // Arahkan ke Home dan hapus route sebelumnya
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login Google gagal: $e')),
    );
  }
}
