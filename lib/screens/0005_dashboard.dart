import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '0006_assesmen.dart';
import '0010_jadwal_konselor.dart';
import '0012_mood_tracker.dart';
import '0013_rehat.dart';
import '0014_halaman_forum.dart';
import '0015_riwayat_asesmen.dart';
import '0016_kalender.dart';
import '0017_chatbot.dart';
import '0018_notifikasi.dart';
import '0020_profil.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF1A1A1A);
const Color _navNonaktif = Color(0xFF888888);

class HomeMahasiswaScreen extends StatefulWidget {
  final String nama;

  const HomeMahasiswaScreen({super.key, this.nama = 'Natasha Romanoff'});

  @override
  State<HomeMahasiswaScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeMahasiswaScreen> {
  // Halaman ini adalah Beranda, jadi tab aktif selalu 0.
  // Kalender / Notifikasi / Profile dibuka sebagai halaman baru (push),
  // sehingga nilai ini tidak perlu diubah.
  final int _tabAktif = 0;

  // Daftar menu cepat. Gambar: export dari Figma ke assets/images/
  static final List<_MenuData> _menu = [
    _MenuData(
      'Chat dengan\nKonselor',
      'assets/images/menu_konselor.png',
      halaman: (context) => const JadwalKonselorScreen(),
    ),
    _MenuData(
      'Rehat',
      'assets/images/menu_rehat.png',
      halaman: (context) => const RehatScreen(),
    ),
    _MenuData(
      'Forum Diskusi\nAnonim', 
      'assets/images/menu_forum.png',
      halaman: (context) => const  CommunityForumScreen(),
    ),
    _MenuData(
      'Riwayat\nAsesmen',
      'assets/images/menu_riwayat.png',
      halaman: (context) => const RiwayatAsesmenScreen(),
    ),
  ];

  // Data artikel contoh. Ganti dengan data dari API nanti.
  static const List<_ArtikelData> _artikel = [
    _ArtikelData('Kuliah, Magang, Skripsi: Gimana Cara Menjaga Diri?',
        'assets/images/artikel1.png'),
    _ArtikelData('5 Cara Sederhana Mengelola Stres Harian',
        'assets/images/artikel2.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CURHATIN',
                      style: TextStyle(
                        color: AppColors.maroon,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _salam(),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: _FiturCard(
                            ikon: Icons.assignment_outlined,
                            judul: 'Asesmen\nMandiri',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AsesmenScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FiturCard(
                            ikon: Icons.sentiment_satisfied_alt_outlined,
                            judul: 'Mood Tracker &\nJurnal',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MoodTrackerScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _menu
                          .map((m) => Expanded(child: _MenuItem(data: m)))
                          .toList(),
                    ),
                    const SizedBox(height: 28),
                    const _MoodChartCard(),
                    const SizedBox(height: 32),
                    const Text(
                      'Bacaan Menarik',
                      style: TextStyle(
                        color: _teksGelap,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // Daftar bacaan (bisa digeser ke samping)
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _artikel.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) =>
                      _ArtikelCard(data: _artikel[index]),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
            );
          },
          backgroundColor: AppColors.maroon,
          elevation: 2,
          shape: const CircleBorder(),
          child: Image.asset(
            'assets/images/chatbot.png',
            width: 150,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFEF5EC),
        surfaceTintColor: Colors.transparent,
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
                onTap: () {}, // sudah di Beranda
              ),
            ),
            Expanded(
              child: _NavItem(
                ikon: Icons.calendar_month_outlined,
                label: 'Kalender',
                aktif: _tabAktif == 1,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarMoodTrackerScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 84), // ruang untuk tombol chatbot
            Expanded(
              child: _NavItem(
                ikon: Icons.move_to_inbox_outlined,
                label: 'Notifikasi',
                aktif: _tabAktif == 2,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _NavItem(
                ikon: Icons.person_outline,
                label: 'Profile',
                aktif: _tabAktif == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _salam() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.maroon, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/avatar.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.person,
                color: AppColors.maroon,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Hi, ${widget.nama} !',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _teksGelap,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------- Kartu fitur utama ----------------
class _FiturCard extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final VoidCallback onTap;

  const _FiturCard({
    required this.ikon,
    required this.judul,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.maroon.withAlpha(70)),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withAlpha(110),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Icon(ikon, color: AppColors.maroon, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    judul,
                    maxLines: 2,
                    style: const TextStyle(
                      color: AppColors.maroon,
                      fontSize: 14,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Menu cepat (4 ikon bulat) ----------------
class _MenuData {
  final String judul;
  final String gambar;
  final WidgetBuilder? halaman;

  const _MenuData(this.judul, this.gambar, {this.halaman});
}

class _MenuItem extends StatelessWidget {
  final _MenuData data;

  const _MenuItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final halaman = data.halaman;
        if (halaman == null) {
          // TODO: halaman untuk menu ini belum dibuat
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: halaman),
        );
      },
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.maroon, width: 1),
            ),
            child: ClipOval(
              child: Image.asset(
                data.gambar,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.judul,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _teksGelap,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Grafik mood ----------------
class _MoodChartCard extends StatelessWidget {
  const _MoodChartCard();

  // Nilai 0..1 (1 = Luar Biasa). Data contoh, ganti dengan data dari API.
  static const List<double> _nilai = [0.97, 0.13, 0.25, 0.11, 0.49, 0.74, 0.49];
  static const List<String> _hari = [
    'SENIN',
    'SELASA',
    'RABU',
    'KAMIS',
    'JUMAT',
    'SABTU',
    'MINGGU',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: _latar,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade500, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bulan ini',
                      style: TextStyle(
                        color: _teksGelap,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'September',
                      style: TextStyle(color: _teksGelap, fontSize: 16),
                    ),
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    '1.03%',
                    style: TextStyle(
                      color: _teksGelap,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_circle_up_outlined,
                  color: AppColors.maroon,
                  size: 30,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade300, height: 1),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            width: double.infinity,
            child: CustomPaint(
              painter: _MoodChartPainter(nilai: _nilai),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: _MoodChartPainter.kiri),
            child: Row(
              children: _hari
                  .map(
                    (h) => Expanded(
                      child: Text(
                        h,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _teksGelap,
                          fontSize: 8.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChartPainter extends CustomPainter {
  final List<double> nilai;

  _MoodChartPainter({required this.nilai});

  static const double kiri = 52; // ruang untuk label sumbu Y
  static const List<String> _labelY = [
    'Luar Biasa',
    'Gembira',
    'Biasa Saja',
    'Sedih',
  ];
  // Posisi garis horizontal (fraksi dari atas)
  static const List<double> _levelY = [0.0, 0.225, 0.45, 0.675];

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final areaLebar = size.width - kiri;
    final kolom = areaLebar / nilai.length;

    // Garis horizontal putus-putus + label Y
    final garis = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    for (var i = 0; i < _levelY.length; i++) {
      final y = h * _levelY[i];
      var x = kiri;
      while (x < size.width) {
        final akhir = x + 6 > size.width ? size.width : x + 6;
        canvas.drawLine(Offset(x, y), Offset(akhir, y), garis);
        x += 10;
      }
      final tp = TextPainter(
        text: TextSpan(
          text: _labelY[i],
          style: const TextStyle(color: _teksGelap, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Titik-titik data
    final titik = <Offset>[
      for (var i = 0; i < nilai.length; i++)
        Offset(kiri + kolom * (i + 0.5), h * (1 - nilai[i])),
    ];

    // Garis vertikal tipis di tiap hari
    final garisVertikal = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    for (final t in titik) {
      canvas.drawLine(Offset(t.dx, 0), Offset(t.dx, h), garisVertikal);
    }

    // Area gradasi di bawah garis
    final area = Path()..moveTo(titik.first.dx, h);
    for (final t in titik) {
      area.lineTo(t.dx, t.dy);
    }
    area
      ..lineTo(titik.last.dx, h)
      ..close();
    final cat = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.coral.withAlpha(20),
          AppColors.coral.withAlpha(110),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, h));
    canvas.drawPath(area, cat);

    // Garis dasar
    canvas.drawLine(
      Offset(kiri, h),
      Offset(size.width, h),
      Paint()
        ..color = Colors.grey.shade600
        ..strokeWidth = 1.5,
    );

    // Garis data
    final garisData = Path()..moveTo(titik.first.dx, titik.first.dy);
    for (final t in titik.skip(1)) {
      garisData.lineTo(t.dx, t.dy);
    }
    canvas.drawPath(
      garisData,
      Paint()
        ..color = AppColors.maroon
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MoodChartPainter oldDelegate) =>
      oldDelegate.nilai != nilai;
}

// ---------------- Kartu bacaan ----------------
class _ArtikelData {
  final String judul;
  final String gambar;

  const _ArtikelData(this.judul, this.gambar);
}

class _ArtikelCard extends StatelessWidget {
  final _ArtikelData data;

  const _ArtikelCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              data.gambar,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 170,
                width: double.infinity,
                color: AppColors.cream,
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.maroon,
                  size: 48,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              data.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _teksGelap, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Item navigasi bawah ----------------
// Aktif  : maroon + bold
// Nonaktif: abu-abu + normal
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
    final warna = aktif ? AppColors.maroon : _navNonaktif;

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