import 'package:flutter/material.dart';
import '../../widgets/circle_back_button.dart';

import '../../theme/app_colors.dart';
import '0011_chat_room.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF888888);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);
const Color _kuning = Color(0xFFEBF564);
const Color _hijau = Color(0xFF2E7D32);

/// Waktu simulasi untuk pengujian.
/// Ubah nilainya untuk mengetes validasi jadwal:
/// - 28 Okt 2024 07:30 -> Sesi 1 sedang berlangsung (masuk chat)
/// - 28 Okt 2024 09:30 -> Sesi 2 sedang berlangsung (masuk chat)
/// - waktu lain        -> muncul dialog dan kembali ke Beranda
/// Saat rilis, ganti dengan DateTime.now().
final DateTime currentSimulatedTime = DateTime(2024, 10, 28, 7, 30);

// ---------------- Data ----------------
class _Konselor {
  final String nama;
  final String namaChat;
  final String bidang;
  final String avatar;

  const _Konselor({
    required this.nama,
    required this.namaChat,
    required this.bidang,
    required this.avatar,
  });
}

class _Sesi {
  final int jamMulai;
  final int menitMulai;
  final int jamSelesai;
  final int menitSelesai;
  final String nama;
  final String keterangan;
  final bool penuh;

  const _Sesi({
    required this.jamMulai,
    required this.menitMulai,
    required this.jamSelesai,
    required this.menitSelesai,
    required this.nama,
    required this.keterangan,
    this.penuh = false,
  });

  String get label =>
      '${_dua(jamMulai)}.${_dua(menitMulai)} – '
      '${_dua(jamSelesai)}.${_dua(menitSelesai)} WIB';

  DateTime mulai(DateTime hari) =>
      DateTime(hari.year, hari.month, hari.day, jamMulai, menitMulai);

  DateTime selesai(DateTime hari) =>
      DateTime(hari.year, hari.month, hari.day, jamSelesai, menitSelesai);
}

String _dua(int n) => n.toString().padLeft(2, '0');

class JadwalKonselorScreen extends StatefulWidget {
  const JadwalKonselorScreen({super.key});

  @override
  State<JadwalKonselorScreen> createState() => _JadwalKonselorScreenState();
}

