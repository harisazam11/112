import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/item_model.dart';
import '../providers/auth_provider.dart';
import '../providers/items_provider.dart';
import '../widgets/status_badge_widget.dart';
import 'item_detail_screen.dart';
import 'add_item_screen.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final auth = context.watch<AuthProvider>();
    final items = context.watch<ItemsProvider>();
    final myItems = items.myItems(auth.user?.uid ?? '');
    final active = myItems.where((i) => i.isActive).length;
    final closed = myItems.length - active;

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
              Text('My posts', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
              const Spacer(),
            ]),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
              // Stats
              Row(children: [
                Expanded(child: _StatTile(value: active.toString(), label: 'active', ext: ext)),
                const SizedBox(width: 10),
                Expanded(child: _StatTile(value: closed.toString(), label: 'closed / returned', valueColor: ext.foundColor, ext: ext)),
              ]),
              const SizedBox(height: 16),

              if (myItems.isEmpty)
                _EmptyState(ext: ext)
              else
                ...myItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PostCard(item: item, ext: ext),
                )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final ItemModel item;
  final AppThemeExtension ext;
  const _PostCard({required this.item, required this.ext});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final ext = widget.ext;
    return Container(
      decoration: BoxDecoration(
        color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        // Main row
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ItemDetailScreen(item: widget.item))),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 70, height: 70, color: ext.surface2Color,
                child: Stack(children: [
                  CustomPaint(painter: _StripePainter(
                    widget.item.isLost ? const Color(0x1AF25C54) : const Color(0x1A10B981))),
                  Center(child: Icon(_iconForCat(widget.item.category), size: 28, color: ext.textFaintColor.withAlpha(150))),
                ]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                TypeBadge(type: widget.item.type),
                const SizedBox(width: 6),
                StatusBadge(status: widget.item.status),
              ]),
              const SizedBox(height: 4),
              Text(widget.item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ext.textColor, letterSpacing: -0.14, height: 1.3)),
              const SizedBox(height: 2),
              Text('${widget.item.location} · ${widget.item.date.split(',')[0]}',
                style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
            ])),
            GestureDetector(
              onTap: () => setState(() => _menuOpen = !_menuOpen),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(999)),
                child: Icon(Icons.more_vert, size: 18, color: ext.textMutedColor),
              ),
            ),
          ]),
        ),
        // Context menu
        if (_menuOpen) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: ext.surface2Color, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _MenuItem(icon: Icons.edit_outlined, label: 'Edit post', ext: ext,
                onTap: () {
                  setState(() => _menuOpen = false);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AddItemScreen(type: widget.item.type, editItem: widget.item)));
                }),
              _MenuItem(icon: Icons.check_circle_outline, label: 'Mark as returned', color: ext.foundColor, ext: ext,
                onTap: () {
                  setState(() => _menuOpen = false);
                  context.read<ItemsProvider>().updateStatus(widget.item.id, 'Returned');
                }),
              _MenuItem(icon: Icons.close, label: 'Close post', color: ext.textMutedColor, ext: ext,
                onTap: () {
                  setState(() => _menuOpen = false);
                  context.read<ItemsProvider>().updateStatus(widget.item.id, 'Closed');
                }),
              _MenuItem(icon: Icons.delete_outline, label: 'Delete', color: ext.lostColor, ext: ext,
                onTap: () {
                  setState(() => _menuOpen = false);
                  _confirmDelete(context);
                }),
            ]),
          ),
        ],
      ]),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete post'),
        content: Text('Delete "${widget.item.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ItemsProvider>().deleteItem(widget.item);
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFF25C54))),
          ),
        ],
      ),
    );
  }

  IconData _iconForCat(String cat) {
    switch (cat) {
      case 'id': return Icons.credit_card;
      case 'wal': return Icons.account_balance_wallet_outlined;
      case 'key': return Icons.key_outlined;
      case 'book': return Icons.menu_book_outlined;
      case 'elec': return Icons.devices_outlined;
      case 'calc': return Icons.calculate_outlined;
      case 'usb': return Icons.usb_outlined;
      case 'bag': return Icons.backpack_outlined;
      case 'sta': return Icons.edit_outlined;
      case 'clo': return Icons.checkroom_outlined;
      default: return Icons.label_outlined;
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final AppThemeExtension ext;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, this.color, required this.ext, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(icon, size: 16, color: color ?? ext.textColor),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color ?? ext.textColor)),
      ]),
    ),
  );
}

class _StatTile extends StatelessWidget {
  final String value, label;
  final Color? valueColor;
  final AppThemeExtension ext;
  const _StatTile({required this.value, required this.label, this.valueColor, required this.ext});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.48, color: valueColor ?? ext.textColor)),
      Text(label, style: TextStyle(fontSize: 11.5, color: ext.textMutedColor, fontWeight: FontWeight.w500)),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  final AppThemeExtension ext;
  const _EmptyState({required this.ext});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 48), child: Column(children: [
      Container(width: 88, height: 88, decoration: BoxDecoration(color: ext.primarySoftColor, shape: BoxShape.circle),
        child: Icon(Icons.label_outline, size: 28, color: ext.primaryColor)),
      const SizedBox(height: 16),
      Text("You haven't posted yet", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
      const SizedBox(height: 8),
      Text('Lost something or found something? Post it from the home tab.',
        textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: ext.textMutedColor)),
    ])),
  );
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
