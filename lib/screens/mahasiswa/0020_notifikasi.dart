import 'package:flutter/material.dart';
import '../../widgets/circle_back_button.dart';

import '../../theme/app_colors.dart';
import '0012_mood_tracker.dart';
import '0018_kalender.dart';
import '0019_chatbot.dart';
import '../shared/0021_profil.dart';

const Color _headerBg = Color(0xFFFFFBF5);
const Color _bodyBg = Color(0xFFFFFFFF);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF888888);
const Color _divider = Color(0xFFE0E0E0);

// ─────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────
enum NotificationType { keamanan, jadwal, mood }

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String date; // label tampilan: "Hari ini", "08 Agustus"
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        title: title,
        description: description,
        date: date,
        type: type,
        isRead: isRead ?? this.isRead,
      );

  IconData get ikon {
    switch (type) {
      case NotificationType.keamanan:
        return Icons.lock_open_rounded;
      case NotificationType.jadwal:
        return Icons.calendar_month_rounded;
      case NotificationType.mood:
        return Icons.sentiment_satisfied_alt_rounded;
    }
  }
}

enum _Kategori {
  semua('Semua'),
  keamanan('Keamanan'),
  pengingat('Pengingat');

  final String label;
  const _Kategori(this.label);

  bool cocok(NotificationType t) {
    switch (this) {
      case _Kategori.semua:
        return true;
      case _Kategori.keamanan:
        return t == NotificationType.keamanan;
      case _Kategori.pengingat:
        return t == NotificationType.jadwal || t == NotificationType.mood;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Data contoh. TODO: ganti dengan data dari API.
  final List<NotificationItem> _notifikasi = [
    const NotificationItem(
      id: '1',
      title: 'Perbaharui Kata Sandi',
      description:
          'Kata sandimu telah berhasil diperbarui dan akunmu tetap aman.',
      date: 'Hari ini',
      type: NotificationType.keamanan,
    ),
    const NotificationItem(
      id: '2',
      title: 'Sesi Konsultasi Mendatang',
      description: 'Kamu memiliki jadwal konsultasi dengan psikiater.',
      date: '08 Agustus',
      type: NotificationType.jadwal,
    ),
    const NotificationItem(
      id: '3',
      title: 'Mood Tracker Hari Ini',
      description: 'Jangan lupa catat suasana hatimu hari ini.',
      date: '08 November',
      type: NotificationType.mood,
    ),
  ];

  _Kategori _kategori = _Kategori.semua;
  final int _tabAktif = 2; // Notifikasi

  List<NotificationItem> get _tampil =>
      _notifikasi.where((n) => _kategori.cocok(n.type)).toList();

  void _tandaiDibaca(NotificationItem item) {
    final i = _notifikasi.indexWhere((n) => n.id == item.id);
    if (i == -1 || _notifikasi[i].isRead) return;
    setState(() => _notifikasi[i] = _notifikasi[i].copyWith(isRead: true));
  }

  void _onTapNotifikasi(NotificationItem item) {
    _tandaiDibaca(item);

    switch (item.type) {
      case NotificationType.mood:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
        );
        break;
      case NotificationType.jadwal:
        // TODO: arahkan ke halaman Jadwal Konsultasi (0010_jadwal_konselor.dart)
        _infoSementara('Membuka Jadwal Konsultasi...');
        break;
      case NotificationType.keamanan:
        // TODO: arahkan ke halaman Keamanan Akun / Profil
        _infoSementara('Membuka pengaturan keamanan...');
        break;
    }
  }

  void _infoSementara(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _bukaFilter() async {
    final hasil = await showModalBottomSheet<_Kategori>(
      context: context,
      backgroundColor: _headerBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FilterSheet(terpilih: _kategori),
    );
    if (hasil != null) setState(() => _kategori = hasil);
  }

  @override
  Widget build(BuildContext context) {
    final daftar = _tampil;

    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        child: Column(
          children: [
            _barAtas(),
            const Divider(height: 1, thickness: 1, color: _divider),
            Expanded(
              child: daftar.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada notifikasi pada kategori ini.',
                        style: TextStyle(color: _teksAbu),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: daftar.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: _divider,
                        indent: 20,
                        endIndent: 20,
                      ),
                      itemBuilder: (context, index) => _ItemNotifikasi(
                        item: daftar[index],
                        onTap: () => _onTapNotifikasi(daftar[index]),
                      ),
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
        color: _headerBg,
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
            const SizedBox(width: 84), // ruang untuk tombol chatbot
            Expanded(
              child: _NavItem(
                ikon: Icons.move_to_inbox_outlined,
                label: 'Notifikasi',
                aktif: _tabAktif == 2,
                onTap: () {}, // sudah di halaman ini
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
    return Container(
      color: _headerBg,
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          const CircleBackButton(),
          const Expanded(
            child: Text(
              'Notifikasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: _bukaFilter,
            tooltip: 'Filter',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.filter_alt_outlined,
                    color: AppColors.maroon, size: 26),
                if (_kategori != _Kategori.semua)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.maroon,
                        shape: BoxShape.circle,
                        border: Border.all(color: _headerBg, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Item notifikasi
// ─────────────────────────────────────────────────────────────
class _ItemNotifikasi extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const _ItemNotifikasi({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.maroon, width: 1.6),
              ),
              child: Icon(item.ikon, color: AppColors.maroon, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: _teksGelap,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.date,
                        style: const TextStyle(color: _teksAbu, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.description,
                          style: const TextStyle(
                            color: _teksAbu,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (!item.isRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.maroon,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Filter bottom sheet
// ─────────────────────────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final _Kategori terpilih;
  const _FilterSheet({required this.terpilih});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: _divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Filter Notifikasi',
              style: TextStyle(
                color: _teksGelap,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final k in _Kategori.values)
                  ChoiceChip(
                    label: Text(k.label),
                    selected: terpilih == k,
                    showCheckmark: false,
                    onSelected: (_) => Navigator.pop(context, k),
                    labelStyle: TextStyle(
                      color: terpilih == k ? Colors.white : _teksGelap,
                      fontWeight:
                          terpilih == k ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 13,
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.maroon,
                    side: BorderSide(
                      color: terpilih == k ? AppColors.maroon : _divider,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Item navigasi bawah
// ─────────────────────────────────────────────────────────────
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
    final warna = aktif ? AppColors.maroon : _teksAbu;
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
              fontWeight: aktif ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}