import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Warna (perkiraan dari gambar, cocokkan hex-nya dengan Figma).
const _primary = Color(0xFF7B1E2B);
const _bubbleMe = Color(0xFF80001E);
const _textDark = Color(0xFF2B2B2B);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _inputBg = Color(0xFFF1D0C8);
const _lineBorder = Color(0xFFF0C9C9);
const _bubbleBorder = Color(0xFFE6DCD8);
const _yellow = Color(0xFFEFF55E);

TextStyle _t(double size,
    {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class _Message {
  final String text;
  final bool fromKonselor;

  const _Message(this.text, {this.fromKonselor = false});
}

class KonselorChatRoomScreen extends StatefulWidget {
  final String studentName;

  const KonselorChatRoomScreen({super.key, required this.studentName});

  @override
  State<KonselorChatRoomScreen> createState() => _KonselorChatRoomScreenState();
}

class _KonselorChatRoomScreenState extends State<KonselorChatRoomScreen> {
  final _inputC = TextEditingController();
  final _scrollC = ScrollController();

  // Data contoh. Nanti diganti data dari API Laravel.
  final List<_Message> _messages = [
    const _Message(
      'Halo, Dok. Saya akhir-akhir ini merasa cukup kewalahan dengan '
          'kuliah dan tugas akhir.',
    ),
    const _Message(
      'Halo. Terima kasih sudah mau bercerita. Boleh ceritakan lebih '
          'lanjut, apa yang membuat kamu merasa kewalahan akhir-akhir ini?',
      fromKonselor: true,
    ),
    const _Message(
      'Saya sedang magang sambil mengerjakan skripsi, Dok. Rasanya hampir '
          'setiap hari kepikiran tugas sampai sulit untuk benar-benar '
          'beristirahat.',
    ),
    const _Message(
      'Saya mengerti. Menjalani magang dan skripsi bersamaan memang bisa '
          'terasa berat. Sejak kapan kamu mulai merasa kondisi ini '
          'mengganggu keseharianmu?',
      fromKonselor: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollToBottom(animate: false);
  }

  @override
  void dispose() {
    _inputC.dispose();
    _scrollC.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollC.hasClients) return;
      final pos = _scrollC.position.maxScrollExtent;
      if (animate) {
        _scrollC.animateTo(
          pos,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } else {
        _scrollC.jumpTo(pos);
      }
    });
  }

  void _send() {
    final text = _inputC.text.trim();
    if (text.isEmpty) return;

    setState(() => _messages.add(_Message(text, fromKonselor: true)));
    _inputC.clear();
    _scrollToBottom();

    // TODO: kirim pesan ke API Laravel.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                controller: _scrollC,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: _messages.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return const _DayLabel('Hari Ini');
                  final m = _messages[i - 1];
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: m.fromKonselor
                        ? _KonselorBubble(text: m.text)
                        : _StudentBubble(
                      name: widget.studentName,
                      text: m.text,
                    ),
                  );
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              widget.studentName,
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

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE3DC))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputC,
              minLines: 1,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: _t(15),
              decoration: InputDecoration(
                hintText: 'Ketik disini..',
                hintStyle: _t(15, color: _textMuted.withValues(alpha: 0.7)),
                filled: true,
                fillColor: _inputBg,
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _send,
            iconSize: 30,
            color: _primary,
            icon: const Icon(Icons.send_outlined),
          ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;

  const _DayLabel(this.text);

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

class _StudentBubble extends StatelessWidget {
  final String name;
  final String text;

  const _StudentBubble({required this.name, required this.text});

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

class _KonselorBubble extends StatelessWidget {
  final String text;

  const _KonselorBubble({required this.text});

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