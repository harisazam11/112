import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/items_provider.dart';
import '../widgets/item_card_widget.dart';
import 'item_detail_screen.dart';

class PosterScreen extends StatelessWidget {
  final String name;
  final String uid;
  final String semester;

  const PosterScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.semester,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final items = context.watch<ItemsProvider>();
    final posts = items.myItems(uid);

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Text('Student profile',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          const SizedBox(height: 12),

          // Profile card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
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
                  width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withAlpha(26)),
                )),
                Row(children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(51),
                      border: Border.all(color: Colors.white.withAlpha(102), width: 2),
                    ),
                    child: Center(child: Text(
                      _initials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                    )),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 3),
                    Text(semester, style: const TextStyle(fontSize: 12.5, color: Color(0xD9FFFFFF))),
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
          ),
          const SizedBox(height: 18),

          // Posts section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text('Posts (${posts.length})',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor, letterSpacing: -0.17)),
            ]),
          ),
          const SizedBox(height: 10),

          // Posts grid or empty state
          Expanded(
            child: posts.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(color: ext.surface2Color, shape: BoxShape.circle),
                        child: Icon(Icons.inbox_outlined, size: 30, color: ext.textFaintColor),
                      ),
                      const SizedBox(height: 14),
                      Text('No posts yet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ext.textColor)),
                      const SizedBox(height: 6),
                      Text('This student has no active posts.',
                        style: TextStyle(fontSize: 13.5, color: ext.textMutedColor)),
                    ]),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68),
                    itemCount: posts.length,
                    itemBuilder: (_, i) => ItemCardWidget(
                      item: posts[i], compact: true,
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: posts[i]))),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
