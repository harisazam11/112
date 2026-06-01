import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/app_theme.dart';
import '../models/item_model.dart';
import '../providers/auth_provider.dart';
import '../providers/items_provider.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/status_badge_widget.dart';
import 'add_item_screen.dart';
import 'poster_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final ItemModel item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final auth = context.watch<AuthProvider>();
    // Resolve a live copy from the provider stream so status updates rebuild this screen.
    final liveItem = context.watch<ItemsProvider>().all.firstWhere(
      (i) => i.id == item.id,
      orElse: () => item,
    );
    final isMine = auth.user?.uid == item.postedByUid;
    final accent = item.isLost ? ext.lostColor : ext.foundColor;
    final parts = liveItem.postedBy.split(' ');
    final displayName = liveItem.privacy
        ? parts.asMap().entries.map((e) =>
            e.key == 1 ? '${e.value[0]}••••' : e.value).join(' ')
        : liveItem.postedBy;

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: Stack(children: [
        CustomScrollView(slivers: [
          // Hero image
          SliverToBoxAdapter(child: SizedBox(
            height: 280,
            child: Stack(fit: StackFit.expand, children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: item.imageUrl != null
                    ? () => Navigator.push(context, MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => _NetworkImagePreviewScreen(url: item.imageUrl!),
                        ))
                    : null,
                child: _heroImage(item, ext),
              ),
              // Gradient overlay
              IgnorePointer(
                child: DecoratedBox(decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.black.withAlpha(51), Colors.transparent]),
                )),
              ),
              // Back / flag / edit buttons
              Positioned(top: 16 + MediaQuery.of(context).padding.top, left: 16, right: 16,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _overlayBtn(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                  Row(children: [
                    _overlayBtn(Icons.flag_outlined, () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reporting is not available yet.')),
                    )),
                    if (isMine) ...[
                      const SizedBox(width: 8),
                      _overlayBtn(Icons.edit_outlined, () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddItemScreen(type: item.type, editItem: item)))),
                    ],
                  ]),
                ]),
              ),
            ]),
          )),

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Text(
                  item.isLost ? 'LOST ITEM' : 'FOUND ITEM',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                ),
              ),
              const SizedBox(height: 14),
              // Title + status
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Text(item.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.44, color: ext.textColor, height: 1.2))),
                const SizedBox(width: 12),
                StatusBadge(status: liveItem.status),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: _InfoCol(
                  label: 'POSTED',
                  value: DateFormat('d MMM y').format(item.createdAt),
                  ext: ext,
                )),
                Expanded(child: _InfoCol(
                  label: item.isLost ? 'DATE LOST' : 'DATE FOUND',
                  value: item.date,
                  ext: ext,
                )),
                Expanded(child: _InfoCol(
                  label: 'CATEGORY',
                  value: item.categoryLabel,
                  ext: ext,
                )),
              ]),
              const SizedBox(height: 18),

              // Meta tiles
              GridView.count(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
                childAspectRatio: 2.6, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                children: [
                  _MetaTile(icon: Icons.location_on_outlined, label: 'Location', value: item.location, ext: ext),
                  _MetaTile(icon: Icons.calendar_today_outlined, label: item.isLost ? 'Lost on' : 'Found on', value: item.date.split(',')[0], ext: ext),
                  _MetaTile(icon: Icons.label_outline, label: 'Category', value: item.categoryLabel, ext: ext),
                  _MetaTile(icon: Icons.access_time_outlined, label: 'Status', value: liveItem.status, ext: ext, accent: accent),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              Text('Description', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
              const SizedBox(height: 8),
              Text(item.description, style: TextStyle(fontSize: 15, color: ext.textColor, height: 1.6)),
              const SizedBox(height: 20),

              // Posted by
              Text('Posted by', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ext.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ext.borderColor),
                ),
                child: Row(children: [
                  AvatarWidget(name: liveItem.postedBy, size: 44),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(displayName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ext.textColor)),
                      if (liveItem.privacy) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.shield_outlined, size: 13, color: ext.primaryColor),
                      ],
                    ]),
                    Text(liveItem.semester, style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
                  ])),
                  OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => PosterScreen(
                        name: liveItem.postedBy,
                        uid: liveItem.postedByUid,
                        semester: liveItem.semester,
                      ),
                    )),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ext.borderColor),
                      foregroundColor: ext.textColor,
                      shape: const StadiumBorder(),
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('View', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
              const SizedBox(height: 12),

              // Privacy note
              if (liveItem.privacy) Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: ext.primarySoftColor, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(Icons.shield_outlined, size: 14, color: ext.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    'Last name is partially hidden for safety. Contact the owner privately to verify ownership.',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: ext.primaryInkColor, height: 1.5),
                  )),
                ]),
              ),

              // Status changer (own posts)
              if (isMine) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Update status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ext.textColor)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, children: ['Active', 'Claimed', 'Returned', 'Closed'].map((s) =>
                      _StatusChip(label: s, selected: liveItem.status == s, ext: ext,
                        onTap: () => context.read<ItemsProvider>().updateStatus(item.id, s)),
                    ).toList()),
                  ]),
                ),
              ],
            ]),
          )),
        ]),

        // Sticky contact bar
        if (!isMine) Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: ext.bgColor.withAlpha(230),
              border: Border(top: BorderSide(color: ext.borderColor)),
            ),
            child: Row(children: [
              Expanded(child: _ActionBtn(
                label: 'Call', icon: Icons.phone_outlined,
                iconBg: const Color(0x2310B981), iconColor: const Color(0xFF10B981),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Call is not available yet.')),
                ),
              )),
              const SizedBox(width: 8),
              Expanded(child: _ActionBtn(
                label: 'Email', icon: Icons.mail_outlined,
                iconBg: const Color(0x236E4FF6), iconColor: const Color(0xFF6E4FF6),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email is not available yet.')),
                ),
              )),
              const SizedBox(width: 8),
              Expanded(child: _ActionBtn(
                label: 'WhatsApp', icon: Icons.message_outlined,
                iconBg: const Color(0x2925D366), iconColor: const Color(0xFF18A04A),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('WhatsApp is not available yet.')),
                ),
              )),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _heroImage(ItemModel item, AppThemeExtension ext) {
    final accent = item.isLost ? const Color(0x1AF25C54) : const Color(0x1A10B981);
    final fallback = Container(
      color: ext.surface2Color,
      child: Stack(fit: StackFit.expand, children: [
        CustomPaint(painter: _StripePainter(accent)),
        Center(child: Icon(_iconForCategory(item.category), size: 68, color: ext.textFaintColor.withAlpha(150))),
      ]),
    );
    if (item.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: item.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          color: ext.surface2Color,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, __, ___) => fallback,
      );
    }
    return fallback;
  }

  Widget _overlayBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(235), shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }

  IconData _iconForCategory(String cat) {
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

class _MetaTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final AppThemeExtension ext;
  final Color? accent;
  const _MetaTile({required this.icon, required this.label, required this.value, required this.ext, this.accent});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: ext.surfaceColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: ext.borderColor)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 14, color: ext.textMutedColor),
        const SizedBox(width: 5),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.6, color: ext.textMutedColor)),
      ]),
      const SizedBox(height: 4),
      Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: accent ?? ext.textColor))),
    ]),
  );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final AppThemeExtension ext;
  final VoidCallback onTap;
  const _StatusChip({required this.label, required this.selected, required this.ext, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? ext.textColor : ext.surfaceColor,
        border: Border.all(color: selected ? ext.textColor : ext.borderStrongColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500,
        color: selected ? ext.bgColor : ext.textColor)),
    ),
  );
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconBg, iconColor;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.iconBg, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
        child: Column(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: ext.textColor)),
        ]),
      ),
    );
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

class _InfoCol extends StatelessWidget {
  final String label, value;
  final AppThemeExtension ext;
  const _InfoCol({required this.label, required this.value, required this.ext});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(
        fontSize: 10, fontWeight: FontWeight.w600,
        letterSpacing: 0.6, color: ext.textMutedColor)),
      const SizedBox(height: 3),
      Text(value, maxLines: 2, overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ext.textColor)),
    ],
  );
}

class _NetworkImagePreviewScreen extends StatelessWidget {
  final String url;
  const _NetworkImagePreviewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (_, __) => const Center(
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
              errorWidget: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
