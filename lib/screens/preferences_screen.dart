import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/theme_provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Text('Preferences',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(18, 0, 18, 24), children: [
              _SectionLabel('APPEARANCE', ext),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: ext.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ext.borderColor),
                ),
                child: _SwitchRow(
                  icon: theme.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                  label: 'Dark mode',
                  subtitle: 'Easier on the eyes at night',
                  value: theme.isDark,
                  onChanged: (_) => context.read<ThemeProvider>().toggle(),
                  ext: ext,
                  last: true,
                ),
              ),
              const SizedBox(height: 20),
              _SectionLabel('NOTIFICATIONS', ext),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: ext.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ext.borderColor),
                ),
                child: Column(children: [
                  _SwitchRow(
                    icon: Icons.notifications_outlined,
                    label: 'Item matches',
                    subtitle: 'When a found item matches your lost post',
                    value: false,
                    onChanged: null,
                    ext: ext,
                  ),
                  _SwitchRow(
                    icon: Icons.chat_bubble_outline,
                    label: 'Contact activity',
                    subtitle: 'When someone reaches out about your post',
                    value: false,
                    onChanged: null,
                    ext: ext,
                    last: true,
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  "These settings aren't connected yet.",
                  style: TextStyle(fontSize: 12, color: ext.textFaintColor),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool last;
  final AppThemeExtension ext;

  const _SwitchRow({
    required this.icon, required this.label, required this.subtitle,
    required this.value, required this.onChanged,
    this.last = false, required this.ext,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
    decoration: BoxDecoration(border: Border(
      bottom: last ? BorderSide.none : BorderSide(color: ext.borderColor),
    )),
    child: Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: ext.surface2Color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: ext.textMutedColor),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: ext.textColor)),
        Text(subtitle, style: TextStyle(fontSize: 12, color: ext.textMutedColor)),
      ])),
      Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: ext.primaryColor,
      ),
    ]),
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
