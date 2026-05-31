import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _showPw = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.signIn(_emailCtrl.text, _pwCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Sign in failed'), backgroundColor: const Color(0xFFF25C54)),
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
          _AppBar(onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Welcome back',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                      letterSpacing: -0.52, color: ext.textColor),
                  ),
                  const SizedBox(height: 6),
                  Text('Sign in to continue with your BUITEMS account.',
                    style: TextStyle(fontSize: 15, color: ext.textMutedColor),
                  ),
                  const SizedBox(height: 28),

                  _FieldLabel('University email'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'name@buitms.edu.pk',
                      prefixIcon: const Icon(Icons.mail_outline, size: 20),
                      fillColor: ext.surfaceColor,
                    ),
                    validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 14),

                  _FieldLabel('Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _pwCtrl,
                    obscureText: !_showPw,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      fillColor: ext.surfaceColor,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _showPw = !_showPw),
                        child: Align(
                          alignment: Alignment.center,
                          widthFactor: 1.0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Text(
                              _showPw ? 'HIDE' : 'SHOW',
                              style: TextStyle(
                                fontSize: 11.5, fontWeight: FontWeight.w700,
                                color: ext.textMutedColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                  ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _forgotPassword(context),
                      child: const Text('Forgot password?',
                        style: TextStyle(color: Color(0xFF6E4FF6), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6E4FF6),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: auth.loading
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              )
                            : const Text('Sign in',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Row(children: [
                    Expanded(child: Divider(color: ext.borderColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: TextStyle(fontSize: 12, color: ext.textFaintColor)),
                    ),
                    Expanded(child: Divider(color: ext.borderColor)),
                  ]),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity, height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: ext.borderColor),
                        shape: const StadiumBorder(),
                        backgroundColor: ext.surface2Color,
                        foregroundColor: ext.textColor,
                      ),
                      child: const Text('Create a new account',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _forgotPassword(BuildContext context) async {
    if (_emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first')),
      );
      return;
    }
    final ok = await context.read<AuthProvider>().sendPasswordReset(_emailCtrl.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Reset link sent. Check your inbox.' : 'Failed to send reset email'),
    ));
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: onBack,
        ),
      ]),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5, fontWeight: FontWeight.w600,
        color: context.ext.textMutedColor, letterSpacing: 0.1,
      ),
    );
  }
}
