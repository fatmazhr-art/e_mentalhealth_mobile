import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konselor_detail_riwayat_screen.dart';

// Warna (perkiraan dari gambar, cocokkan hex-nya dengan Figma).
const _titleDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _primary = Color(0xFF7B1E2B);
const _border = Color(0xFFEBD8CB);
const _badgeBg = Color(0xFFFFD9D9);
const _shadow = Color(0x14000000);

TextStyle _t(double size,
    {FontWeight weight = FontWeight.w400, Color color = _titleDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class _RiwayatItem {
  final String name;
  final String date; // tampil di daftar, contoh: '24 Okt 2023'
  final String time;
  final String duration;
  final String topic;
  final String dayLabel; // pil tanggal di layar detail
  final int messageCount;

  const _RiwayatItem({
    required this.name,
    required this.date,
    required this.time,
    required this.duration,
    required this.topic,
    required this.dayLabel,
    required this.messageCount,
  });
}

/// Isi tab "Riwayat" (tanpa bottom bar; bottom bar ada di KonselorChatScreen).
class KonselorRiwayatTab extends StatefulWidget {
  const KonselorRiwayatTab({super.key});

  @override
  State<KonselorRiwayatTab> createState() => _KonselorRiwayatTabState();
}

class _KonselorRiwayatTabState extends State<KonselorRiwayatTab> {
  String _query = '';

  // Data contoh. Nanti diganti data dari API Laravel.
  static const _all = [
    _RiwayatItem(
      name: 'Mahasiswa Anonim #088',
      date: '24 Okt 2023',
      time: '08.05',
      duration: '28 menit',
      topic: 'Kecemasan menghadapi tugas akhir dan sulit tidur.',
      dayLabel: '24 Oktober 2023',
      messageCount: 34,
    ),
    _RiwayatItem(
      name: 'Mahasiswa Anonim #077',
      date: '12 Mei',
      time: '14.15',
      duration: '30 menit',
      topic: 'Adaptasi sosial di lingkungan kampus.',
      dayLabel: '12 Mei',
      messageCount: 28,
    ),
    _RiwayatItem(
      name: 'Mahasiswa Anonim #064',
      date: '10 Mei',
      time: '11.00',
      duration: '25 menit',
      topic: 'Evaluasi latihan relaksasi dan pola tidur.',
      dayLabel: '10 Mei',
      messageCount: 22,
    ),
  ];

  void _open(_RiwayatItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KonselorDetailRiwayatScreen(
          studentName: item.name,
          dateLabel: item.date,
          duration: item.duration,
          messageCount: item.messageCount,
          dayLabel: item.dayLabel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _all
        .where((e) =>
    e.name.toLowerCase().contains(_query) ||
        e.topic.toLowerCase().contains(_query))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 14),
          child: Text('Riwayat Chat',
              style: _t(17, weight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            style: _t(14.5),
            decoration: InputDecoration(
              hintText: 'Cari riwayat chat mahasiswa...',
              hintStyle: _t(14.5, color: _textMuted.withValues(alpha: 0.7)),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _border, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _primary, width: 1.2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: items.isEmpty
              ? Center(
            child: Text('Tidak ada riwayat yang cocok.',
                style: _t(14, color: _textMuted)),
          )
              : ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (_, i) => _RiwayatCard(
              item: items[i],
              onTap: () => _open(items[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final _RiwayatItem item;
  final VoidCallback onTap;

  const _RiwayatCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 14, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _t(16, weight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Selesai',
                          style: _t(12,
                              weight: FontWeight.w500, color: _primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.date}, ${item.time} · ${item.duration}',
                  style: _t(12.5, color: _textMuted),
                ),
                const SizedBox(height: 10),
                Text(
                  item.topic,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _t(13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}