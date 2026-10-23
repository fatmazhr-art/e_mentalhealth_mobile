import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'komponen_profil.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfilData data;

  const EditProfileScreen({super.key, required this.data});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaCtrl;
  late final TextEditingController _nimCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _hpCtrl;

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.data.nama);
    _nimCtrl = TextEditingController(text: widget.data.nim);
    _emailCtrl = TextEditingController(text: widget.data.email);
    _hpCtrl = TextEditingController(text: widget.data.noHp);
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _emailCtrl.dispose();
    _hpCtrl.dispose();
    super.dispose();
  }

  void _gantiFoto() {
    // TODO: pilih foto dari galeri/kamera (mis. package image_picker)
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Fitur ganti foto segera hadir.')),
      );
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final hasil = widget.data.copyWith(
      nama: _namaCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      noHp: _hpCtrl.text.trim(),
    );

    // TODO: kirim perubahan ke backend
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kProfilLatar,
      body: SafeArea(
        child: Column(
          children: [
            const ProfilTopBar(judul: 'Ubah Profil'),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _fotoProfil(),
                      const SizedBox(height: 24),
                      ProfilField(
                        label: 'Nama Lengkap',
                        controller: _namaCtrl,
                        hint: 'Nama lengkap',
                        keyboardType: TextInputType.name,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      ProfilField(
                        label: 'Nomor Induk Mahasiswa (NIM)',
                        controller: _nimCtrl,
                        enabled: false,
                        prefixIcon: Icons.lock_outline_rounded,
                        helper: 'Tidak dapat diubah',
                      ),
                      const SizedBox(height: 18),
                      ProfilField(
                        label: 'Email',
                        controller: _emailCtrl,
                        hint: 'nama@email.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final s = v?.trim() ?? '';
                          if (s.isEmpty) return 'Email tidak boleh kosong';
                          final ok =
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
                          return ok ? null : 'Format email tidak valid';
                        },
                      ),
                      const SizedBox(height: 18),
                      ProfilField(
                        label: 'Nomor HP',
                        controller: _hpCtrl,
                        hint: '08xx-xxxx-xxxx',
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          final digit =
                              (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                          if (digit.isEmpty) return 'Nomor HP tidak boleh kosong';
                          if (digit.length < 10) return 'Nomor HP terlalu pendek';
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      _kartuPrivasi(),
                      const SizedBox(height: 24),
                      TombolUtama(label: 'Simpan Perubahan', onPressed: _simpan),
                      const SizedBox(height: 12),
                      TombolBatal(onPressed: () => Navigator.maybePop(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fotoProfil() {
    return Column(
      children: [
        GestureDetector(
          onTap: _gantiFoto,
          child: Stack(
            children: [
              const ProfilAvatar(ukuran: 104),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.maroon,
                    shape: BoxShape.circle,
                    border: Border.all(color: kProfilLatar, width: 2.5),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _gantiFoto,
          child: const Text(
            'Ganti Foto Profil',
            style: TextStyle(
              color: AppColors.maroon,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _kartuPrivasi() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kProfilPink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.maroon, size: 26),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Data pribadi kamu terlindungi enkripsi end-to-end. Curhatin '
              'menjamin kerahasiaan identitas dan tidak membagikannya kepada '
              'pihak mana pun tanpa izinmu.',
              style: TextStyle(
                color: kProfilTeksGelap,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}