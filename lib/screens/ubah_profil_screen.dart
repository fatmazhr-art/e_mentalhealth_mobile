import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konselor_chat_widgets.dart';

// Warna
const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _inputFill = Color(0xFFF9E8E5);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class UbahProfilScreen extends StatefulWidget {
  const UbahProfilScreen({super.key});

  @override
  State<UbahProfilScreen> createState() => _UbahProfilScreenState();
}

class _UbahProfilScreenState extends State<UbahProfilScreen> {
  final _namaC = TextEditingController(text: 'dr. Sarah V., Sp.KJ');
  final _emailC = TextEditingController(text: 'konselor@curhatin.id');
  final _hpC = TextEditingController(text: '0812-3456-7890');
  final _sipC = TextEditingController(text: '446.1/0482/SIP-DS/2021');

  @override
  void dispose() {
    _namaC.dispose();
    _emailC.dispose();
    _hpC.dispose();
    _sipC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            KonselorChatHeader(title: 'Ubah Profil'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatarSection(),
                    const SizedBox(height: 28),
                    _buildFormSection(),
                    const SizedBox(height: 20),
                    _buildPrivacyNotice(),
                    const SizedBox(height: 32),
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Avatar + edit ─────────────────────────────────────────────────────────

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _beige,
                  border: Border.all(color: _primary, width: 2.5),
                ),
                alignment: Alignment.center,
                child:
                    Text('SV', style: _t(28, weight: FontWeight.w800, color: _primary)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Ganti Foto Profil',
              style: _t(14, weight: FontWeight.w600, color: _primary)),
        ],
      ),
    );
  }

  // ── Form ─────────────────────────────────────────────────────────────────

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Nama Lengkap'),
        const SizedBox(height: 8),
        _inputField(controller: _namaC),
        const SizedBox(height: 18),
        _label('Nomor SIP'),
        const SizedBox(height: 8),
        _inputField(
          controller: _sipC,
          readOnly: true,
          suffix: const Icon(Icons.lock_outline, color: _primary, size: 20),
        ),
        const SizedBox(height: 4),
        Text('Tidak dapat diubah', style: _t(12, color: _textMuted)),
        const SizedBox(height: 18),
        _label('Email'),
        const SizedBox(height: 8),
        _inputField(
            controller: _emailC, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 18),
        _label('Nomor HP'),
        const SizedBox(height: 8),
        _inputField(controller: _hpC, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _label(String text) =>
      Text(text, style: _t(14, weight: FontWeight.w600));

  Widget _inputField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: _t(14.5),
      decoration: InputDecoration(
        filled: true,
        fillColor: _inputFill,
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: suffix,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(),
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

  // ── Privacy notice ────────────────────────────────────────────────────────

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primary.withValues(alpha: 0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Data pribadi kamu terlindungi enkripsi end-to-end. '
              'Curhatin menjamin kerahasiaan identitas dalam setiap sesi konseling.',
              style: _t(12.5, color: _primary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tombol ───────────────────────────────────────────────────────────────

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              // TODO: simpan ke API Laravel
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
            child: Text('Simpan Perubahan',
                style: _t(16, weight: FontWeight.w600, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
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
            child:
                Text('Batal', style: _t(16, weight: FontWeight.w600, color: _primary)),
          ),
        ),
      ],
    );
  }
}
