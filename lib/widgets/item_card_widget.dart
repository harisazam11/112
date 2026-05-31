import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item_model.dart';
import '../core/app_theme.dart';
import 'status_badge_widget.dart';

class ItemCardWidget extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final bool compact;

  const ItemCardWidget({
    super.key,
    required this.item,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final h = compact ? 110.0 : 140.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ext.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8, offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ImagePlaceholder(item: item, height: h),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TypeBadge(type: item.type),
                Text(
                  item.date.split(',')[0],
                  style: TextStyle(fontSize: 11.5, color: ext.textMutedColor),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: ext.textColor, letterSpacing: -0.14,
                ),
              ),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 12, color: ext.textMutedColor),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    item.location,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: ext.textMutedColor),
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class ItemRowCardWidget extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ItemRowCardWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ext.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderColor),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 90, height: 90,
              child: _ImagePlaceholder(item: item, height: 90),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                TypeBadge(type: item.type),
                const SizedBox(width: 6),
                StatusBadge(status: item.status),
              ]),
              const SizedBox(height: 6),
              Text(
                item.title,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: ext.textColor, letterSpacing: -0.14, height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 11, color: ext.textMutedColor),
                const SizedBox(width: 3),
                Expanded(child: Text(item.location,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: ext.textMutedColor),
                )),
                const SizedBox(width: 8),
                Icon(Icons.access_time_outlined, size: 11, color: ext.textMutedColor),
                const SizedBox(width: 3),
                Text(item.date.split(',')[0],
                  style: TextStyle(fontSize: 11.5, color: ext.textMutedColor),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final ItemModel item;
  final double height;
  const _ImagePlaceholder({required this.item, required this.height});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final accent = item.isLost
        ? const Color(0x1AF25C54)
        : const Color(0x1A10B981);

    if (item.imageUrl != null) {
      return SizedBox(
        height: height, width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: item.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(context, accent, ext),
          errorWidget: (_, __, ___) => _placeholder(context, accent, ext),
        ),
      );
    }
    return _placeholder(context, accent, ext);
  }

  Widget _placeholder(BuildContext context, Color accent, AppThemeExtension ext) {
    return Container(
      height: height, width: double.infinity,
      color: ext.surface2Color,
      child: Stack(fit: StackFit.expand, children: [
        CustomPaint(painter: _StripePainter(accent)),
        Center(child: Icon(_categoryIcon(), size: 38, color: ext.textFaintColor.withAlpha(150))),
      ]),
    );
  }

  IconData _categoryIcon() {
    switch (item.category) {
      case 'id':   return Icons.credit_card;
      case 'wal':  return Icons.account_balance_wallet_outlined;
      case 'key':  return Icons.key_outlined;
      case 'book': return Icons.menu_book_outlined;
      case 'elec': return Icons.devices_outlined;
      case 'calc': return Icons.calculate_outlined;
      case 'usb':  return Icons.usb_outlined;
      case 'bag':  return Icons.backpack_outlined;
      case 'sta':  return Icons.edit_outlined;
      case 'clo':  return Icons.checkroom_outlined;
      default:     return Icons.label_outlined;
    }
  }
}

class _StripePainter extends CustomPainter {
  final Color color;
  _StripePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    const spacing = 11.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.color != color;
}
