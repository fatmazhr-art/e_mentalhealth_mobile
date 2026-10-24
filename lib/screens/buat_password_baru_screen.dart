import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konselor_login_screen.dart';

// Warna
const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _inputFill = Color(0xFFF9E8E5);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

/// Layar reset password setelah verifikasi OTP.
class BuatPasswordBaruScreen extends StatefulWidget {
  const BuatPasswordBaruScreen({super.key});

  @override
  State<BuatPasswordBaruScreen> createState() =>
      _BuatPasswordBaruScreenState();
}

class _BuatPasswordBaruScreenState extends State<BuatPasswordBaruScreen> {
  final _lamaC = TextEditingController();
  final _baruC = TextEditingController();
  final _konfirmasiC = TextEditingController();
  bool _obscureLama = true;
  bool _obscureBaru = true;
  bool _obscureKonfirmasi = true;

  bool get _minChar => _baruC.text.length >= 8;
  bool get _hasComplex =>
      RegExp(r'(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*])').hasMatch(_baruC.text);
  bool get _different =>
      _baruC.text.isNotEmpty && _baruC.text != _lamaC.text;

  int get _strength {
    int s = 0;
    if (_minChar) s++;
    if (_hasComplex) s++;
    if (_different) s++;
    return s;
  }

  @override
  void dispose() {
    _lamaC.dispose();
    _baruC.dispose();
    _konfirmasiC.dispose();
    super.dispose();
  }

  void _simpan() {
    // TODO: reset password via API Laravel, lalu kembali ke login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const KonselorLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _primary, size: 26),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 24),

              // Judul
              Text('Buat Password Baru',
                  style: _t(26, weight: FontWeight.w800)),
              const SizedBox(height: 12),
              Text(
                'Pastikan kata sandi baru Anda kuat, unik, dan belum pernah '
                'digunakan untuk menjaga kerahasiaan ruang konseling pribadi Anda.',
                textAlign: TextAlign.center,
                style: _t(14, color: _textMuted),
              ),
              const SizedBox(height: 32),

              // Form
              _label('Password lama'),
              const SizedBox(height: 8),
              _passField(_lamaC, _obscureLama,
                  () => setState(() => _obscureLama = !_obscureLama)),
              const SizedBox(height: 18),

              _label('Password baru'),
              const SizedBox(height: 8),
              _passField(_baruC, _obscureBaru,
                  () => setState(() => _obscureBaru = !_obscureBaru)),
              const SizedBox(height: 10),
              _buildStrengthBars(),
              const SizedBox(height: 14),
              _buildStrengthCriteria(),
              const SizedBox(height: 18),

              _label('Konfirmasi password baru'),
              const SizedBox(height: 8),
              _passField(
                  _konfirmasiC,
                  _obscureKonfirmasi,
                  () => setState(
                      () => _obscureKonfirmasi = !_obscureKonfirmasi)),
              const SizedBox(height: 40),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text('Simpan Password',
                      style: _t(16,
                          weight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol batal
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _beige,
                    foregroundColor: _primary,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text('Batal',
                      style: _t(16,
                          weight: FontWeight.w600, color: _primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: _t(14, weight: FontWeight.w600, color: _primary));

  Widget _passField(
    TextEditingController c,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: c,
      obscureText: obscure,
      onChanged: (_) => setState(() {}),
      style: _t(15),
      decoration: InputDecoration(
        filled: true,
        fillColor: _inputFill,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: _primary,
            size: 22,
          ),
          onPressed: toggle,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildStrengthBars() {
    return Row(
      children: List.generate(3, (i) {
        final filled = i < _strength;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            height: 5,
            decoration: BoxDecoration(
              color: filled ? _primary : const Color(0xFFEBD8CB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStrengthCriteria() {
    final criteria = [
      (label: 'Minimal 8 karakter', met: _minChar),
      (label: 'Ada huruf besar, angka, karakter spesial', met: _hasComplex),
      (label: 'Berbeda dari Password lama', met: _different),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Indikator kekuatan:', style: _t(13, weight: FontWeight.w500)),
        const SizedBox(height: 8),
        for (final c in criteria) ...[
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.met ? _primary : const Color(0xFFEBD8CB),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(c.label, style: _t(13))),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
