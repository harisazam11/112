import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _logoScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
    );
    _textFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6E4FF6), Color(0xFF5236D9), Color(0xFF2A1A8B)],
            stops: [0, 0.4, 1],
          ),
        ),
        child: Stack(children: [
          // Glow orb — top right
          Positioned(
            top: -60, right: -60,
            child: Container(
              width: 320, height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB49CFF).withAlpha(140),
              ),
            ),
          ),
          // Glow orb — bottom left
          Positioned(
            bottom: -40, left: -80,
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2DD4BF).withAlpha(90),
              ),
            ),
          ),
          // Grid overlay
          const _GridOverlay(),
          // Content
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ScaleTransition(
                scale: _logoScale,
                child: Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(96 * 0.30),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6E4FF6), Color(0xFF9F86FF), Color(0xFFC7B6FF)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x666E4FF6), blurRadius: 30, offset: Offset(0, 10)),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'CLF',
                      style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800,
                        fontSize: 30, letterSpacing: -1.2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textFade,
                  child: const Column(children: [
                    Text(
                      'Campus Lost & Found',
                      style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700,
                        color: Colors.white, letterSpacing: -0.56,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'BUITEMS · find your way back',
                      style: TextStyle(
                        fontSize: 14, color: Color(0xB3FFFFFF),
                        letterSpacing: 0.28,
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
          // Spinner at bottom
          Positioned(
            bottom: 56, left: 0, right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: const Center(
                child: SizedBox(
                  width: 28, height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Color(0x80FFFFFF)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _GridPainter()),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(20)
      ..strokeWidth = 1;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}
