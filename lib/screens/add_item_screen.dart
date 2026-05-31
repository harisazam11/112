import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../models/item_model.dart';
import '../providers/auth_provider.dart';
import '../providers/items_provider.dart';

class AddItemScreen extends StatefulWidget {
  final String type;
  final ItemModel? editItem;
  const AddItemScreen({super.key, required this.type, this.editItem});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late final bool _isEdit;
  late final bool _isLost;

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _pickupCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _category = 'wal';
  String _location = 'CS Department';
  String _date = 'Today';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.editItem != null;
    _isLost = widget.type == 'lost';

    if (_isEdit) {
      final e = widget.editItem!;
      _titleCtrl.text = e.title;
      _descCtrl.text = e.description;
      _phoneCtrl.text = e.contact;
      _emailCtrl.text = e.email;
      _category = e.category;
      _location = e.location;
      _date = e.date;
    } else {
      final auth = context.read<AuthProvider>();
      _phoneCtrl.text = auth.user?.phone ?? '';
      _emailCtrl.text = auth.user?.email ?? '';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _descCtrl.dispose();
    _pickupCtrl.dispose(); _phoneCtrl.dispose(); _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 85);
    if (xfile != null) setState(() => _imageFile = File(xfile.path));
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }
    final itemsProvider = context.read<ItemsProvider>();
    final auth = context.read<AuthProvider>();

    bool ok;
    if (_isEdit) {
      final updated = widget.editItem!.copyWith(
        title: _titleCtrl.text.trim(),
        category: _category,
        categoryLabel: AppConstants.categories.firstWhere((c) => c['key'] == _category)['label'],
        description: _descCtrl.text.trim(),
        location: _location,
        date: _date,
        contact: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
      );
      ok = await itemsProvider.updateItem(updated, newImageFile: _imageFile);
    } else {
      ok = await itemsProvider.addItem(
        type: widget.type,
        title: _titleCtrl.text.trim(),
        category: _category,
        description: _descCtrl.text.trim(),
        location: _location,
        date: _date,
        contact: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        imageFile: _imageFile,
        user: auth.user!,
      );
    }

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEdit ? 'Post updated' : (_isLost ? 'Lost item posted' : 'Found item posted')),
        backgroundColor: _isLost ? const Color(0xFFF25C54) : const Color(0xFF10B981),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    final accent = _isLost ? ext.lostColor : ext.foundColor;
    final soft = _isLost ? ext.lostSoftColor : ext.foundSoftColor;
    final ink = _isLost ? ext.lostInkColor : ext.foundInkColor;

    return Scaffold(
      backgroundColor: ext.bgColor,
      body: Column(children: [
        // Colored header
        SafeArea(
          bottom: false,
          child: Container(
            color: soft,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: Colors.white.withAlpha(102), borderRadius: BorderRadius.circular(999)),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_isEdit ? 'EDIT POST' : 'NEW POST',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ink, letterSpacing: 0.88)),
                  Text(_isEdit ? 'Edit details' : _isLost ? 'Report lost item' : 'Report found item',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ink, letterSpacing: -0.36)),
                ])),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
                  child: Icon(_isLost ? Icons.search_off : Icons.check_circle_outline, color: Colors.white, size: 18),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                _isLost ? 'Describe what you lost in detail — small specifics help a lot.'
                         : "Help return it. Don't share too many private details publicly.",
                style: TextStyle(fontSize: 13.5, color: ink.withAlpha(192)),
              ),
            ]),
          ),
        ),

        // Form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Image upload
              _FieldLabel('Photo', ext),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ext.surfaceColor, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ext.borderStrongColor, width: 1.5, style: BorderStyle.solid),
                ),
                child: Column(children: [
                  Container(
                    height: 140, width: double.infinity,
                    decoration: BoxDecoration(
                      color: ext.surface2Color, borderRadius: BorderRadius.circular(12),
                      image: _imageFile != null ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover) : null,
                    ),
                    child: _imageFile == null ? Stack(children: [
                      CustomPaint(painter: _StripePainter(_isLost ? const Color(0x1AF25C54) : const Color(0x1A10B981))),
                      Center(child: Icon(Icons.image_outlined, size: 42, color: ext.textFaintColor.withAlpha(150))),
                    ]) : null,
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _SecondaryBtn(
                      onTap: () => _pickImage(ImageSource.camera),
                      icon: Icons.camera_alt_outlined, label: 'Camera', ext: ext,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _SecondaryBtn(
                      onTap: () => _pickImage(ImageSource.gallery),
                      icon: Icons.photo_library_outlined, label: 'Gallery', ext: ext,
                    )),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),

              _FieldLabel('Item title', ext), const SizedBox(height: 6),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  hintText: _isLost ? 'e.g. Black wallet with leather strap' : 'e.g. SanDisk USB drive — red',
                  fillColor: ext.surfaceColor,
                ),
              ),
              const SizedBox(height: 14),

              _FieldLabel('Category', ext), const SizedBox(height: 6),
              _DropdownField(
                value: _category,
                items: AppConstants.categories.map((c) =>
                  DropdownMenuItem(value: c['key']!, child: Row(children: [
                    Icon(_iconForCat(c['key']!), size: 16, color: ext.textMutedColor),
                    const SizedBox(width: 8),
                    Text(c['label']!),
                  ]))
                ).toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
                ext: ext,
              ),
              const SizedBox(height: 14),

              _FieldLabel('Description', ext), const SizedBox(height: 6),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: _isLost
                      ? 'Color, brand, distinguishing marks, what was inside…'
                      : 'Where exactly you found it, condition, any markings…',
                  fillColor: ext.surfaceColor,
                ),
              ),
              const SizedBox(height: 14),

              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _FieldLabel(_isLost ? 'Location lost' : 'Location found', ext), const SizedBox(height: 6),
                  _DropdownField(
                    value: _location,
                    items: AppConstants.locations.map((l) =>
                      DropdownMenuItem(value: l, child: Text(l, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _location = v ?? _location),
                    ext: ext,
                  ),
                ])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _FieldLabel(_isLost ? 'Date lost' : 'Date found', ext), const SizedBox(height: 6),
                  _DropdownField(
                    value: _date,
                    items: AppConstants.dateOptions.map((d) =>
                      DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (v) => setState(() => _date = v ?? _date),
                    ext: ext,
                  ),
                ])),
              ]),
              const SizedBox(height: 14),

              if (!_isLost) ...[
                _FieldLabel('Pickup / contact details', ext), const SizedBox(height: 6),
                TextFormField(
                  controller: _pickupCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Where will the owner meet you? Any verification needed?',
                    fillColor: ext.surfaceColor,
                  ),
                ),
                const SizedBox(height: 14),
              ],

              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _FieldLabel('Contact number', ext), const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+92 3xx xxxxxxx',
                      prefixIcon: const Icon(Icons.phone_outlined, size: 18),
                      fillColor: ext.surfaceColor,
                    ),
                  ),
                ])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _FieldLabel('Email', ext), const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'name@buitms.edu.pk',
                      prefixIcon: const Icon(Icons.mail_outline, size: 18),
                      fillColor: ext.surfaceColor,
                    ),
                  ),
                ])),
              ]),
              const SizedBox(height: 16),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ext.primarySoftColor, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Icon(Icons.shield_outlined, size: 16, color: ext.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(child: Text(
                    'Your phone number is shown only after a verified BUITEMS student taps "Contact".',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ext.primaryInkColor, height: 1.5),
                  )),
                ]),
              ),
            ]),
          ),
        ),

        // Submit bar
        Container(
          padding: EdgeInsets.fromLTRB(18, 12, 18, MediaQuery.of(context).padding.bottom + 12),
          decoration: BoxDecoration(
            color: ext.bgColor.withAlpha(230),
            border: Border(top: BorderSide(color: ext.borderColor)),
          ),
          child: Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ext.borderColor),
                shape: const StadiumBorder(),
                backgroundColor: ext.surface2Color,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
            )),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: Consumer<ItemsProvider>(
              builder: (_, ip, __) => ElevatedButton.icon(
                onPressed: ip.loading ? null : _submit,
                icon: ip.loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : Icon(_isEdit ? Icons.check : Icons.send_outlined, size: 16),
                label: Text(_isEdit ? 'Save changes' : (_isLost ? 'Post lost item' : 'Post found item'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent, foregroundColor: Colors.white,
                  shape: const StadiumBorder(), minimumSize: const Size.fromHeight(48),
                ),
              ),
            )),
          ]),
        ),
      ]),
    );
  }

  IconData _iconForCat(String cat) {
    switch (cat) {
      case 'id': return Icons.credit_card;
      case 'wal': return Icons.account_balance_wallet_outlined;
      case 'key': return Icons.key_outlined;
      case 'book': return Icons.menu_book_outlined;
      case 'elec': return Icons.devices_outlined;
      case 'calc': return Icons.calculate_outlined;
      case 'usb': return Icons.usb_outlined;
      case 'bag': return Icons.backpack_outlined;
      case 'sta': return Icons.edit_outlined;
      case 'clo': return Icons.checkroom_outlined;
      default: return Icons.label_outlined;
    }
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final AppThemeExtension ext;
  const _FieldLabel(this.text, this.ext);
  @override
  Widget build(BuildContext context) => Text(text,
    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: ext.textMutedColor, letterSpacing: 0.1));
}

class _SecondaryBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final AppThemeExtension ext;
  const _SecondaryBtn({required this.onTap, required this.icon, required this.label, required this.ext});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: ext.surface2Color, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 14, color: ext.textMutedColor),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: ext.textColor)),
      ]),
    ),
  );
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final AppThemeExtension ext;
  const _DropdownField({required this.value, required this.items, required this.onChanged, required this.ext});

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
    value: value, items: items, onChanged: onChanged,
    isExpanded: true,
    decoration: InputDecoration(
      filled: true, fillColor: ext.surfaceColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ext.borderStrongColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ext.borderStrongColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ext.primaryColor, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    dropdownColor: ext.surfaceColor,
    borderRadius: BorderRadius.circular(12),
    style: TextStyle(fontSize: 15, color: ext.textColor),
  );
}

class _StripePainter extends CustomPainter {
  final Color color;
  _StripePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    const spacing = 11.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(_StripePainter old) => old.color != color;
}
