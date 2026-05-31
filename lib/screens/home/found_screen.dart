import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_constants.dart';
import '../../core/app_theme.dart';
import '../../providers/items_provider.dart';
import '../../widgets/item_card_widget.dart';
import '../item_detail_screen.dart';
import '../add_item_screen.dart';

class FoundScreen extends StatefulWidget {
  const FoundScreen({super.key});
  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  bool _gridView = true;
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final items = context.watch<ItemsProvider>();
    final data = _activeFilter == 'all'
        ? items.found
        : items.found.where((i) => i.category == _activeFilter).toList();

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          // Tinted header
          Container(
            color: ext.foundSoftColor,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: ext.surfaceColor, borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)],
                  ),
                  child: Icon(Icons.check_circle_outline, size: 18, color: ext.foundColor),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('FOUND', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ext.foundInkColor, letterSpacing: 0.88)),
                  Text('Found items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ext.foundInkColor, letterSpacing: -0.36)),
                ])),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: ext.surface2Color, borderRadius: BorderRadius.circular(999)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    _SegBtn(active: _gridView, onTap: () => setState(() => _gridView = true),
                      child: const Icon(Icons.grid_view, size: 14)),
                    _SegBtn(active: !_gridView, onTap: () => setState(() => _gridView = false),
                      child: const Icon(Icons.view_list, size: 14)),
                  ]),
                ),
              ]),
              const SizedBox(height: 10),
              Text('Items waiting to be claimed by their owner',
                style: TextStyle(fontSize: 13.5, color: ext.foundInkColor.withAlpha(192))),
            ]),
          ),
          // Category chips
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: AppConstants.categories.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) return _FilterChip(
                  label: 'All (${items.found.length})', active: _activeFilter == 'all',
                  onTap: () => setState(() => _activeFilter = 'all'), type: 'found',
                );
                final cat = AppConstants.categories[i - 1];
                return _FilterChip(
                  label: cat['label']!, active: _activeFilter == cat['key'],
                  onTap: () => setState(() => _activeFilter = cat['key']!),
                );
              },
            ),
          ),
          // Items
          Expanded(
            child: data.isEmpty
                ? _EmptyState(
                    onAdd: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen(type: 'found'))),
                  )
                : _gridView
                    ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68),
                        itemCount: data.length,
                        itemBuilder: (_, i) => ItemCardWidget(
                          item: data[i], compact: true,
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ItemDetailScreen(item: data[i]))),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemCount: data.length,
                        itemBuilder: (_, i) => ItemRowCardWidget(
                          item: data[i],
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ItemDetailScreen(item: data[i]))),
                        ),
                      ),
          ),
        ]),
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final Widget child;
  const _SegBtn({required this.active, required this.onTap, required this.child});
  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? ext.surfaceColor : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: active ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)] : [],
        ),
        child: child,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final String? type;
  const _FilterChip({required this.label, required this.active, required this.onTap, this.type});
  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final bg = active ? (type == 'found' ? ext.foundColor : ext.textColor) : ext.surfaceColor;
    final fg = active ? Colors.white : ext.textColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: bg, border: Border.all(color: active ? bg : ext.borderStrongColor), borderRadius: BorderRadius.circular(999)),
        child: Center(child: Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: fg))),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 88, height: 88, decoration: BoxDecoration(color: ext.foundSoftColor, shape: BoxShape.circle),
          child: Icon(Icons.check_circle_outline, size: 36, color: ext.foundColor)),
        const SizedBox(height: 16),
        Text('No found items yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ext.textColor)),
        const SizedBox(height: 8),
        SizedBox(width: 260, child: Text('Found something? Help someone get it back.',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: ext.textMutedColor))),
        const SizedBox(height: 20),
        ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 16), label: const Text('Report found item'),
          style: ElevatedButton.styleFrom(backgroundColor: ext.foundColor, foregroundColor: Colors.white, shape: const StadiumBorder())),
      ]),
    );
  }
}
