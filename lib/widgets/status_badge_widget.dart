import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isLost = type == 'lost';
    final ext = context.ext;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isLost ? ext.lostSoftColor : ext.foundSoftColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isLost ? 'LOST' : 'FOUND',
        style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isLost ? ext.lostInkColor : ext.foundInkColor,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(status, style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600,
          letterSpacing: 0.2, color: fg,
        )),
      ]),
    );
  }

  (Color, Color) _colors(BuildContext context) {
    final dark = context.isDark;
    switch (status) {
      case 'Active':   return (dark ? AppColors.infoSoft.withAlpha(46) : AppColors.infoSoft,
                                dark ? AppColors.infoDark : AppColors.info);
      case 'Claimed':  return (dark ? AppColors.warnSoft.withAlpha(46) : AppColors.warnSoft,
                                dark ? AppColors.warnDark : AppColors.warn);
      case 'Returned': return (context.ext.foundSoftColor, context.ext.foundInkColor);
      case 'Closed':   return (context.ext.surface2Color, context.ext.textMutedColor);
      default:         return (context.ext.surface2Color, context.ext.textMutedColor);
    }
  }
}
