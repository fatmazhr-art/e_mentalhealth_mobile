import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF888888);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);
const Color _kuning = Color(0xFFEBF564);

class _Pesan {
  final String teks;
  final bool dariUser;

  const _Pesan(this.teks, {required this.dariUser});
}

class ChatRoomScreen extends StatefulWidget {
  final String namaKonselor;
  final String avatarKonselor;

  const ChatRoomScreen({
    super.key,
    this.namaKonselor = 'dr. Stephen Vincent Strange, Sp.KJ',
    this.avatarKonselor = 'assets/images/konselor1.png',
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // Pesan contoh. Ganti dengan data realtime dari backend nanti.
  final List<_Pesan> _pesan = [
    const _Pesan(
      'Halo, Dok. Saya akhir-akhir ini merasa cukup kewalahan dengan '
      'kuliah dan tugas akhir.',
      dariUser: true,
    ),
    const _Pesan(
      'Halo. Terima kasih sudah mau bercerita. Boleh ceritakan lebih '
      'lanjut apa yang paling membuatmu merasa kewalahan?',
      dariUser: false,
    ),
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _kirim() {
    final teks = _inputCtrl.text.trim();
    if (teks.isEmpty) return;

    setState(() => _pesan.add(_Pesan(teks, dariUser: true)));
    _inputCtrl.clear();
    // TODO: kirim pesan ke backend / konselor

    // Gulir ke pesan terbaru setelah frame selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
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
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                // +1 untuk badge "Hari Ini" di paling atas
                itemCount: _pesan.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return const _BadgeTanggal(label: 'Hari Ini');
                  final p = _pesan[index - 1];
                  return p.dariUser
                      ? _BubbleUser(teks: p.teks)
                      : _BubbleKonselor(
                          teks: p.teks,
                          avatar: widget.avatarKonselor,
                        );
                },
              ),
            ),
            _inputBar(),
          ],
        ),
      ),
    );
  }

  Widget _barAtas() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: const BoxDecoration(
        color: _latar,
        border: Border(bottom: BorderSide(color: _garis)),
      ),
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
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              widget.namaKonselor,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _teksGelap,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      decoration: const BoxDecoration(
        color: _latar,
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _kirim(),
              style: const TextStyle(color: _teksGelap, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ketik disini..',
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
              onTap: _kirim,
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

// ---------------- Badge tanggal ----------------
class _BadgeTanggal extends StatelessWidget {
  final String label;

  const _BadgeTanggal({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _kartu,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _garis),
        ),
        child: Text(
          label,
          style: const TextStyle(color: _teksAbu, fontSize: 12),
        ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Tag bintang di luar bubble
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 8, bottom: 4),
            decoration: const BoxDecoration(
              color: _kuning,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_rounded, color: _teksGelap, size: 16),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.68,
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
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Bubble konselor (kiri) ----------------
class _BubbleKonselor extends StatelessWidget {
  final String teks;
  final String avatar;

  const _BubbleKonselor({required this.teks, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.maroon, width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person,
                  color: AppColors.maroon,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.68,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _garis),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                teks,
                style: const TextStyle(
                  color: _teksGelap,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}