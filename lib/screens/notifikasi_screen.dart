import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Warna
const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _badgeBg = Color(0xFFFFD9D9);
const _shadow = Color(0x14000000);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class _NotifItem {
  final String title;
  final String body;
  final String time;
  final bool isNew;
  final IconData icon;

  const _NotifItem({
    required this.title,
    required this.body,
    required this.time,
    this.isNew = false,
    required this.icon,
  });
}

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  // Data contoh. Nanti diganti dari API Laravel.
  final List<_NotifItem> _notifications = [
    const _NotifItem(
      title: 'Pesan baru dari Mahasiswa',
      body: 'Mahasiswa Anonim #2456 mengirim pesan baru untuk Anda.',
      time: '10.22',
      isNew: true,
      icon: Icons.chat_bubble_outline_rounded,
    ),
    const _NotifItem(
      title: 'Pesan baru dari Mahasiswa',
      body: 'Mahasiswa Anonim #104 mengirim pesan baru untuk Anda.',
      time: '10.15',
      isNew: true,
      icon: Icons.chat_bubble_outline_rounded,
    ),
    const _NotifItem(
      title: 'Pengingat Jam Operasional',
      body: 'Jam operasional dimulai pukul 08.00 WIB. Pastikan status Anda aktif.',
      time: '08.00',
      isNew: false,
      icon: Icons.access_time_rounded,
    ),
    const _NotifItem(
      title: 'Sesi konseling selesai',
      body: 'Sesi dengan Mahasiswa Anonim #088 telah selesai dan disimpan ke riwayat.',
      time: 'Kemarin',
      isNew: false,
      icon: Icons.check_circle_outline_rounded,
    ),
    const _NotifItem(
      title: 'Pengingat Jam Operasional',
      body: 'Jam operasional akan berakhir pukul 16.00 WIB.',
      time: 'Kemarin',
      isNew: false,
      icon: Icons.access_time_rounded,
    ),
  ];

  void _tandaiSemuaDibaca() {
    // TODO: tandai semua dibaca via API
    setState(() {
      // Simulasi semua sudah dibaca
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Semua notifikasi telah ditandai dibaca',
            style: _t(13.5, color: Colors.white)),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newNotifs = _notifications.where((n) => n.isNew).toList();
    final oldNotifs = _notifications.where((n) => !n.isNew).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        if (newNotifs.isNotEmpty) ...[
                          _sectionLabel('Baru'),
                          const SizedBox(height: 10),
                          for (final n in newNotifs) ...[
                            _NotifCard(item: n),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 6),
                        ],
                        if (oldNotifs.isNotEmpty) ...[
                          _sectionLabel('Sebelumnya'),
                          const SizedBox(height: 10),
                          for (final n in oldNotifs) ...[
                            _NotifCard(item: n),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0C9C9))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            iconSize: 40,
            color: _primary,
            icon: const Icon(Icons.arrow_circle_left_outlined),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Notifikasi',
                style: _t(18, weight: FontWeight.w700, color: Colors.black)),
          ),
          TextButton(
            onPressed: _tandaiSemuaDibaca,
            child: Text('Tandai semua',
                style: _t(13, weight: FontWeight.w600, color: _primary)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(label,
      style: _t(14, weight: FontWeight.w700, color: _textMuted));

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: _beige,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined,
                color: _primary, size: 44),
          ),
          const SizedBox(height: 18),
          Text('Belum ada notifikasi',
              style: _t(16, weight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text('Notifikasi baru akan muncul di sini.',
              style: _t(13.5, color: _textMuted)),
        ],
      ),
    );
  }
}

// ── Kartu notifikasi ─────────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  final _NotifItem item;

  const _NotifCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: item.isNew ? const Color(0xFFFFF4F4) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isNew
              ? const Color(0xFF7B1E2B).withValues(alpha: 0.25)
              : const Color(0xFFEBD8CB),
        ),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.isNew ? _badgeBg : _beige,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: _primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.title,
                            style: _t(14,
                                weight: item.isNew
                                    ? FontWeight.w700
                                    : FontWeight.w600)),
                      ),
                      if (item.isNew)
                        Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: _primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item.body,
                      style: _t(12.5, color: _textMuted), maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(item.time,
                      style: _t(11.5, color: _textMuted.withValues(alpha: 0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
