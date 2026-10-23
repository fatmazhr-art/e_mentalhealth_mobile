import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '0012_mood_tracker.dart';
import '0017_chatbot.dart';
import '0018_notifikasi.dart';
import 'mood_detail_bottom_sheet.dart'; 
import '0020_profil.dart';// sesuaikan dengan nama file bottom sheet-mu

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _navNonaktif = Color(0xFF888888);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

class CalendarMoodTrackerScreen extends StatefulWidget {
  const CalendarMoodTrackerScreen({super.key});

  @override
  State<CalendarMoodTrackerScreen> createState() =>
      _CalendarMoodTrackerScreenState();
}

class _CalendarMoodTrackerScreenState extends State<CalendarMoodTrackerScreen> {
  static const List<String> _namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  static const List<String> _namaHari = [
    'Su', 'Mo', 'Tu', 'Wed', 'Thu', 'Fri', 'Sat',
  ];

  // Bulan yang ditampilkan (data contoh)
  static final List<DateTime> _bulanTampil = [
    DateTime(2026, 3),
    DateTime(2026, 4),
    DateTime(2026, 5),
  ];

  // Data contoh: tanggal yang sudah mengisi mood tracker.
  // Ganti dengan data dari API nanti.
  final List<DateTime> filledDates = [
    DateTime(2026, 3, 2),
    DateTime(2026, 3, 3),
    DateTime(2026, 3, 5),
    DateTime(2026, 3, 9),
    DateTime(2026, 3, 10),
    DateTime(2026, 3, 12),
    DateTime(2026, 3, 16),
    DateTime(2026, 3, 20),
    DateTime(2026, 3, 24),
    DateTime(2026, 4, 1),
    DateTime(2026, 4, 2),
    DateTime(2026, 4, 4),
    DateTime(2026, 4, 7),
    DateTime(2026, 4, 8),
    DateTime(2026, 4, 11),
    DateTime(2026, 4, 15),
    DateTime(2026, 4, 18),
    DateTime(2026, 4, 22),
    DateTime(2026, 5, 3),
    DateTime(2026, 5, 6),
    DateTime(2026, 5, 9),
  ];

  // Halaman ini adalah tab Kalender, jadi tab aktif selalu 1.
  final int _tabAktif = 1;

  bool _sudahDiisi(DateTime tanggal) {
    return filledDates.any(
      (d) =>
          d.year == tanggal.year &&
          d.month == tanggal.month &&
          d.day == tanggal.day,
    );
  }

  void _onTapTanggal(DateTime tanggal) {
    if (_sudahDiisi(tanggal)) {
      _tampilkanDetail(tanggal);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
      );
    }
  }

  /// Mengambil data mood + jurnal untuk satu tanggal.
  /// Return null jika tanggal itu belum diisi (tampil empty state).
  /// TODO: ganti isi method ini dengan pemanggilan API / database.
  MoodJournalData? _ambilData(DateTime tanggal) {
    if (!_sudahDiisi(tanggal)) return null;

    return MoodJournalData(
      mood: Mood.luarBiasa,
      moodRecordedAt:
          DateTime(tanggal.year, tanggal.month, tanggal.day, 9, 7),
      moodNote: 'Habis keliling perpustakaan dan dengerin musik favorit.',
      factors: const ['Istirahat cukup', 'Keluarga'],
      journalTitle: 'Refleksi Tugas Akhir',
      journalRecordedAt:
          DateTime(tanggal.year, tanggal.month, tanggal.day, 9, 7),
      journalContent:
          'Awalnya cemas banget sebelum maju presentasi, tapi setelah '
          'latihan pernapasan yang direkomendasikan konselor, '
          'deg-degannya berkurang drastis...',
    );
  }

  void _tampilkanDetail(DateTime tanggal) {
    showMoodDetailBottomSheet(
      context,
      selectedDate: tanggal,
      data: _ambilData(tanggal),
      dataLoader: _ambilData, // mengaktifkan tombol < dan >
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Column(
          children: [
            _barAtas(),
            Expanded(
              child: ListView.builder(
                // padding bawah besar agar bulan terakhir tidak tertutup FAB / bottom bar
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 110),
                itemCount: _bulanTampil.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _BulanKalender(
                      bulan: _bulanTampil[index],
                      namaBulan: _namaBulan,
                      namaHari: _namaHari,
                      sudahDiisi: _sudahDiisi,
                      onTapTanggal: _onTapTanggal,
                    ),
                  );
                },
              ),
            ),
          ],
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
              size: 150,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: _kartu,
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
                onTap: () => Navigator.maybePop(context), // kembali ke Beranda
              ),
            ),
            Expanded(
              child: _NavItem(
                ikon: Icons.calendar_month_outlined,
                label: 'Kalender',
                aktif: _tabAktif == 1,
                onTap: () {}, // sudah di Kalender
              ),
            ),
            const SizedBox(width: 84), // ruang untuk tombol chatbot
            Expanded(
              child: _NavItem(
                ikon: Icons.move_to_inbox_outlined,
                label: 'Notifikasi',
                aktif: _tabAktif == 2,
                // pushReplacement agar tumpukan halaman tidak menumpuk
                // (Beranda > Kalender  ->  Beranda > Notifikasi)
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
                ikon: Icons.person_outline,
                label: 'Profile',
                aktif: _tabAktif == 3,
                onTap: () {
                  Navigator.pushReplacement(
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

  // ---------------- Top bar ----------------
  Widget _barAtas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          Material(
            color: AppColors.maroon,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Kalender',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // Penyeimbang agar judul tepat di tengah
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ---------------- Satu bulan kalender ----------------
class _BulanKalender extends StatelessWidget {
  final DateTime bulan;
  final List<String> namaBulan;
  final List<String> namaHari;
  final bool Function(DateTime) sudahDiisi;
  final ValueChanged<DateTime> onTapTanggal;

  const _BulanKalender({
    required this.bulan,
    required this.namaBulan,
    required this.namaHari,
    required this.sudahDiisi,
    required this.onTapTanggal,
  });

  @override
  Widget build(BuildContext context) {
    // Minggu = kolom pertama. weekday: Senin=1 ... Minggu=7
    final offsetAwal = DateTime(bulan.year, bulan.month, 1).weekday % 7;
    final jumlahHari = DateTime(bulan.year, bulan.month + 1, 0).day;

    return Column(
      children: [
        // Banner bulan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.maroon,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_outlined,
                  color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                '${namaBulan[bulan.month - 1]} ${bulan.year}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Kartu kalender
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
          decoration: BoxDecoration(
            color: _kartu,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _garis),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  for (final h in namaHari)
                    Expanded(
                      child: Text(
                        h,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _teksGelap,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offsetAwal + jumlahHari,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index < offsetAwal) return const SizedBox.shrink();

                  final tanggal =
                      DateTime(bulan.year, bulan.month, index - offsetAwal + 1);
                  return _SelTanggal(
                    tanggal: tanggal.day,
                    terisi: sudahDiisi(tanggal),
                    onTap: () => onTapTanggal(tanggal),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------- Sel tanggal ----------------
class _SelTanggal extends StatelessWidget {
  final int tanggal;
  final bool terisi;
  final VoidCallback onTap;

  const _SelTanggal({
    required this.tanggal,
    required this.terisi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // terisi = lingkaran maroon solid, belum = tanpa lingkaran
          color: terisi ? AppColors.maroon : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$tanggal',
          style: TextStyle(
            color: terisi ? Colors.white : _teksGelap,
            fontSize: 13,
            fontWeight: terisi ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ---------------- Item navigasi bawah ----------------
// Aktif   : maroon + bold
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