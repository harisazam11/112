import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String name;
  final double size;

  const AvatarWidget({super.key, required this.name, this.size = 40});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.avatarStart, AppColors.avatarEnd],
        ),
      ),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.36,
            letterSpacing: 0.02,
          ),
        ),
      ),
    );
  }
}
