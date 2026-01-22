import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ✅ ganti sesuai file login kamu
import 'package:lumiere/features/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _saving = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    // ✅ penting: jangan pop (balik ke home), tapi reset stack ke login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _editDisplayName() async {
    final user = _user;
    if (user == null) return;

    final controller = TextEditingController(text: user.displayName ?? '');
    final name = await _showTextDialog(
      title: 'Edit Name',
      hint: 'contoh: Federix',
      controller: controller,
      keyboardType: TextInputType.name,
    );
    if (name == null) return;

    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    try {
      setState(() => _saving = true);
      await user.updateDisplayName(trimmed);
      await user.reload();

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama berhasil diupdate ✅')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update nama: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ✅ Foto profil: pakai URL saja (tanpa Storage)
  Future<void> _editPhotoUrl() async {
    final user = _user;
    if (user == null) return;

    final controller = TextEditingController(text: user.photoURL ?? '');
    final url = await _showTextDialog(
      title: 'Update Photo URL',
      hint: 'tempel link gambar (https://...)',
      controller: controller,
      keyboardType: TextInputType.url,
    );
    if (url == null) return;

    final trimmed = url.trim();
    if (trimmed.isEmpty) return;

    final ok = trimmed.startsWith('http://') || trimmed.startsWith('https://');
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL harus diawali http/https')),
      );
      return;
    }

    try {
      setState(() => _saving = true);
      await user.updatePhotoURL(trimmed);
      await user.reload();

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diupdate ✅')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update foto: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<String?> _showTextDialog({
    required String title,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const brand = Color(0xFF1E1B4B);
    const textSub = Color(0xFF64748B);

    final user = _user;

    // ✅ kalau user null, lempar ke login (biar ga blank)
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final displayName = (user.displayName?.trim().isNotEmpty ?? false)
        ? user.displayName!.trim()
        : 'Lumiere User';

    final email = user.email ?? '-';
    final uid = user.uid;
    final createdAt = user.metadata.creationTime;
    final createdText = createdAt == null
        ? '-'
        : '${createdAt.day.toString().padLeft(2, '0')}/'
              '${createdAt.month.toString().padLeft(2, '0')}/'
              '${createdAt.year}';

    final photoUrl = user.photoURL;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1B4B), Color(0xFFA78BFA)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white.withOpacity(0.22),
                        backgroundImage:
                            (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.isEmpty)
                            ? const Icon(
                                Icons.person_rounded,
                                size: 36,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: InkWell(
                          onTap: _saving ? null : _editPhotoUrl,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: brand,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(
                              icon: Icons.calendar_month_rounded,
                              label: 'Member since $createdText',
                            ),
                            _chip(
                              icon: Icons.verified_rounded,
                              label: user.emailVerified
                                  ? 'Verified'
                                  : 'Not verified',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _card(
              title: 'Account Info',
              child: Column(
                children: [
                  _infoRow('Email', email),
                  const SizedBox(height: 10),
                  _infoRow('User ID', uid),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _card(
              title: 'Actions',
              child: Column(
                children: [
                  _actionTile(
                    icon: Icons.badge_rounded,
                    title: 'Edit Name',
                    subtitle: 'Ubah nama tampilan kamu',
                    onTap: _saving ? null : _editDisplayName,
                  ),
                  const SizedBox(height: 10),
                  _actionTile(
                    icon: Icons.image_rounded,
                    title: 'Update Photo URL',
                    subtitle: 'Tempel link gambar (https://...)',
                    onTap: _saving ? null : _editPhotoUrl,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _logout,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brand,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  if (_saving) ...[
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(minHeight: 3),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Tip: Upload foto ke Imgur / Drive public, lalu tempel URL-nya di sini.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textSub, height: 1.3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          color: const Color(0xFFF8FAFC),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF1E1B4B).withOpacity(0.08),
              ),
              child: Icon(icon, color: const Color(0xFF1E1B4B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
