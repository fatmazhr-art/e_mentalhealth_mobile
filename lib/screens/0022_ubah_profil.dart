import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/circle_back_button.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const EditProfileScreen({
    super.key,
    this.data,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _namaController;
  late TextEditingController _nimController;
  late TextEditingController _forumAliasController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.data?['fullName'] ?? widget.data?['nama'] ?? 'Natasha Romanoff',
    );
    _nimController = TextEditingController(
      text: widget.data?['nim'] ?? '20190106',
    );
    _forumAliasController = TextEditingController(
      text: widget.data?['forumAlias'] ?? 'Kucing Tenang',
    );
    _emailController = TextEditingController(
      text: widget.data?['email'] ?? 'natsblackwidow@gmail.com',
    );
    _phoneController = TextEditingController(
      text: widget.data?['noHp'] ?? widget.data?['phone'] ?? '0819-2008-1167',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _forumAliasController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _simpanPerubahan() {
    final updatedData = {
      'fullName': _namaController.text,
      'nama': _namaController.text,
      'nim': _nimController.text,
      'forumAlias': _forumAliasController.text,
      'email': _emailController.text,
      'noHp': _phoneController.text,
    };

    Navigator.pop(context, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    const kBgColor = Color(0xFFFFFBF5);
    const kTextDark = Color(0xFF222222);

    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCFAF8),
        elevation: 0,
        leading: const CircleBackButton(),
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: kTextDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ---------------- Foto Profil & Edit Button ----------------
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.maroon, width: 3),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profil.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.maroon,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ganti Foto Profil',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kTextDark,
              ),
            ),
            const SizedBox(height: 24),

            // ---------------- Input Form Fields ----------------
            _buildInputField('Nama Lengkap', _namaController),
            const SizedBox(height: 16),
            
            _buildInputField(
              'Nomor Induk Mahasiswa (NIM)',
              _nimController,
              readOnly: true,
              suffixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey),
              helperText: 'Tidak dapat diubah',
            ),
            const SizedBox(height: 16),

            _buildInputField('Nama Samaran Forum', _forumAliasController),
            const SizedBox(height: 16),

            _buildInputField('Email', _emailController),
            const SizedBox(height: 16),

            _buildInputField('Nomor HP', _phoneController),
            const SizedBox(height: 24),

            // ---------------- Card Info Enkripsi ----------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF9), // Warna fill cream disesuaikan
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF5E6DA)), // Border beige halus
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.maroon, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Data pribadi kamu terlindungi enkripsi end-to-end. Curhatin menjamin kerahasiaan identitas dalam setiap sesi konseling.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.maroon.withAlpha(200),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ---------------- Action Buttons ----------------
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _simpanPerubahan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFDF9),
                  side: const BorderSide(color: Color(0xFFF5E6DA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: AppColors.maroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget dengan warna fill cream & border beige seperti Kelola Kata Sandi
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    Widget? suffixIcon,
    String? helperText,
  }) {
    const kCreamFill = Color(0xFFFFFDF9);
    const kBorderBeige = Color(0xFFF5E6DA);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: kCreamFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderBeige),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF222222),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ]
      ],
    );
  }
}