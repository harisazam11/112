import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/items_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/avatar_widget.dart';
import 'my_posts_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final auth = context.watch<AuthProvider>();
    final items = context.watch<ItemsProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox();

    final myItems = items.myItems(user.uid);
    final totalPosts = myItems.length;
    final reunited = myItems.where((i) => i.status == 'Returned').length;
    final stillActive = myItems.where((i) => i.isActive).length;

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 24), children: [
          // Header row
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            GestureDetector(
              onTap: () => context.read<ThemeProvider>().toggle(),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                child: Icon(theme.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined, size: 20, color: ext.textMutedColor),
              ),
            ),
          ]),
          const SizedBox(height: 12),

          // Profile header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF6E4FF6), Color(0xFF5236D9)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(children: [
              Positioned(top: -30, right: -30, child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withAlpha(26)),
              )),
              Row(children: [
                Container(
                  width: 68, height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(51),
                    border: Border.all(color: Colors.white.withAlpha(102), width: 2),
                  ),
                  child: Center(child: Text(
                    user.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22, letterSpacing: 0.44),
                  )),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('${user.department} · ${user.semester}',
                    style: const TextStyle(fontSize: 12.5, color: Color(0xD9FFFFFF))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(46), borderRadius: BorderRadius.circular(99)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.school_outlined, size: 10, color: Colors.white),
                      SizedBox(width: 4),
                      Text('STUDENT',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: Colors.white)),
                    ]),
                  ),
                ])),
              ]),
            ]),
          ),
          const SizedBox(height: 16),

          // Stats
          Row(children: [
            _StatTile(value: totalPosts.toString(), label: 'total posts', ext: ext),
            const SizedBox(width: 10),
            _StatTile(value: reunited.toString(), label: 'reunited', valueColor: ext.foundColor, ext: ext),
            const SizedBox(width: 10),
            _StatTile(value: stillActive.toString(), label: 'still active', valueColor: ext.lostColor, ext: ext),
          ]),
          const SizedBox(height: 18),

          // Account info
          _SectionLabel('ACCOUNT', ext),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
            padding: const EdgeInsets.all(4),
            child: Column(children: [
              _InfoRow(icon: Icons.mail_outline, label: 'Email', value: user.email, ext: ext),
              _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone, ext: ext),
              _InfoRow(icon: Icons.school_outlined, label: 'Department', value: user.department, ext: ext),
              _InfoRow(icon: Icons.calendar_today_outlined, label: 'Semester', value: user.semester, last: true, ext: ext),
            ]),
          ),
          const SizedBox(height: 18),

          // Quick links
          _SectionLabel('QUICK LINKS', ext),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
            padding: const EdgeInsets.all(4),
            child: Column(children: [
              _LinkRow(icon: Icons.label_outline, label: 'My posts', hint: '$totalPosts', ext: ext,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPostsScreen()))),
              _LinkRow(icon: Icons.notifications_outlined, label: 'Notifications', ext: ext),
              _LinkRow(icon: Icons.tune_outlined, label: 'Preferences', ext: ext),
              _LinkRow(icon: Icons.lock_outline, label: 'Privacy & data', last: true, ext: ext),
            ]),
          ),
          const SizedBox(height: 18),

          // Sign out
          OutlinedButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: ext.borderColor),
              shape: const StadiumBorder(),
              backgroundColor: ext.surface2Color,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text('Sign out', style: TextStyle(fontWeight: FontWeight.w600, color: ext.textColor)),
          ),
          const SizedBox(height: 14),
          Center(child: Text('CLF · v1.0 · BUITEMS',
            style: TextStyle(fontSize: 12, color: ext.textFaintColor))),
        ]),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value, label;
  final Color? valueColor;
  final AppThemeExtension ext;
  const _StatTile({required this.value, required this.label, this.valueColor, required this.ext});

  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: ext.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ext.borderColor)),
    child: Column(children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.44, color: valueColor ?? ext.textColor)),
      Text(label, style: TextStyle(fontSize: 11.5, color: ext.textMutedColor, fontWeight: FontWeight.w500)),
    ]),
  ));
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool last;
  final AppThemeExtension ext;
  const _InfoRow({required this.icon, required this.label, required this.value, this.last = false, required this.ext});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
    decoration: BoxDecoration(border: Border(bottom: last ? BorderSide.none : BorderSide(color: ext.borderColor))),
    child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: ext.surface2Color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: ext.textMutedColor)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.6, color: ext.textMutedColor)),
        const SizedBox(height: 1),
        Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ext.textColor)),
      ])),
    ]),
  );
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? hint;
  final bool last;
  final AppThemeExtension ext;
  final VoidCallback? onTap;
  const _LinkRow({required this.icon, required this.label, this.hint, this.last = false, required this.ext, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(border: Border(bottom: last ? BorderSide.none : BorderSide(color: ext.borderColor))),
      child: Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: ext.primarySoftColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: ext.primaryColor)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: ext.textColor))),
        if (hint != null) Text(hint!, style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right, size: 16, color: ext.textMutedColor),
      ]),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final AppThemeExtension ext;
  const _SectionLabel(this.text, this.ext);
  @override
  Widget build(BuildContext context) => Text(text,
    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ext.textMutedColor, letterSpacing: 0.88));
}
