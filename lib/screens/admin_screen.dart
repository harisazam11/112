import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/item_model.dart';
import '../providers/items_provider.dart';
import '../widgets/status_badge_widget.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _tab = 'all';

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final items = context.watch<ItemsProvider>();
    final filtered = _tab == 'all' ? items.all
        : items.all.where((i) => i.type == _tab).toList();

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
              Text('Admin tools', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          // Warning banner
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ext.warnColor.withAlpha(31), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Icon(Icons.shield_outlined, size: 16, color: ext.warnColor),
                const SizedBox(width: 10),
                Expanded(child: Text('Moderator view. Actions here are for preview only.',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: ext.warnColor))),
              ]),
            ),
          ),
          // Tab bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: BoxDecoration(color: ext.surface2Color, borderRadius: BorderRadius.circular(999)),
              padding: const EdgeInsets.all(4),
              child: Row(children: ['all', 'lost', 'found'].map((t) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tab = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _tab == t ? ext.surfaceColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: _tab == t ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)] : [],
                    ),
                    child: Center(child: Text(
                      t == 'all' ? 'All (${items.all.length})' : '${t[0].toUpperCase()}${t.substring(1)}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: _tab == t ? ext.textColor : ext.textMutedColor),
                    )),
                  ),
                ),
              )).toList()),
            ),
          ),
          const SizedBox(height: 8),
          // Items list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: filtered.length,
              itemBuilder: (_, i) => _AdminCard(item: filtered[i], ext: ext),
            ),
          ),
        ]),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final ItemModel item;
  final AppThemeExtension ext;
  const _AdminCard({required this.item, required this.ext});

  @override
  Widget build(BuildContext context) {
    final items = context.read<ItemsProvider>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 56, height: 56, color: ext.surface2Color,
              child: Center(child: Icon(_iconForCat(item.category), size: 24, color: ext.textFaintColor.withAlpha(150))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              TypeBadge(type: item.type),
              const SizedBox(width: 4),
              StatusBadge(status: item.status),
            ]),
            const SizedBox(height: 3),
            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ext.textColor)),
            Text('${item.postedBy} · ${item.semester}',
              style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
          ])),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _AdminBtn(label: 'Close', icon: Icons.close,
            onTap: () {
              items.updateStatus(item.id, 'Closed');
              _showToast(context, 'Post closed', ext);
            }, ext: ext)),
          const SizedBox(width: 6),
          Expanded(child: _AdminBtn(label: 'Duplicate', icon: Icons.copy_outlined,
            onTap: () => _showToast(context, 'Marked as duplicate', ext), ext: ext)),
          const SizedBox(width: 6),
          Expanded(child: _AdminBtn(label: 'Delete', icon: Icons.delete_outline,
            color: ext.lostColor,
            onTap: () {
              items.deleteItem(item);
              _showToast(context, 'Post removed', ext);
            }, ext: ext)),
        ]),
      ]),
    );
  }

  void _showToast(BuildContext context, String msg, AppThemeExtension ext) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2),
        backgroundColor: ext.textColor),
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

class _AdminBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  final AppThemeExtension ext;
  const _AdminBtn({required this.label, required this.icon, this.color, required this.onTap, required this.ext});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ext.surfaceColor,
        border: Border.all(color: ext.borderStrongColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 14, color: color ?? ext.textColor),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: color ?? ext.textColor)),
      ]),
    ),
  );
}
