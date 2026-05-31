import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/theme_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final theme = context.watch<ThemeProvider>();
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: Column(children: [
        // Hero section
        Expanded(
          flex: 54,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6E4FF6), Color(0xFF5236D9), Color(0xFF2A1A8B)],
                stops: [0, 0.6, 1],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Stack(children: [
              const _GridOverlay(opacity: 0.4),
              // Glow blobs
              Positioned(top: -80, right: -60, child: _blob(280, const Color(0xFFB49CFF), 0.55)),
              Positioned(bottom: -60, left: -40, child: _blob(240, const Color(0xFF2DD4BF), 0.35)),
              // Floating cards
              Positioned(top: 80, left: 24, child: _floatCard('LOST', 'Student ID', Icons.credit_card, const Color(0xFFFFEAE7), const Color(0xFFF25C54), const Color(0xFF8E1F18), 0, _floatCtrl)),
              Positioned(top: 160, right: 30, child: _floatCard('FOUND', 'Calculator', Icons.calculate, const Color(0xFFDDF7EC), const Color(0xFF10B981), const Color(0xFF075B3B), 0.25, _floatCtrl)),
              Positioned(bottom: 100, left: 40, child: _floatCard('FOUND', 'Wallet (cafe)', Icons.account_balance_wallet, const Color(0xFFDDF7EC), const Color(0xFF10B981), const Color(0xFF075B3B), 0.5, _floatCtrl, reverse: true)),
              // Dark mode toggle
              Positioned(
                top: topPad + 10,
                right: 16,
                child: GestureDetector(
                  onTap: () => context.read<ThemeProvider>().toggle(),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(46),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      theme.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                      size: 18, color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),

        // Bottom content
        Expanded(
          flex: 46,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Lost something\non campus?',
                    style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w700,
                      letterSpacing: -0.52, height: 1.2,
                      color: ext.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Post your lost item or browse what others found on campus.',
                    style: TextStyle(
                      fontSize: 15, height: 1.45,
                      color: ext.textMutedColor,
                    ),
                  ),
                ]),
                Column(children: [
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E4FF6),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        elevation: 0,
                        shadowColor: const Color(0x526E4FF6),
                      ),
                      child: const Text('Get started',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ext.textColor,
                        side: BorderSide(color: ext.borderColor),
                        shape: const StadiumBorder(),
                        backgroundColor: ext.surface2Color,
                      ),
                      child: const Text('I already have an account',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'BUITEMS Students only',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, color: ext.textFaintColor),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _blob(double size, Color color, double opacity) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha((opacity * 255).round()),
        boxShadow: [BoxShadow(color: color.withAlpha(40), blurRadius: 40)],
      ),
    );
  }

  Widget _floatCard(String type, String label, IconData icon, Color bgColor, Color iconColor, Color typeColor, double offset, AnimationController ctrl, {bool reverse = false}) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, child) {
        final t = reverse ? 1 - ctrl.value : ctrl.value;
        final dy = (t - 0.5) * 12;
        return Transform.translate(
          offset: Offset(0, dy),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(242),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(64), blurRadius: 30, offset: const Offset(0, 12))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: typeColor)),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF333333))),
          ]),
        ]),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  final double opacity;
  const _GridOverlay({this.opacity = 1});

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: CustomPaint(painter: _GridPainter(opacity: opacity)),
  );
}

class _GridPainter extends CustomPainter {
  final double opacity;
  _GridPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withAlpha((opacity * 20).round())..strokeWidth = 1;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.opacity != opacity;
}
