import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konselor_chat_widgets.dart';

// Warna yang dipakai hanya untuk input bar
const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF2B2B2B);
const _textMuted = Color(0xFF7A5A5F);
const _inputBg = Color(0xFFF1D0C8);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class KonselorChatRoomScreen extends StatefulWidget {
  final String studentName;

  const KonselorChatRoomScreen({super.key, required this.studentName});

  @override
  State<KonselorChatRoomScreen> createState() =>
      _KonselorChatRoomScreenState();
}

class _KonselorChatRoomScreenState extends State<KonselorChatRoomScreen> {
  final _inputC = TextEditingController();
  final _scrollC = ScrollController();

  // Data contoh. Nanti diganti data dari API Laravel.
  final List<KonselorChatMessage> _messages = [
    const KonselorChatMessage(
      'Halo, Dok. Saya akhir-akhir ini merasa cukup kewalahan dengan '
      'kuliah dan tugas akhir.',
    ),
    const KonselorChatMessage(
      'Halo. Terima kasih sudah mau bercerita. Boleh ceritakan lebih '
      'lanjut, apa yang membuat kamu merasa kewalahan akhir-akhir ini?',
      fromKonselor: true,
    ),
    const KonselorChatMessage(
      'Saya sedang magang sambil mengerjakan skripsi, Dok. Rasanya hampir '
      'setiap hari kepikiran tugas sampai sulit untuk benar-benar beristirahat.',
    ),
    const KonselorChatMessage(
      'Saya mengerti. Menjalani magang dan skripsi bersamaan memang bisa '
      'terasa berat. Sejak kapan kamu mulai merasa kondisi ini mengganggu '
      'keseharianmu?',
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

    setState(() => _messages.add(KonselorChatMessage(text, fromKonselor: true)));
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
            // Header — pakai shared widget
            KonselorChatHeader(title: widget.studentName),
            Expanded(
              child: ListView.builder(
                controller: _scrollC,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: _messages.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return const KonselorDayLabel('Hari Ini');
                  final m = _messages[i - 1];
                  return KonselorMessageItem(
                    message: m,
                    studentName: widget.studentName,
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