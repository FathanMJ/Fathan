import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'pilih_auth_screen.dart'; // <-- tambahkan import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),

          // wavy lines background (top-left)
          CustomPaint(size: Size.infinite, painter: WavyPainter()),

          // content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // header text with blue underlines per line
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderLine(text: 'Define'),
                      HeaderLine(text: 'yourself in'),
                      HeaderLine(text: 'your unique'),
                      HeaderLine(text: 'way.'),
                    ],
                  ),

                  const Spacer(),

                  // central image (replace asset path with your file)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/home_person.png',
                        width: 300,
                        height: 360,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 300,
                          height: 360,
                          color: Colors.grey[900],
                          child: const Center(
                            child: Text(
                              'Image\nmissing',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Get Started button (white background, black text/icon)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PilihAuthScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small widget to render header line + blue underline segment
class HeaderLine extends StatelessWidget {
  final String text;
  const HeaderLine({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 46,
              fontWeight: FontWeight.w800,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 6),
          // short blue underline accent
          Container(
            width: min(180, MediaQuery.of(context).size.width * 0.6),
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2EA8FF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter that draws a few soft concentric wavy lines
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