class _JadwalKonselorScreenState extends State<JadwalKonselorScreen> {
  static const List<String> _hariSingkat = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];
  static const List<String> _hariPenuh = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];
  static const List<String> _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  // Data contoh. Ganti dengan data dari API nanti.
  static const List<_Konselor> _konselor = [
    _Konselor(
      nama: 'dr. Stephen Strange, Sp.KJ',
      namaChat: 'dr. Stephen Vincent Strange, Sp.KJ',
      bidang: 'Akademik & Burnout',
      avatar: 'assets/images/konselor1.png',
    ),
    _Konselor(
      nama: 'Hanni Widjaya S.Psi',
      namaChat: 'Hanni Widjaya S.Psi',
      bidang: 'Relasi & Quarter-Life',
      avatar: 'assets/images/konselor2.png',
    ),
  ];

  static const List<_Sesi> _sesi = [
    _Sesi(
      jamMulai: 7,
      menitMulai: 0,
      jamSelesai: 8,
      menitSelesai: 30,
      nama: 'Sesi Pagi (Online Chat)',
      keterangan: 'Via Chat Pribadi • 90 Menit',
    ),
    _Sesi(
      jamMulai: 9,
      menitMulai: 0,
      jamSelesai: 10,
      menitSelesai: 30,
      nama: 'Sesi Siang 1 (Online Chat)',
      keterangan: 'Via Chat Pribadi • 90 Menit',
    ),
    _Sesi(
      jamMulai: 13,
      menitMulai: 0,
      jamSelesai: 14,
      menitSelesai: 30,
      nama: 'Sesi Siang 2 (Online Chat)',
      keterangan: 'Via Chat Pribadi • 90 Menit',
      penuh: true,
    ),
  ];

  // Lima hari mulai Senin 28 Oktober (data contoh)
  final List<DateTime> _hari =
      List.generate(5, (i) => DateTime(2024, 10, 28 + i));

  int _hariTerpilih = 0;
  int _konselorTerpilih = 0;
  int? _sesiTerpilih; // null = belum memilih

  DateTime get _tanggal => _hari[_hariTerpilih];

  int get _jumlahTersedia => _sesi.where((s) => !s.penuh).length;

  String get _labelBulan {
    final bulanUnik = <String>[];
    for (final h in _hari) {
      final nama = _bulan[h.month - 1];
      if (!bulanUnik.contains(nama)) bulanUnik.add(nama);
    }
    return bulanUnik.join(' / ');
  }

  /// True jika waktu simulasi berada di dalam rentang sesi yang dipilih.
  bool get isScheduleActive {
    final index = _sesiTerpilih;
    if (index == null) return false;
    final sesi = _sesi[index];
    final sekarang = currentSimulatedTime;
    return !sekarang.isBefore(sesi.mulai(_tanggal)) &&
        sekarang.isBefore(sesi.selesai(_tanggal));
  }

  void _lanjutChat() {
    if (isScheduleActive) {
      final k = _konselor[_konselorTerpilih];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(
            namaKonselor: k.namaChat,
            avatarKonselor: k.avatar,
          ),
        ),
      );
    } else {
      _tampilkanDialogBelumSesuai();
    }
  }

  void _tampilkanDialogBelumSesuai() {
    final sesi = _sesi[_sesiTerpilih!];
    final sudahLewat = currentSimulatedTime.isAfter(sesi.selesai(_tanggal));

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _latar,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(
          Icons.schedule,
          color: AppColors.maroon,
          size: 36,
        ),
        title: const Text(
          'Jadwal Belum Sesuai',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _teksGelap,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          sudahLewat
              ? 'Sesi konseling kamu sudah berakhir. '
                  'Kamu akan diarahkan ke Beranda.'
              : 'Jadwal konseling kamu belum dimulai '
                  '(${sesi.label}). Kamu akan diarahkan ke Beranda.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: _teksAbu, fontSize: 14, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Kembali ke Beranda (route pertama)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Ke Beranda',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _seksiPilihHari(),
                    const SizedBox(height: 28),
                    _seksiKonselor(),
                    const SizedBox(height: 28),
                    _seksiSesi(),
                    const SizedBox(height: 24),
                    const _KartuSafeSpace(),
                  ],
                ),
              ),
            ),
            _tombolBawah(),
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
          const CircleBackButton(),
          const Expanded(
            child: Text(
              'Chat Dengan Konselor',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(
              side: BorderSide(color: _garis, width: 1.5),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // TODO: buka halaman bantuan
              },
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.headset_mic_outlined,
                  color: AppColors.maroon,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Pilih hari ----------------
  Widget _seksiPilihHari() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month_outlined,
                color: AppColors.maroon, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Pilih Hari',
              style: TextStyle(
                color: _teksGelap,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              _labelBulan,
              style: const TextStyle(color: _teksAbu, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (var i = 0; i < _hari.length; i++) ...[
              Expanded(
                child: _ChipHari(
                  hari: _hariSingkat[_hari[i].weekday - 1],
                  tanggal: _hari[i].day,
                  aktif: _hariTerpilih == i,
                  onTap: () => setState(() {
                    _hariTerpilih = i;
                    _sesiTerpilih = null; // reset pilihan sesi
                  }),
                ),
              ),
              if (i != _hari.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }

  // ---------------- Konselor ----------------
  Widget _seksiKonselor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Konselor Bertugas Pekan Ini',
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _kuning,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Siap Mendengar',
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _konselor.length; i++) ...[
                Expanded(
                  child: _KartuKonselor(
                    data: _konselor[i],
                    aktif: _konselorTerpilih == i,
                    onTap: () => setState(() => _konselorTerpilih = i),
                  ),
                ),
                if (i != _konselor.length - 1) const SizedBox(width: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Sesi ----------------
  Widget _seksiSesi() {
    final tgl = _tanggal;
    final infoHari = '${_hariPenuh[tgl.weekday - 1]}, '
        '${tgl.day} ${_bulan[tgl.month - 1]}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, color: AppColors.maroon, size: 8),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Menampilkan sesi untuk $infoHari',
                style: const TextStyle(color: _teksAbu, fontSize: 12.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pilihan Sesi Konseling',
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.maroon.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_jumlahTersedia Tersedia',
                style: const TextStyle(
                  color: AppColors.maroon,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < _sesi.length; i++) ...[
          _KartuSesi(
            data: _sesi[i],
            aktif: _sesiTerpilih == i,
            onTap: _sesi[i].penuh
                ? null
                : () => setState(() => _sesiTerpilih = i),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ---------------- Tombol bawah ----------------
  Widget _tombolBawah() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: const BoxDecoration(
        color: _latar,
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          // null = tombol nonaktif sampai sesi dipilih
          onPressed: _sesiTerpilih == null ? null : _lanjutChat,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: Colors.white,
            disabledBackgroundColor: _garis,
            disabledForegroundColor: _teksAbu,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 20),
              SizedBox(width: 8),
              Text(
                'Lanjut Chat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Chip hari ----------------
class _ChipHari extends StatelessWidget {
  final String hari;
  final int tanggal;
  final bool aktif;
  final VoidCallback onTap;

  const _ChipHari({
    required this.hari,
    required this.tanggal,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: aktif ? AppColors.maroon : _kartu,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: aktif ? AppColors.maroon : _garis),
        ),
        child: Column(
          children: [
            Text(
              hari,
              style: TextStyle(
                color: aktif ? Colors.white : _teksAbu,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$tanggal',
              style: TextStyle(
                color: aktif ? Colors.white : _teksGelap,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Kartu konselor ----------------
class _KartuKonselor extends StatelessWidget {
  final _Konselor data;
  final bool aktif;
  final VoidCallback onTap;

  const _KartuKonselor({
    required this.data,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kartu,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: aktif ? AppColors.maroon : _garis,
            width: aktif ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.maroon, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  data.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    color: AppColors.maroon,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.nama,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _teksGelap,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.bidang,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _teksAbu, fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Kartu sesi ----------------
class _KartuSesi extends StatelessWidget {
  final _Sesi data;
  final bool aktif;
  final VoidCallback? onTap; // null untuk sesi penuh

  const _KartuSesi({
    required this.data,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final penuh = data.penuh;

    return Opacity(
      opacity: penuh ? 0.55 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: aktif ? AppColors.maroon.withAlpha(20) : _kartu,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: aktif ? AppColors.maroon : _garis,
              width: aktif ? 1.8 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: penuh ? _teksAbu : AppColors.maroon,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.label,
                      style: const TextStyle(
                        color: _teksGelap,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (penuh ? _teksAbu : _hijau).withAlpha(28),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      penuh ? '● Penuh' : '● Tersedia',
                      style: TextStyle(
                        color: penuh ? _teksAbu : _hijau,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data.nama,
                style: const TextStyle(
                  color: _teksGelap,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              if (penuh)
                const Row(
                  children: [
                    Icon(Icons.lock_outline, color: _teksAbu, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Kuota telah terisi teman lain',
                      style: TextStyle(color: _teksAbu, fontSize: 12),
                    ),
                  ],
                )
              else
                Text(
                  data.keterangan,
                  style: const TextStyle(color: _teksAbu, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Info safe space ----------------
class _KartuSafeSpace extends StatelessWidget {
  const _KartuSafeSpace();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _garis),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined,
              color: AppColors.maroon, size: 26),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruang Aman untuk Bercerita',
                  style: TextStyle(
                    color: _teksGelap,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Semua percakapan dalam sesi konseling bersifat rahasia dan '
                  'hanya dapat diakses olehmu dan konselor. Ceritakan apa pun '
                  'yang kamu rasakan tanpa takut dihakimi.',
                  style: TextStyle(color: _teksAbu, fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}