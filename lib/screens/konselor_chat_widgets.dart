import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Warna (perkiraan dari gambar, cocokkan hex-nya dengan Figma).
const _primary = Color(0xFF7B1E2B);
const _bubbleMe = Color(0xFF80001E);
const _textDark = Color(0xFF2B2B2B);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _lineBorder = Color(0xFFF0C9C9);
const _bubbleBorder = Color(0xFFE6DCD8);
const _yellow = Color(0xFFEFF55E);

TextStyle _t(double size,
    {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

/// Satu pesan dalam percakapan.
class KonselorChatMessage {
  final String text;
  final bool fromKonselor;

  const KonselorChatMessage(this.text, {this.fromKonselor = false});
}

/// Header: tombol kembali + judul di tengah + garis pink di bawah.
class KonselorChatHeader extends StatelessWidget {
  final String title;

  const KonselorChatHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _lineBorder)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _t(18, weight: FontWeight.w700, color: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                iconSize: 40,
                color: _primary,
                icon: const Icon(Icons.arrow_circle_left_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pil tanggal di tengah ("Hari Ini", "24 Oktober 2023").
class KonselorDayLabel extends StatelessWidget {
  final String text;

  const KonselorDayLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: _beige,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: _t(13, color: _textMuted)),
      ),
    );
  }
}

/// Memilih gelembung yang tepat (mahasiswa / konselor) untuk satu pesan.
class KonselorMessageItem extends StatelessWidget {
  final KonselorChatMessage message;
  final String studentName;

  const KonselorMessageItem({
    super.key,
    required this.message,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: message.fromKonselor
          ? KonselorOwnBubble(text: message.text)
          : KonselorStudentBubble(name: studentName, text: message.text),
    );
  }
}

class KonselorStudentBubble extends StatelessWidget {
  final String name;
  final String text;

  const KonselorStudentBubble({
    super.key,
    required this.name,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.66;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar mahasiswa
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _beige,
            shape: BoxShape.circle,
            border: Border.all(color: _primary, width: 2),
          ),
          child: Text('M',
              style: _t(18, weight: FontWeight.w700, color: _primary)),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: _t(11.5, color: _textMuted)),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _bubbleBorder),
                ),
                child: Text(text, style: _t(15.5, color: _textDark)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class KonselorOwnBubble extends StatelessWidget {
  final String text;

  const KonselorOwnBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.70;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Anda', style: _t(11.5, color: _textMuted)),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: _bubbleMe,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(text, style: _t(15.5, color: Colors.white)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Avatar konselor
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: _yellow,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star_border_rounded,
              color: _primary, size: 28),
        ),
      ],
    );
  }
}