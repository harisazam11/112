import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/items_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/item_card_widget.dart';
import '../item_detail_screen.dart';
import '../search_screen.dart';
import '../add_item_screen.dart';
import '../my_posts_screen.dart';
import '../admin_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final auth = context.watch<AuthProvider>();
    final items = context.watch<ItemsProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;
    final firstName = user?.name.split(' ').first ?? 'Student';
    final recent = items.all.take(6).toList();

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => items.listenToItems(),
          color: ext.primaryColor,
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Column(children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Row(children: [
                  AvatarWidget(name: user?.name ?? '', size: 40),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Assalam-o-alaikum', style: TextStyle(fontSize: 12, color: ext.textMutedColor, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text('$firstName 👋', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: ext.textColor)),
                  ])),
                  _IconBtn(
                    onTap: () => context.read<ThemeProvider>().toggle(),
                    child: Icon(theme.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined, size: 18),
                  ),
                  const SizedBox(width: 8),
                  _IconBtn(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
                    badge: true,
                    child: const Icon(Icons.notifications_outlined, size: 18),
                  ),
                ]),
              ),

              // Hero card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Color(0xFF6E4FF6), Color(0xFF5236D9)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(children: [
                    Positioned(top: -40, right: -30,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withAlpha(31)),
                      ),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('CAMPUS · BUITEMS', style: TextStyle(fontSize: 11, color: Color(0xB3FFFFFF), fontWeight: FontWeight.w600, letterSpacing: 0.88)),
                      const SizedBox(height: 6),
                      const Text('Lost something today?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.44)),
                      const SizedBox(height: 4),
                      const Text('Post it — chances are someone already saw it.',
                        style: TextStyle(fontSize: 13, color: Color(0xD9FFFFFF))),
                      const SizedBox(height: 14),
                      Row(children: [
                        _HeroBtn(label: 'Add lost', icon: Icons.add, dark: true,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen(type: 'lost')))),
                        const SizedBox(width: 8),
                        _HeroBtn(label: 'Browse', icon: Icons.search, dark: false,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()))),
                      ]),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 16),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  _StatTile(value: items.activeLostCount.toString(), label: 'active lost',
                    bg: ext.lostSoftColor, fg: ext.lostInkColor),
                  const SizedBox(width: 10),
                  _StatTile(value: items.activeFoundCount.toString(), label: 'active found',
                    bg: ext.foundSoftColor, fg: ext.foundInkColor),
                  const SizedBox(width: 10),
                  _StatTile(value: items.returnedCount.toString(), label: 'reunited',
                    fg: ext.primaryColor),
                ]),
              ),
              const SizedBox(height: 16),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Quick actions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor, letterSpacing: -0.17)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _QATile(
                      icon: Icons.search_off, label: 'Report lost', subtitle: 'Something missing? Post it now.',
                      iconBg: ext.lostSoftColor, iconColor: ext.lostInkColor, borderColor: ext.lostSoftColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen(type: 'lost'))),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _QATile(
                      icon: Icons.check_circle_outline, label: 'Report found', subtitle: 'Found something? Help return it.',
                      iconBg: ext.foundSoftColor, iconColor: ext.foundInkColor, borderColor: ext.foundSoftColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen(type: 'found'))),
                    )),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _QATile(
                      icon: Icons.search, label: 'Search', subtitle: 'By name, place, category…',
                      iconBg: ext.primarySoftColor, iconColor: ext.primaryInkColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _QATile(
                      icon: Icons.label_outline, label: 'My posts', subtitle: 'Edit, update status…',
                      iconBg: ext.surface2Color, iconColor: ext.textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPostsScreen())),
                    )),
                  ]),
                ]),
              ),
              const SizedBox(height: 18),

              // Recent feed header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Recent activity', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor, letterSpacing: -0.17)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See all', style: TextStyle(color: Color(0xFF6E4FF6), fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
              const SizedBox(height: 6),
            ])),

            // Feed grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
                children: recent.map((item) => ItemCardWidget(
                  item: item, compact: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ItemDetailScreen(item: item),
                  )),
                )).toList(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool badge;
  const _IconBtn({required this.onTap, required this.child, this.badge = false});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: ext.surfaceColor,
          shape: BoxShape.circle,
          border: Border.all(color: ext.borderColor),
        ),
        child: Stack(alignment: Alignment.center, children: [
          child,
          if (badge) Positioned(
            top: 8, right: 9,
            child: Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFF25C54),
                shape: BoxShape.circle,
                border: Border.all(color: ext.surfaceColor, width: 1.5),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool dark;
  final VoidCallback onTap;
  const _HeroBtn({required this.label, required this.icon, required this.dark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: dark ? Colors.white : Colors.white.withAlpha(46),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: dark ? const Color(0xFF2A1A8B) : Colors.white),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: dark ? const Color(0xFF2A1A8B) : Colors.white,
          )),
        ]),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value, label;
  final Color? bg, fg;
  const _StatTile({required this.value, required this.label, this.bg, this.fg});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg ?? ext.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: bg ?? ext.borderColor),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.48, color: fg ?? ext.textColor)),
          Text(label, style: TextStyle(fontSize: 11.5, color: (fg ?? ext.textMutedColor).withAlpha(204), fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _QATile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color iconBg, iconColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _QATile({
    required this.icon, required this.label, required this.subtitle,
    required this.iconBg, required this.iconColor, this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ext.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor ?? ext.borderColor),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ext.textColor, letterSpacing: -0.14)),
          const SizedBox(height: 3),
          Text(subtitle, style: TextStyle(fontSize: 11.5, color: ext.textMutedColor)),
        ]),
      ),
    );
  }
}
