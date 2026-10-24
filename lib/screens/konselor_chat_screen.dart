import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'konselor_chat_room_screen.dart';
import 'konselor_riwayat_tab.dart';
import 'konselor_profil_tab.dart';
import 'notifikasi_screen.dart';

const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _reminderBg = Color(0xFFF1E6DC);
const _badgeBg = Color(0xFFFFD9D9);
const _shadow = Color(0x14000000);

TextStyle _t(double size,
    {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class _ChatItem {
  final String name;
  final String time;
  final String preview;
  final int unread;

  const _ChatItem({
    required this.name,
    required this.time,
    required this.preview,
    required this.unread,
  });
}

class KonselorChatScreen extends StatefulWidget {
  const KonselorChatScreen({super.key});

  @override
  State<KonselorChatScreen> createState() => _KonselorChatScreenState();
}

class _KonselorChatScreenState extends State<KonselorChatScreen> {
  int _tab = 0;

  // Data contoh. Nanti diganti data dari API Laravel.
  static const _konselorName = 'dr. Sarah V., Sp.KJ';
  bool _isActive = true; // status bisa di-toggle

  static const _chats = [
    _ChatItem(
      name: 'Mahasiswa Anonim #2456',
      time: '10.22',
      preview: 'Halo dok, saya butuh teman bicara sebentar...',
      unread: 1,
    ),
    _ChatItem(
      name: 'Mahasiswa Anonim #104',
      time: '10.15',
      preview: 'Iya dok, nafas saya terasa agak sesak saat...',
      unread: 2,
    ),
    _ChatItem(
      name: 'Mahasiswa Anonim #098',
      time: '09.30',
      preview: 'Baik dok, teknik relaksasi tadi sudah saya coba...',
      unread: 1,
    ),
  ];

  void _openChat(_ChatItem chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KonselorChatRoomScreen(studentName: chat.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            _buildChatTab(),
            const KonselorRiwayatTab(),
            const KonselorProfilTab(),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }

  Widget _buildChatTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // Header
        SizedBox(
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text('Chat Mahasiswa',
                  style: _t(18, weight: FontWeight.w600)),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    // TODO: halaman notifikasi
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: _beige,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_none_rounded,
                            color: _primary, size: 26),
                        Positioned(
                          top: 14,
                          right: 15,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: _primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Kartu sapaan
        _Card(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, $_konselorName',
                        style: _t(16, weight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Jam operasional 08.00 – 16.00 WIB',
                        style: _t(12.5, color: _textMuted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _isActive = !_isActive),
                child: _Badge(
                  text: _isActive ? 'Aktif' : 'Nonaktif',
                  bold: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Pengingat
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _reminderBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text.rich(
            TextSpan(
              style: _t(12.5),
              children: [
                TextSpan(
                  text: 'Pengingat: ',
                  style: _t(12.5, weight: FontWeight.w700),
                ),
                const TextSpan(
                  text: 'jam operasional dimulai pukul 08.00 WIB. '
                      'Pastikan status Anda aktif.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Judul bagian
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Menunggu Balasan',
                style: _t(17, weight: FontWeight.w600)),
            Text('${_chats.length} chat baru',
                style: _t(12.5, color: _textMuted)),
          ],
        ),
        const SizedBox(height: 12),

        // Daftar chat
        for (final chat in _chats) ...[
          _ChatTile(chat: chat, onReply: () => _openChat(chat)),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _Card({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 14, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool bold;

  const _Badge({required this.text, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: _t(12,
            weight: bold ? FontWeight.w600 : FontWeight.w500,
            color: _primary),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final _ChatItem chat;
  final VoidCallback onReply;

  const _ChatTile({required this.chat, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(chat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _t(16, weight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Text(chat.time, style: _t(12.5, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            chat.preview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _t(12.5, color: _textMuted),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Badge(text: '${chat.unread} pesan baru'),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: onReply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    shape: const StadiumBorder(),
                  ),
                  child: Text('Balas',
                      style: _t(14,
                          weight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _BottomBar({required this.index, required this.onChanged});

  static const _items = [
    (label: 'Chat',    icon: Icons.chat_bubble_outline_rounded,    iconActive: Icons.chat_bubble_rounded),
    (label: 'Riwayat', icon: Icons.history_rounded,                iconActive: Icons.history_rounded),
    (label: 'Profil',  icon: Icons.person_outline_rounded,         iconActive: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE3DC))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onChanged(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          i == index
                              ? _items[i].iconActive
                              : _items[i].icon,
                          color: i == index ? _primary : _textMuted,
                          size: 24,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _items[i].label,
                          style: _t(
                            12,
                            weight: i == index
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: i == index ? _primary : _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
