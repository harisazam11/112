import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
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
              Text('Privacy & Data',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(18, 0, 18, 24), children: [
              _InfoCard(
                icon: Icons.storage_outlined,
                title: 'What we store',
                body: 'Your name, university email, department, semester, and phone number from signup. Posts you create are stored in Firestore under your account.',
                ext: ext,
              ),
              const SizedBox(height: 14),
              _InfoCard(
                icon: Icons.visibility_outlined,
                title: 'What others can see',
                body: 'Your name and semester are visible on posts you create. Your phone number is shown only after another student taps "Contact." For ID-card posts, your last name is partially masked automatically.',
                ext: ext,
              ),
              const SizedBox(height: 14),
              _InfoCard(
                icon: Icons.block_outlined,
                title: 'What we do not do',
                body: 'We do not track your location, sell your data, or share your information with third parties. The app uses Firebase services (Auth and Firestore) subject to Google\'s standard terms.',
                ext: ext,
              ),
              const SizedBox(height: 14),
              _InfoCard(
                icon: Icons.manage_accounts_outlined,
                title: 'Your rights',
                body: 'You can sign out at any time. Account deletion and full data export will be available in a future update. For urgent requests, contact the campus IT team.',
                ext: ext,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text('CLF · BUITEMS · v1.0',
                  style: TextStyle(fontSize: 12, color: ext.textFaintColor)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title, body;
  final AppThemeExtension ext;

  const _InfoCard({required this.icon, required this.title, required this.body, required this.ext});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ext.surfaceColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ext.borderColor),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: ext.primarySoftColor, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: ext.primaryColor),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: ext.textColor)),
        const SizedBox(height: 6),
        Text(body, style: TextStyle(fontSize: 13.5, color: ext.textMutedColor, height: 1.55)),
      ])),
    ]),
  );
}
