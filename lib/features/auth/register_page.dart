import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _pass2C = TextEditingController();

  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _err;

  Future<void> _register() async {
    final email = _emailC.text.trim();
    final pass = _passC.text.trim();
    final pass2 = _pass2C.text.trim();

    if (pass != pass2) {
      setState(() => _err = 'Password tidak sama.');
      return;
    }
    if (pass.length < 6) {
      setState(() => _err = 'Password minimal 6 karakter.');
      return;
    }

    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // ✅ penting: setelah register, langsung signOut supaya tidak auto-login
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register berhasil ✅ Silakan login')),
      );

      // return true ke LoginPage
      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      setState(() => _err = e.message ?? e.code);
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _pass2C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const brand = Color(0xFF1E1B4B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create your account ✨',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Buat akun untuk menyimpan timeline & insight kamu.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _Field(
                    label: 'Email',
                    hint: 'name@email.com',
                    controller: _emailC,
                    keyboardType: TextInputType.emailAddress,
                    prefix: Icons.mail_rounded,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Password',
                    hint: 'minimal 6 karakter',
                    controller: _passC,
                    obscureText: _obscure1,
                    prefix: Icons.lock_rounded,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                      icon: Icon(
                        _obscure1
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Confirm Password',
                    hint: 'ulangin password',
                    controller: _pass2C,
                    obscureText: _obscure2,
                    prefix: Icons.lock_reset_rounded,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                      icon: Icon(
                        _obscure2
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),

                  if (_err != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Text(
                        _err!,
                        style: const TextStyle(
                          color: Color(0xFF991B1B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brand,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefix;
  final Widget? suffix;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix == null ? null : Icon(prefix),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFA78BFA),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
