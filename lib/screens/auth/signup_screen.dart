import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_constants.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _step = 1;
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _department = 'cs';
  String _semester = '1st Semester';
  bool _showPw = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _pwCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form2Key.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final dept = AppConstants.departments.firstWhere(
      (d) => d['value'] == _department, orElse: () => {'label': _department},
    )['label']!;

    final ok = await auth.signUp(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _pwCtrl.text,
      department: dept,
      semester: _semester,
      phone: _phoneCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Sign up failed'), backgroundColor: const Color(0xFFF25C54)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Scaffold(
      backgroundColor: ext.bgColor,
      body: SafeArea(
        child: Column(children: [
          _AppBar(
            onBack: () => _step > 1 ? setState(() => _step = 1) : Navigator.pop(context),
          ),
          // Step progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: List.generate(2, (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i == 0 ? 6 : 0, left: i == 1 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: _step > i ? const Color(0xFF6E4FF6) : ext.surface3Color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ))),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _step == 1 ? _Step1(
                  key: const ValueKey(1),
                  formKey: _form1Key,
                  nameCtrl: _nameCtrl,
                  emailCtrl: _emailCtrl,
                  pwCtrl: _pwCtrl,
                  showPw: _showPw,
                  onTogglePw: () => setState(() => _showPw = !_showPw),
                  onContinue: () {
                    if (_form1Key.currentState!.validate()) setState(() => _step = 2);
                  },
                  onLoginTap: () => Navigator.pushReplacementNamed(context, '/login'),
                ) : _Step2(
                  key: const ValueKey(2),
                  formKey: _form2Key,
                  phoneCtrl: _phoneCtrl,
                  department: _department,
                  semester: _semester,
                  onDeptChanged: (v) => setState(() => _department = v),
                  onSemChanged: (v) => setState(() => _semester = v),
                  onSubmit: _submit,
                  onLoginTap: () => Navigator.pushReplacementNamed(context, '/login'),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, emailCtrl, pwCtrl;
  final bool showPw;
  final VoidCallback onTogglePw, onContinue, onLoginTap;

  const _Step1({
    super.key, required this.formKey,
    required this.nameCtrl, required this.emailCtrl, required this.pwCtrl,
    required this.showPw, required this.onTogglePw,
    required this.onContinue, required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Form(
      key: formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Create your account',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.52, color: ext.textColor),
        ),
        const SizedBox(height: 6),
        Text("We'll send a verification link to your BUITEMS email.",
          style: TextStyle(fontSize: 15, color: ext.textMutedColor),
        ),
        const SizedBox(height: 24),
        _Label('Full name'), const SizedBox(height: 6),
        TextFormField(
          controller: nameCtrl,
          decoration: InputDecoration(
            hintText: 'e.g. Hammad Khan',
            prefixIcon: const Icon(Icons.person_outline, size: 20),
            fillColor: ext.surfaceColor,
          ),
          validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Enter your name',
        ),
        const SizedBox(height: 14),
        _Label('University email'), const SizedBox(height: 6),
        TextFormField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@buitms.edu.pk',
            prefixIcon: const Icon(Icons.mail_outline, size: 20),
            fillColor: ext.surfaceColor,
          ),
          validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
        ),
        const SizedBox(height: 14),
        _Label('Password'), const SizedBox(height: 6),
        TextFormField(
          controller: pwCtrl,
          obscureText: !showPw,
          decoration: InputDecoration(
            hintText: 'Min. 8 characters',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            fillColor: ext.surfaceColor,
            suffixIcon: GestureDetector(
              onTap: onTogglePw,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(showPw ? 'HIDE' : 'SHOW',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: ext.textMutedColor)),
              ),
            ),
          ),
          validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E4FF6), foregroundColor: Colors.white,
              shape: const StadiumBorder(), elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 16),
        Center(child: GestureDetector(
          onTap: onLoginTap,
          child: const Text.rich(TextSpan(children: [
            TextSpan(text: 'Already have an account? ', style: TextStyle(color: Color(0xFF9A9AAE), fontSize: 13.5)),
            TextSpan(text: 'Sign in', style: TextStyle(color: Color(0xFF6E4FF6), fontWeight: FontWeight.w600, fontSize: 13.5)),
          ])),
        )),
      ]),
    );
  }
}

class _Step2 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneCtrl;
  final String department, semester;
  final ValueChanged<String> onDeptChanged, onSemChanged;
  final VoidCallback onSubmit, onLoginTap;

  const _Step2({
    super.key, required this.formKey,
    required this.phoneCtrl, required this.department, required this.semester,
    required this.onDeptChanged, required this.onSemChanged,
    required this.onSubmit, required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Form(
      key: formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('A few details',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.52, color: ext.textColor),
        ),
        const SizedBox(height: 6),
        Text('So others can identify your posts and reach you.',
          style: TextStyle(fontSize: 15, color: ext.textMutedColor),
        ),
        const SizedBox(height: 24),
        _Label('Department'), const SizedBox(height: 6),
        _DropdownField(
          value: department,
          items: AppConstants.departments.map((d) =>
            DropdownMenuItem(value: d['value']!, child: Text(d['label']!))
          ).toList(),
          onChanged: (v) => onDeptChanged(v ?? department),
          hint: 'Pick your department',
          fillColor: ext.surfaceColor,
          borderColor: ext.borderStrongColor,
        ),
        const SizedBox(height: 14),
        _Label('Semester'), const SizedBox(height: 6),
        _DropdownField(
          value: semester,
          items: AppConstants.semesters.map((s) =>
            DropdownMenuItem(value: s, child: Text(s))
          ).toList(),
          onChanged: (v) => onSemChanged(v ?? semester),
          hint: 'Semester',
          fillColor: ext.surfaceColor,
          borderColor: ext.borderStrongColor,
        ),
        const SizedBox(height: 14),
        _Label('Phone number'), const SizedBox(height: 6),
        TextFormField(
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+92 3xx xxxxxxx',
            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            fillColor: ext.surfaceColor,
          ),
          validator: (v) => v != null && v.isNotEmpty ? null : 'Enter your phone',
        ),
        const SizedBox(height: 24),
        Consumer<AuthProvider>(
          builder: (_, auth, __) => SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: auth.loading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E4FF6), foregroundColor: Colors.white,
                shape: const StadiumBorder(), elevation: 0,
              ),
              child: auth.loading
                  ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : const Text('Create account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(child: GestureDetector(
          onTap: onLoginTap,
          child: const Text.rich(TextSpan(children: [
            TextSpan(text: 'Already have an account? ', style: TextStyle(color: Color(0xFF9A9AAE), fontSize: 13.5)),
            TextSpan(text: 'Sign in', style: TextStyle(color: Color(0xFF6E4FF6), fontWeight: FontWeight.w600, fontSize: 13.5)),
          ])),
        )),
      ]),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600,
      color: context.ext.textMutedColor, letterSpacing: 0.1),
  );
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String hint;
  final Color fillColor, borderColor;

  const _DropdownField({
    required this.value, required this.items, required this.onChanged,
    required this.hint, required this.fillColor, required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true, fillColor: fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6E4FF6), width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintText: hint,
      ),
      dropdownColor: fillColor,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBar({required this.onBack});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Row(children: [
      IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: onBack),
    ]),
  );
}
