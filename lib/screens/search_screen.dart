import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../providers/items_provider.dart';
import '../widgets/item_card_widget.dart';
import 'item_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryCtrl = TextEditingController();
  String _type = 'all';
  final Set<String> _cats = {};
  String? _loc;
  String? _status;

  @override
  void dispose() { _queryCtrl.dispose(); super.dispose(); }

  int get _activeFilters =>
      (_type != 'all' ? 1 : 0) + _cats.length + (_loc != null ? 1 : 0) + (_status != null ? 1 : 0);

  void _clear() => setState(() {
    _queryCtrl.clear(); _type = 'all'; _cats.clear(); _loc = null; _status = null;
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final items = context.watch<ItemsProvider>();
    final results = items.search(
      query: _queryCtrl.text,
      type: _type,
      categories: _cats.toList(),
      location: _loc,
      status: _status,
    );

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: ext.surfaceColor, shape: BoxShape.circle, border: Border.all(color: ext.borderColor)),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
              ),
              const SizedBox(width: 10),
              Text('Search', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: ext.surfaceColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: ext.borderColor),
              ),
              child: Row(children: [
                const Padding(padding: EdgeInsets.only(left: 14), child: Icon(Icons.search, size: 20, color: Color(0xFF9A9AAE))),
                Expanded(child: TextField(
                  controller: _queryCtrl,
                  onChanged: (_) => setState(() {}),
                  autofocus: true,
                  style: TextStyle(fontSize: 14.5, color: ext.textColor),
                  decoration: InputDecoration(
                    hintText: 'Name, category, location, description…',
                    hintStyle: TextStyle(color: ext.textFaintColor, fontSize: 14.5),
                    border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                    filled: false, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  ),
                )),
                if (_queryCtrl.text.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _queryCtrl.clear()),
                    child: Padding(padding: const EdgeInsets.only(right: 12),
                      child: Icon(Icons.close, size: 18, color: ext.textFaintColor)),
                  ),
              ]),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Type segment
                _segmentedControl(ext),
                const SizedBox(height: 14),

                // Categories
                _sectionLabel('CATEGORY', ext),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: AppConstants.categories.map((c) =>
                  _FilterChip(label: c['label']!, active: _cats.contains(c['key']),
                    onTap: () => setState(() => _cats.contains(c['key']!) ? _cats.remove(c['key']!) : _cats.add(c['key']!)),
                  )
                ).toList()),
                const SizedBox(height: 14),

                // Locations
                _sectionLabel('LOCATION', ext),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: AppConstants.locations.take(8).map((l) =>
                  _FilterChip(
                    label: l, active: _loc == l,
                    onTap: () => setState(() => _loc = _loc == l ? null : l),
                    icon: Icons.location_on_outlined,
                  )
                ).toList()),
                const SizedBox(height: 14),

                // Status
                _sectionLabel('STATUS', ext),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: AppConstants.statuses.map((s) =>
                  _FilterChip(label: s, active: _status == s,
                    onTap: () => setState(() => _status = _status == s ? null : s),
                  )
                ).toList()),
                const SizedBox(height: 16),

                // Active filters banner
                if (_activeFilters > 0) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: ext.primarySoftColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('$_activeFilters filter${_activeFilters > 1 ? 's' : ''} active',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ext.primaryInkColor)),
                    GestureDetector(
                      onTap: _clear,
                      child: Text('Clear all', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ext.primaryColor)),
                    ),
                  ]),
                ),

                // Results count
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${results.length} result${results.length != 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
                  Text('Sorted by recent', style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
                ]),
                const SizedBox(height: 10),

                // Results
                if (results.isEmpty)
                  _emptyResults(ext)
                else
                  ...results.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ItemRowCardWidget(
                      item: item,
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: item))),
                    ),
                  )),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _segmentedControl(AppThemeExtension ext) {
    return Container(
      decoration: BoxDecoration(color: ext.surface2Color, borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.all(4),
      child: Row(children: ['all', 'lost', 'found'].map((t) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _type = t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _type == t ? ext.surfaceColor : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              boxShadow: _type == t ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)] : [],
            ),
            child: Center(child: Text(
              t[0].toUpperCase() + t.substring(1),
              style: TextStyle(
                fontSize: 13.5, fontWeight: FontWeight.w600,
                color: _type == t
                    ? (t == 'lost' ? ext.lostColor : t == 'found' ? ext.foundColor : ext.textColor)
                    : ext.textMutedColor,
              ),
            )),
          ),
        ),
      )).toList()),
    );
  }

  Widget _sectionLabel(String text, AppThemeExtension ext) {
    return Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
      color: ext.textMutedColor, letterSpacing: 0.88));
  }

  Widget _emptyResults(AppThemeExtension ext) {
    return Center(
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 32), child: Column(children: [
        Container(width: 80, height: 80, decoration: BoxDecoration(color: ext.primarySoftColor, shape: BoxShape.circle),
          child: Icon(Icons.search, size: 32, color: ext.primaryColor)),
        const SizedBox(height: 16),
        Text('No matches', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
        const SizedBox(height: 8),
        Text('Try removing a filter or broadening your search.',
          style: TextStyle(fontSize: 13.5, color: ext.textMutedColor)),
      ])),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;
  const _FilterChip({required this.label, required this.active, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? ext.textColor : ext.surfaceColor,
          border: Border.all(color: active ? ext.textColor : ext.borderStrongColor),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 12, color: active ? ext.bgColor : ext.textMutedColor), const SizedBox(width: 4)],
          Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: active ? ext.bgColor : ext.textColor)),
        ]),
      ),
    );
  }
}
