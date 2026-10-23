import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import 'login_screen.dart';

// Background terang untuk onboarding 1 & 2.
// Nanti bisa dipindah ke lib/theme.dart kalau mau dipakai di splash juga.
const Color _kBackgroundLight = Color(0xFFFBF7F4);

class _OnboardingData {
  final String image;
  final String title;
  final String? heading; // judul kedua (hanya halaman 3)
  final String body;
  final Color? bg; // null = pakai warna default tema

  const _OnboardingData({
    required this.image,
    required this.title,
    this.heading,
    required this.body,
    this.bg,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardingData(
      image: 'assets/images/onboarding_1.png',
      title: 'Kenali apa yang\nkamu rasakan',
      body: 'Luangkan waktu untuk memahami perasaan dan kondisi dirimu.',
      bg: _kBackgroundLight,
    ),
    _OnboardingData(
      image: 'assets/images/onboarding_2.png',
      title: 'Kelola stres\ndengan lebih baik',
      body: 'Temukan cara sederhana untuk menjaga keseimbangan diri.',
      bg: _kBackgroundLight,
    ),
    _OnboardingData(
      image: 'assets/images/logo.png',
      title: 'Hai, Kamu!',
      heading: 'Selamat Datang di CURHATIN',
      body: 'Dapatkan informasi dan dukungan yang bisa membantumu '
          'melewati masa-masa sulit.',
      // bg dikosongkan: halaman 3 tetap pakai warna default tema
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      // Tandai onboarding sudah dilihat, supaya tidak muncul lagi.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sudahOnboarding', true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _pages[_index].bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Align(
                    alignment: const Alignment(0, 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(p.image, width: width * 0.45),
                          const SizedBox(height: 28),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: kPrimary,
                              height: 1.3,
                            ),
                          ),
                          if (p.heading != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              p.heading!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: kPrimary,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            p.body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: kPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 28 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: IconButton(
                    onPressed: _next,
                    iconSize: 44,
                    color: kPrimary,
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}