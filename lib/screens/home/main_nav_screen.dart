import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/items_provider.dart';
import '../../providers/auth_provider.dart';
import '../add_item_screen.dart';
import 'dashboard_screen.dart';
import 'lost_screen.dart';
import 'found_screen.dart';
import '../profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemsProvider>().listenToItems();
    });
  }

  void _onTab(int i) {
    if (i == 2) {
      _showAddChoice();
      return;
    }
    setState(() => _tab = i < 2 ? i : i - 1);
  }

  void _showAddChoice() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddChoiceSheet(onPick: (type) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => AddItemScreen(type: type),
        ));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final screens = [
      DashboardScreen(onProfileTap: () => setState(() => _tab = 3)),
      const LostScreen(),
      const FoundScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: IndexedStack(index: _tab, children: screens),
      bottomNavigationBar: _BottomNav(
        current: _tab,
        onTab: _onTab,
        ext: ext,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTab;
  final AppThemeExtension ext;

  const _BottomNav({required this.current, required this.onTab, required this.ext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ext.surfaceColor.withAlpha(224),
        border: Border(top: BorderSide(color: ext.borderColor)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 20)],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(children: [
            _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', active: current == 0, onTap: () => onTab(0), ext: ext),
            _NavItem(icon: Icons.search_off_outlined, activeIcon: Icons.search_off, label: 'Lost', active: current == 1, onTap: () => onTab(1), ext: ext),
            // FAB
            Expanded(
              child: GestureDetector(
                onTap: () => onTab(2),
                child: Center(
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: ext.primaryColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: ext.primaryColor.withAlpha(102), blurRadius: 22, offset: const Offset(0, 8))],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
            _NavItem(icon: Icons.check_circle_outline, activeIcon: Icons.check_circle, label: 'Found', active: current == 2, onTap: () => onTab(3), ext: ext),
            _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', active: current == 3, onTap: () => onTab(4), ext: ext),
          ]),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final AppThemeExtension ext;

  const _NavItem({
    required this.icon, required this.activeIcon, required this.label,
    required this.active, required this.onTap, required this.ext,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? ext.primaryColor : ext.textFaintColor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(active ? activeIcon : icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}

class _AddChoiceSheet extends StatelessWidget {
  final ValueChanged<String> onPick;
  const _AddChoiceSheet({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Container(
      decoration: BoxDecoration(
        color: ext.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: ext.borderColor),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 36, height: 4, margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: ext.borderStrongColor, borderRadius: BorderRadius.circular(99)),
        ),
        Text('What did you want to post?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor),
        ),
        const SizedBox(height: 6),
        Text('Pick the right type. It changes how others can help.',
          style: TextStyle(fontSize: 14, color: ext.textMutedColor),
        ),
        const SizedBox(height: 20),
        _ChoiceTile(
          type: 'lost',
          title: 'I lost something',
          subtitle: 'Post a "lost" notice so others on campus can keep an eye out.',
          icon: Icons.search_off,
          color: const Color(0xFFF25C54),
          onTap: () => onPick('lost'),
        ),
        const SizedBox(height: 12),
        _ChoiceTile(
          type: 'found',
          title: 'I found something',
          subtitle: "Help return it to its owner. You'll set the pickup details.",
          icon: Icons.check_circle_outline,
          color: const Color(0xFF10B981),
          onTap: () => onPick('found'),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ext.surface2Color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: ext.primarySoftColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.shield_outlined, size: 16, color: ext.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Privacy first', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ext.textColor)),
              const SizedBox(height: 2),
              Text('For ID cards and personal documents we partially hide names automatically.',
                style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
            ])),
          ]),
        ),
      ]),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final String type, title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.type, required this.title, required this.subtitle,
    required this.icon, required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final tileInkColor = type == 'lost' ? ext.lostInkColor : ext.foundInkColor;
    final tileSoftColor = type == 'lost' ? ext.lostSoftColor : ext.foundSoftColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [tileSoftColor, ext.surfaceColor]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tileSoftColor),
        ),
        child: Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: color.withAlpha(82), blurRadius: 22, offset: const Offset(0, 8))],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: tileInkColor)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 13.5, color: ext.textMutedColor)),
          ])),
          Icon(Icons.chevron_right, color: ext.textMutedColor, size: 20),
        ]),
      ),
    );
  }
}
