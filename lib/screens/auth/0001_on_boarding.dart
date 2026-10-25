import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '0003_login.dart';

class _OnboardingData {
  final String gambar; // path aset
  final IconData ikonCadangan; // dipakai kalau file gambar belum ada
  final String judul;
  final String? subjudul;
  final String deskripsi;
  final double ukuranJudul;

  const _OnboardingData({
    required this.gambar,
    required this.ikonCadangan,
    required this.judul,
    this.subjudul,
    required this.deskripsi,
    this.ukuranJudul = 24,
  });
}

/// Alur: splash (logo, 3 detik) -> onboarding 3 halaman -> login.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  Timer? _timer;
  bool _tampilSplash = true;
  int _halamanAktif = 0;

  static const String _logo = 'assets/images/logo.png';

  // Gambar: export ikon dari Figma sebagai PNG transparan, taruh di assets/images/
  static const List<_OnboardingData> _halaman = [
    _OnboardingData(
      gambar: 'assets/images/onboarding1.png',
      ikonCadangan: Icons.psychology_outlined,
      judul: 'Kenali apa yang\nkamu rasakan',
      deskripsi: 'Luangkan waktu untuk memahami\nperasaan dan kondisi dirimu.',
    ),
    _OnboardingData(
      gambar: 'assets/images/onboarding2.png',
      ikonCadangan: Icons.self_improvement,
      judul: 'Kelola stres\ndengan lebih baik',
      deskripsi: 'Temukan cara sederhana untuk\nmenjaga keseimbangan diri.',
    ),
    _OnboardingData(
      gambar: _logo,
      ikonCadangan: Icons.favorite,
      judul: 'Hai, Kamu!',
      subjudul: 'Selamat Datang di CURHATIN', 
      deskripsi:
          'Dapatkan informasi dan dukungan\nyang bisa membantumu melewati\nmasa-masa sulit.',
      ukuranJudul: 28,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Splash tampil 3 detik, lalu berganti ke onboarding
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _tampilSplash = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _keLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _lanjut() {
    if (_halamanAktif == _halaman.length - 1) {
      _keLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _gambar(String path, IconData ikonCadangan,
      {double tinggi = 190, double ukuranIkon = 150}) {
    return Image.asset(
      path,
      height: tinggi,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        ikonCadangan,
        size: ukuranIkon,
        color: AppColors.maroon,
      ),
    );
  }

  // ---------- SPLASH ----------
  Widget _buildSplash() {
    return Stack(
      key: const ValueKey('splash'),
      children: [
        // Lingkaran cincin maroon (kiri atas)
        Positioned(
          top: -170,
          left: -170,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.maroon, width: 45),
            ),
          ),
        ),
        // Lingkaran coral (kanan atas)
        Positioned(
          top: -70,
          right: -50,
          child: Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.coral,
            ),
          ),
        ),
        // Bentuk coral besar (kiri bawah)
        Positioned(
          bottom: -170,
          left: -110,
          child: Container(
            width: 460,
            height: 300,
            decoration: const BoxDecoration(
              color: AppColors.coral,
              borderRadius: BorderRadius.all(Radius.elliptical(260, 170)),
            ),
          ),
        ),
        // Lingkaran maroon (kanan bawah)
        Positioned(
          bottom: -110,
          right: -80,
          child: Container(
            width: 240,
            height: 240,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.maroon,
            ),
          ),
        ),
        // Logo dan nama aplikasi
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _gambar(_logo, Icons.favorite, tinggi: 200, ukuranIkon: 200),
              const SizedBox(height: 8),
              
            ],
          ),
        ),
      ],
    );
  }

  // ---------- ONBOARDING ----------
  Widget _buildOnboarding() {
    return SafeArea(
      key: const ValueKey('onboarding'),
      child: Column(
        children: [
          // Halaman yang bisa digeser
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _halaman.length,
              onPageChanged: (index) => setState(() => _halamanAktif = index),
              itemBuilder: (context, index) {
                final data = _halaman[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _gambar(data.gambar, data.ikonCadangan),
                      const SizedBox(height: 36),
                      Text(
                        data.judul,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.maroon,
                          fontSize: data.ukuranJudul,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      if (data.subjudul != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          data.subjudul!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.maroon,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        data.deskripsi,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.maroon,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Titik penunjuk halaman
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_halaman.length, (index) {
              final aktif = index == _halamanAktif;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: aktif ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.maroon,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          // Tombol panah di kanan bawah
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 28, 36),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _lanjut,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_circle_right_outlined,
                  size: 34,
                  color: AppColors.maroon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _tampilSplash ? _buildSplash() : _buildOnboarding(),
      ),
    );
  }
}