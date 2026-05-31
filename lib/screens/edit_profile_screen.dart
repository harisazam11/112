import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late String _department;
  late String _semester;

  static final _deptLabels =
      AppConstants.departments.map((d) => d['label']!).toList();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    _nameCtrl.text = user.name;
    _phoneCtrl.text = user.phone;
    _department = _deptLabels.contains(user.department)
        ? user.department
        : _deptLabels.first;
    _semester = AppConstants.semesters.contains(user.semester)
        ? user.semester
        : AppConstants.semesters.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      return;
    }
    final auth = context.read<AuthProvider>();
    final ok = await auth.updateProfile(
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
      department: _department,
      semester: _semester,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Failed to update profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final user = context.watch<AuthProvider>().user!;

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
              Text('Edit profile',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ext.textColor)),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(18, 0, 18, 24), children: [
              // Avatar preview
              Center(
                child: Column(children: [
                  Container(
                    width: 72, height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF6E4FF6), Color(0xFF5236D9)],
                      ),
                    ),
                    child: Center(child: Text(
                      user.initials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24),
                    )),
                  ),
                  const SizedBox(height: 8),
                  Text(user.email,
                    style: TextStyle(fontSize: 13, color: ext.textMutedColor)),
                ]),
              ),
              const SizedBox(height: 24),

              _FieldLabel('Full name', ext),
              const SizedBox(height: 6),
              TextField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Your full name',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  fillColor: ext.surfaceColor,
                ),
              ),
              const SizedBox(height: 14),

              _FieldLabel('Phone number', ext),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+92 3xx xxxxxxx',
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  fillColor: ext.surfaceColor,
                ),
              ),
              const SizedBox(height: 14),

              _FieldLabel('Department', ext),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _department,
                items: _deptLabels
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _department = v ?? _department),
                decoration: _dropdownDecoration(ext),
                dropdownColor: ext.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                style: TextStyle(fontSize: 15, color: ext.textColor),
              ),
              const SizedBox(height: 14),

              _FieldLabel('Semester', ext),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _semester,
                items: AppConstants.semesters
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _semester = v ?? _semester),
                decoration: _dropdownDecoration(ext),
                dropdownColor: ext.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                style: TextStyle(fontSize: 15, color: ext.textColor),
              ),
              const SizedBox(height: 28),

              Consumer<AuthProvider>(
                builder: (_, auth, __) => SizedBox(
                  height: 52, width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.loading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E4FF6),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: auth.loading
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : const Text('Save changes',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  InputDecoration _dropdownDecoration(AppThemeExtension ext) => InputDecoration(
    filled: true,
    fillColor: ext.surfaceColor,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ext.borderStrongColor)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ext.borderStrongColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6E4FF6), width: 2)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final AppThemeExtension ext;
  const _FieldLabel(this.text, this.ext);
  @override
  Widget build(BuildContext context) => Text(text,
    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600,
      color: ext.textMutedColor, letterSpacing: 0.1));
}
