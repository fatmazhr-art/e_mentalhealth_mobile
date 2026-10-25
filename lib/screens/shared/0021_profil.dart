import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../mahasiswa/0018_kalender.dart';
import '../mahasiswa/0019_chatbot.dart';
import '../mahasiswa/0020_notifikasi.dart';
import '0022_ubah_profil.dart';
import '0023_kelola_kata_sandi.dart';
import '../pop_up/komponen_logout.dart';
import '../pop_up/komponen_profil.dart';

class ProfileScreen extends StatefulWidget {
  final bool isKonselor;

  const ProfileScreen({
    super.key,
    this.isKonselor = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _tabAktif = 3;

  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data berdasarkan role (Konselor vs Mahasiswa)
    _data = widget.isKonselor
        ? {
            'nama': 'DR. SARAH V., SP.KJ',
            'fullName': 'dr. Sarah V., Sp.KJ',
            'sip': '446.1/0482/SIP-DS/2021',
            'email': 'konselor@curhatin.id',
            'noHp': '0812-3456-7890',
            'spesialisasi': 'Spesialis Kedokteran Jiwa',
          }
        : {
            'nama': 'Natasha Romanoff',
            'fullName': 'Natasha Romanoff',
            'nim': '20190106',
            'forumAlias': 'Kucing Tenang',
            'email': 'natsblackwidow@gmail.com',
            'noHp': '0819-2008-1167',
          };
  }

  Future<void> _ubahProfil() async {
    final hasil = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          data: _data,
          isKonselor: widget.isKonselor,
        ),
      ),
    );

    if (hasil != null && mounted) {
      setState(() {
        _data = {
          ..._data,
          ...hasil,
          'nama': hasil['fullName'] ?? hasil['nama'] ?? _data['nama'],
        };
      });
    }
  }

  void _kelolaKataSandi() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManagePasswordScreen()),
    );
  }

  void _konfirmasiKeluar() {
    showLogoutDialog(
      context,
      onConfirm: () async {
        // TODO: hapus sesi login (token, SharedPreferences, state, dll.)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: widget.isKonselor ? 32 : 120),
        child: Column(
          children: [
            _headerGelombang(),
            const SizedBox(height: 64),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _kartuInfo(),
                  const SizedBox(height: 20),
                  _kartuMenu(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.isKonselor
          ? null
          : SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                ),
                backgroundColor: AppColors.maroon,
                elevation: 2,
                shape: const CircleBorder(),
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 150,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 150,
                  ),
                ),
              ),
            ),
      bottomNavigationBar: widget.isKonselor
          ? null
          : BottomAppBar(
              color: kProfilKartu,
              surfaceTintColor: Colors.transparent,
              elevation: 12,
              shadowColor: Colors.black.withAlpha(90),
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              height: 74,
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      ikon: Icons.home_outlined,
                      label: 'Beranda',
                      aktif: _tabAktif == 0,
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      ikon: Icons.calendar_month_outlined,
                      label: 'Kalender',
                      aktif: _tabAktif == 1,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalendarMoodTrackerScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 84),
                  Expanded(
                    child: _NavItem(
                      ikon: Icons.move_to_inbox_outlined,
                      label: 'Notifikasi',
                      aktif: _tabAktif == 2,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      ikon: Icons.person,
                      label: 'Profile',
                      aktif: _tabAktif == 3,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _headerGelombang() {
    const tinggi = 150.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          child: SizedBox(
            width: double.infinity,
            height: tinggi,
            child: Image.asset(
              'assets/images/profilbanner.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Gagal memuat banner: $error');
                return CustomPaint(painter: _WavePainter());
              },
            ),
          ),
        ),
        const Positioned(
          bottom: -52,
          left: 0,
          right: 0,
          child: Center(child: ProfilAvatar(ukuran: 104)),
        ),
      ],
    );
  }

  Widget _kartuInfo() {
    final namaTampil = (_data['nama'] ?? _data['fullName'] ?? '').toString();
    final idTampil = widget.isKonselor
        ? (_data['spesialisasi'] ?? _data['sip'] ?? '').toString()
        : 'NIM. ${(_data['nim'] ?? '').toString()}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: kProfilKartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kProfilGaris),
      ),
      child: Column(
        children: [
          Text(
            namaTampil.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kProfilTeksGelap,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            idTampil,
            style: const TextStyle(color: kProfilTeksAbu, fontSize: 13.5),
          ),
        ],
      ),
    );
  }

  Widget _kartuMenu() {
    return Container(
      decoration: BoxDecoration(
        color: kProfilKartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kProfilGaris),
      ),
      child: Column(
        children: [
          _BarisMenu(
            label: 'Ubah Profil',
            ikon: Icons.chevron_right_rounded,
            onTap: _ubahProfil,
          ),
          const _Pemisah(),
          _BarisMenu(
            label: 'Kelola Kata sandi',
            ikon: Icons.chevron_right_rounded,
            onTap: _kelolaKataSandi,
          ),
          const _Pemisah(),
          _BarisMenu(
            label: 'Keluar',
            ikon: Icons.logout_rounded,
            ikonWarna: AppColors.maroon,
            onTap: _konfirmasiKeluar,
          ),
        ],
      ),
    );
  }
}

class _Pemisah extends StatelessWidget {
  const _Pemisah();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        color: kProfilGaris,
        indent: 18,
        endIndent: 18,
      );
}

class _BarisMenu extends StatelessWidget {
  final String label;
  final IconData ikon;
  final Color ikonWarna;
  final VoidCallback onTap;

  const _BarisMenu({
    required this.label,
    required this.ikon,
    required this.onTap,
    this.ikonWarna = kProfilTeksGelap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: kProfilTeksGelap,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(ikon, color: ikonWarna, size: 24),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final beige = Path()
      ..lineTo(0, h * 0.82)
      ..quadraticBezierTo(w * 0.25, h * 1.02, w * 0.55, h * 0.84)
      ..quadraticBezierTo(w * 0.82, h * 0.68, w, h * 0.86)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(beige, Paint()..color = const Color(0xFFF1DCCB));

    final maroon = Path()
      ..lineTo(0, h * 0.58)
      ..quadraticBezierTo(w * 0.28, h * 0.84, w * 0.58, h * 0.60)
      ..quadraticBezierTo(w * 0.84, h * 0.40, w, h * 0.62)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(maroon, Paint()..color = AppColors.maroon);

    canvas.drawCircle(
      Offset(w * 0.86, h * 0.16),
      34,
      Paint()..color = Colors.white.withAlpha(25),
    );
    canvas.drawCircle(
      Offset(w * 0.12, h * 0.30),
      22,
      Paint()..color = Colors.white.withAlpha(20),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NavItem extends StatelessWidget {
  final IconData ikon;
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _NavItem({
    required this.ikon,
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final warna = aktif ? AppColors.maroon : kProfilTeksAbu;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, size: 28, color: warna),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: warna,
              fontSize: 12,
              fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}