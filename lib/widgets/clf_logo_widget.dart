import 'package:flutter/material.dart';

class ClfLogo extends StatelessWidget {
  final double size;
  final bool showLabel;

  const ClfLogo({super.key, this.size = 64, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: size, height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6E4FF6), Color(0xFF9F86FF), Color(0xFFC7B6FF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x666E4FF6),
            blurRadius: 30, offset: Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'CLF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.32,
            letterSpacing: -0.04 * size * 0.32,
          ),
        ),
      ),
    );

    if (!showLabel) return logo;

    return Row(mainAxisSize: MainAxisSize.min, children: [
      logo,
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Campus Lost & Found',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            letterSpacing: -0.34,
            color: Color(0xFF0E0E14),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'BUITEMS',
          style: TextStyle(fontSize: 11.5, color: Color(0xFF6B6B7B), fontWeight: FontWeight.w500),
        ),
      ]),
    ]);
  }
}
