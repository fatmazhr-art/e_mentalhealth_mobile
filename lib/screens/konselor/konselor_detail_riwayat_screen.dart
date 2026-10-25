import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konselor_chat_widgets.dart';

// Warna (perkiraan dari gambar, cocokkan hex-nya dengan Figma).
const _titleDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _barBg = Color(0xFFF1D0C8);
const _shadow = Color(0x14000000);

TextStyle _t(double size,
    {FontWeight weight = FontWeight.w400, Color color = _titleDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class KonselorDetailRiwayatScreen extends StatelessWidget {
  final String studentName;
  final String dateLabel; // contoh: '24 Okt 2023'
  final String duration; // contoh: '28 menit'
  final int messageCount;
  final String dayLabel; // contoh: '24 Oktober 2023'

  const KonselorDetailRiwayatScreen({
    super.key,
    required this.studentName,
    required this.dateLabel,
    required this.duration,
    required this.messageCount,
    required this.dayLabel,
  });

  // Data contoh. Nanti diganti data dari API Laravel.
  static const _messages = [
    KonselorChatMessage(
      'Dok, belakangan ini saya sulit tidur dan kepikiran tugas akhir.',
    ),
    KonselorChatMessage(
      'Saya mengerti kekhawatiranmu. Mari kita atur agar istirahatmu cukup.',
      fromKonselor: true,
    ),
    KonselorChatMessage(
      'Iya dok, saya merasa lebih tenang setelah penjelasan tadi.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const KonselorChatHeader(title: 'Detail Riwayat'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: _messages.length + 2,
                itemBuilder: (context, i) {
                  if (i == 0) return _buildInfoCard();
                  if (i == 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: KonselorDayLabel(dayLabel),
                    );
                  }
                  return KonselorMessageItem(
                    message: _messages[i - 2],
                    studentName: studentName,
                  );
                },
              ),
            ),
            _buildReadOnlyBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 14, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(studentName, style: _t(17, weight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            '$dateLabel · $duration · $messageCount pesan',
            style: _t(12.5, color: _textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE3DC))),
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _barBg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          'Riwayat hanya dapat dilihat',
          style: _t(14.5, color: _textMuted),
        ),
      ),
    );
  }
}