import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/features/home/home_page.dart';
import 'package:lumiere/features/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  String? _err;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailC.text.trim(),
        password: _passC.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg1 = Color(0xFF0B1020);
    const bg2 = Color(0xFF2B1B5A);
    const card = Color(0xFFFFFFFF);
    const brand = Color(0xFF1E1B4B);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg1, bg2],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    // glow blobs
                    Positioned(
                      left: -30,
                      top: -40,
                      child: _GlowBlob(
                        color: const Color(0xFFA78BFA).withOpacity(0.35),
                      ),
                    ),
                    Positioned(
                      right: -40,
                      bottom: -50,
                      child: _GlowBlob(
                        color: const Color(0xFF60A5FA).withOpacity(0.30),
                      ),
                    ),

                    // card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: card.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFA78BFA),
                                      Color(0xFF60A5FA),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'LUMIÈRE',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                        color: brand,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Small reflections, brighter mind',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF64748B),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Welcome back 👋',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: const Color(0xFF0F172A),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login untuk lanjut ke timeline dan insight kamu.',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                height: 1.2,
                              ),
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
                            hint: '••••••••',
                            controller: _passC,
                            obscureText: _obscure,
                            prefix: Icons.lock_rounded,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                              ),
                              tooltip: _obscure ? 'Show' : 'Hide',
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
                                border: Border.all(
                                  color: const Color(0xFFFCA5A5),
                                ),
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
                              onPressed: _loading ? null : _login,
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
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum punya akun? ',
                                style: TextStyle(color: Color(0xFF64748B)),
                              ),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () async {
                                        final created =
                                            await Navigator.push<bool>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const RegisterPage(),
                                              ),
                                            );

                                        if (!mounted) return;
                                        if (created == true) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Register berhasil ✅ Silakan login',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  const _GlowBlob({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
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
