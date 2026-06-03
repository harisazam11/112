import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/items_provider.dart';
import '../widgets/item_card_widget.dart';
import 'item_detail_screen.dart';

class PosterScreen extends StatefulWidget {
  final String name;
  final String uid;
  final String semester;

  const PosterScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.semester,
  });

  @override
  State<PosterScreen> createState() => _PosterScreenState();
}

class _PosterScreenState extends State<PosterScreen> {
  late final Future<Map<String, String>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile();
  }

  Future<Map<String, String>> _fetchProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    if (!doc.exists) return {'phone': '—', 'email': '—', 'department': '—'};
    final d = doc.data() as Map<String, dynamic>;
    String v(String key) {
      final s = (d[key] as String?)?.trim() ?? '';
      return s.isNotEmpty ? s : '—';
    }
    return {'phone': v('phone'), 'email': v('email'), 'department': v('department')};
  }

  String get _initials {
    final parts = widget.name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final items = context.watch<ItemsProvider>();
    final posts = items.myItems(widget.uid);

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
              child: FutureBuilder<Map<String, String>>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  final info = snapshot.data;
                  final phone = info?['phone'] ?? '…';
                  final email = info?['email'] ?? '…';
                  final department = info?['department'] ?? '…';
                  final sem = widget.semester.isNotEmpty ? widget.semester : '—';

                  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Avatar + STUDENT badge stacked below it
                    Column(mainAxisSize: MainAxisSize.min, children: [
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
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(46),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.school_outlined, size: 10, color: Colors.white),
                          SizedBox(width: 4),
                          Text('STUDENT',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: Colors.white)),
                        ]),
                      ),
                    ]),
                    const SizedBox(width: 16),

                    // Info fields
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700,
                            color: Colors.white, letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(child: _InfoCell(label: 'Phone', value: phone)),
                          const SizedBox(width: 12),
                          Expanded(child: _InfoCell(label: 'Semester', value: sem)),
                        ]),
                        const SizedBox(height: 8),
                        _InfoCell(label: 'Email', value: email, wrap: true),
                        const SizedBox(height: 8),
                        _InfoCell(label: 'Department', value: department, wrap: true),
                      ],
                    )),
                  ]);
                },
              ),
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

class _InfoCell extends StatelessWidget {
  final String? label;
  final String value;
  final bool wrap;
  const _InfoCell({this.label, required this.value, this.wrap = false});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (label != null) ...[
        Text(label!,
          style: const TextStyle(
            fontSize: 9.5, color: Color(0xB3FFFFFF),
            fontWeight: FontWeight.w500, letterSpacing: 0.3)),
        const SizedBox(height: 1),
      ],
      Text(
        value,
        maxLines: wrap ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: Color(0xD9FFFFFF),
        ),
      ),
    ],
  );
}
