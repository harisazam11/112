import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
              Text('Notifications',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          Expanded(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 88, height: 88,
                  decoration: BoxDecoration(color: ext.surface2Color, shape: BoxShape.circle),
                  child: Icon(Icons.notifications_none_outlined, size: 38, color: ext.textFaintColor),
                ),
                const SizedBox(height: 18),
                Text('No notifications yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ext.textColor)),
                const SizedBox(height: 8),
                SizedBox(
                  width: 260,
                  child: Text(
                    "You're all caught up. Notifications will show here when activity happens on your posts.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: ext.textMutedColor, height: 1.5),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
