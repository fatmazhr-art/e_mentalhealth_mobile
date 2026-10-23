import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF666666);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

// ---------------- Model pesan ----------------
class ChatMessage {
  final String text;
  final bool fromUser;

  /// Umpan balik untuk pesan bot: true = suka, false = tidak suka, null = belum
  bool? liked;

  ChatMessage({required this.text, required this.fromUser});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  static const List<String> _saran = [
    'Aku sedang merasa cukup tertekan',
    'Aku ingin bercerita tentang apa yang aku rasa...',
  ];

  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  bool _botMengetik = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hai! 👋 Senang bertemu denganmu.\n'
          'Ada yang ingin kamu ceritakan atau rasakan hari ini?',
      fromUser: false,
    ),
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _gulirKeBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      // List dibalik (reverse: true), jadi pesan terbaru ada di offset 0
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  /// Menambah pesan user, lalu bot membalas (simulasi respons AI).
  void sendMessage(String teks) {
    final isi = teks.trim();
    if (isi.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: isi, fromUser: true));
      _botMengetik = true;
    });
    _inputCtrl.clear();
    _gulirKeBawah();

    // TODO: ganti simulasi ini dengan panggilan API chatbot
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      setState(() {
        _botMengetik = false;
        _messages.add(
          ChatMessage(text: _balasanBot(isi), fromUser: false),
        );
      });
      _gulirKeBawah();
    });
  }

  String _balasanBot(String pesanUser) {
    final p = pesanUser.toLowerCase();
    if (p.contains('tertekan')) {
      return 'Terima kasih sudah jujur soal perasaanmu. Tertekan itu '
          'melelahkan, dan wajar kalau kamu merasakannya. '
          'Apa yang paling membebani pikiranmu belakangan ini?';
    }
    if (p.contains('cerita')) {
      return 'Tentu, aku di sini untuk mendengarkan. '
          'Ceritakan pelan-pelan saja, tidak perlu buru-buru. 😊';
    }
    return 'Aku mengerti. Terima kasih sudah berbagi. '
        'Boleh ceritakan lebih lanjut supaya aku bisa memahami '
        'perasaanmu dengan lebih baik?';
  }

  void _beriUmpanBalik(ChatMessage pesan, bool suka) {
    setState(() => pesan.liked = pesan.liked == suka ? null : suka);
    // TODO: kirim umpan balik ke backend
  }

  @override
  Widget build(BuildContext context) {
    final jumlahItem = _messages.length + (_botMengetik ? 1 : 0);

    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Column(
          children: [
            _barAtas(),
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                // reverse: true -> percakapan mulai dari bawah, dekat input
                reverse: true,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                itemCount: jumlahItem,
                itemBuilder: (context, index) {
                  // Index 0 = paling bawah (indikator mengetik atau pesan terbaru)
                  if (_botMengetik && index == 0) {
                    return const _BubbleMengetik();
                  }
                  final offset = _botMengetik ? index - 1 : index;
                  final pesan = _messages[_messages.length - 1 - offset];
                  return pesan.fromUser
                      ? _BubbleUser(teks: pesan.text)
                      : _BubbleBot(
                          pesan: pesan,
                          onSuka: () => _beriUmpanBalik(pesan, true),
                          onTidakSuka: () => _beriUmpanBalik(pesan, false),
                        );
                },
              ),
            ),
            _barSaran(),
            _barInput(),
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
                child: Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Chatbot',
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

  // ---------------- Saran cepat ----------------
  Widget _barSaran() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _saran.length,
        itemBuilder: (context, index) {
          final teks = _saran[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => sendMessage(teks), // langsung terkirim
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.maroon, width: 1.3),
                ),
                child: Text(
                  teks,
                  style: const TextStyle(
                    color: AppColors.maroon,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- Input ----------------
  Widget _barInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      color: _latar,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: sendMessage,
              style: const TextStyle(color: _teksGelap, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tanyakan apa saja',
                hintStyle: const TextStyle(color: _teksAbu),
                filled: true,
                fillColor: _kartu,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: _garis),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      const BorderSide(color: AppColors.maroon, width: 1.4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: AppColors.maroon,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => sendMessage(_inputCtrl.text),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Avatar bot ----------------
class _AvatarBot extends StatelessWidget {
  const _AvatarBot();

  @override
  Widget build(BuildContext context) {
    // Lingkaran maroon solid, tanpa border luar
    return CircleAvatar(
      radius: 19,
      backgroundColor: AppColors.maroon,
      child: Image.asset(
        'assets/images/chatbot.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.support_agent,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

// ---------------- Bubble bot (kiri) ----------------
class _BubbleBot extends StatelessWidget {
  final ChatMessage pesan;
  final VoidCallback onSuka;
  final VoidCallback onTidakSuka;

  const _BubbleBot({
    required this.pesan,
    required this.onSuka,
    required this.onTidakSuka,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AvatarBot(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _garis),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    pesan.text,
                    style: const TextStyle(
                      color: _teksGelap,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TombolUmpanBalik(
                      ikon: pesan.liked == true
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      onTap: onSuka,
                    ),
                    _TombolUmpanBalik(
                      ikon: pesan.liked == false
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined,
                      onTap: onTidakSuka,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TombolUmpanBalik extends StatelessWidget {
  final IconData ikon;
  final VoidCallback onTap;

  const _TombolUmpanBalik({required this.ikon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(ikon, color: AppColors.maroon, size: 18),
      ),
    );
  }
}

// ---------------- Bubble user (kanan) ----------------
class _BubbleUser extends StatelessWidget {
  final String teks;

  const _BubbleUser({required this.teks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.maroon,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Text(
            teks,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Indikator bot sedang mengetik ----------------
class _BubbleMengetik extends StatelessWidget {
  const _BubbleMengetik();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _AvatarBot(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _garis),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              '• • •',
              style: TextStyle(
                color: AppColors.maroon,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}