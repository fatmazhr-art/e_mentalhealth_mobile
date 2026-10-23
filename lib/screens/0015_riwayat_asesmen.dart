import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
// Sesuaikan dengan file yang berisi HasilAsesmenScreen di proyekmu.
import '0008_hasil_asesmen.dart';

const Color _headerBg = Color(0xFFFFFBF5);
const Color _bodyBg = Color(0xFFFFFFFF);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF888888);
const Color _divider = Color(0xFFE0E0E0);

// ─────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────
class AssessmentHistory {
  final String id;
  final String title; // "Asesmen Online DASS-21"
  final String time; // "08.11 AM"
  final String date; // label tampilan: "Kemarin", "08 Agustus"
  final DateTime createdAt; // dipakai untuk penyaringan

  const AssessmentHistory({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.createdAt,
  });
}

enum _Periode { semua, tujuhHari, tigaPuluhHari, rentang }

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────
class RiwayatAsesmenScreen extends StatefulWidget {
  const RiwayatAsesmenScreen({super.key});

  @override
  State<RiwayatAsesmenScreen> createState() => _RiwayatAsesmenScreenState();
}

class _RiwayatAsesmenScreenState extends State<RiwayatAsesmenScreen> {
  // Data contoh. TODO: ganti dengan data dari API / database.
  late final List<AssessmentHistory> _semuaRiwayat = _dataContoh();

  _Periode _periode = _Periode.semua;
  DateTimeRange? _rentang;

  static List<AssessmentHistory> _dataContoh() {
    final now = DateTime.now();
    return [
      AssessmentHistory(
        id: '1',
        title: 'Asesmen Online DASS-21',
        time: '08.11 AM',
        date: 'Kemarin',
        createdAt: DateTime(now.year, now.month, now.day - 1, 8, 11),
      ),
      AssessmentHistory(
        id: '2',
        title: 'Asesmen Online DASS-21',
        time: '07.06 AM',
        date: '08 Agustus',
        createdAt: DateTime(now.year, 8, 8, 7, 6),
      ),
      AssessmentHistory(
        id: '3',
        title: 'Asesmen Online DASS-21',
        time: '02.15 AM',
        date: '14 Februari',
        createdAt: DateTime(now.year, 2, 14, 2, 15),
      ),
    ];
  }

  bool get _filterAktif => _periode != _Periode.semua;

  List<AssessmentHistory> get _riwayatTampil {
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);

    bool lolos(AssessmentHistory h) {
      final d = DateTime(h.createdAt.year, h.createdAt.month, h.createdAt.day);
      switch (_periode) {
        case _Periode.semua:
          return true;
        case _Periode.tujuhHari:
          return !d.isBefore(hariIni.subtract(const Duration(days: 7)));
        case _Periode.tigaPuluhHari:
          return !d.isBefore(hariIni.subtract(const Duration(days: 30)));
        case _Periode.rentang:
          final r = _rentang;
          if (r == null) return true;
          return !d.isBefore(r.start) && !d.isAfter(r.end);
      }
    }

    final hasil = _semuaRiwayat.where(lolos).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return hasil;
  }

  void _bukaDetail(AssessmentHistory item) {
    // TODO: kirim item.id ke HasilAsesmenScreen jika konstruktornya menerima parameter.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HasilAsesmenScreen()),
    );
  }

  Future<void> _bukaFilter() async {
    final hasil = await showModalBottomSheet<_FilterHasil>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _headerBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FilterSheet(periode: _periode, rentang: _rentang),
    );

    if (hasil == null) return;
    setState(() {
      _periode = hasil.periode;
      _rentang = hasil.rentang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final daftar = _riwayatTampil;

    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        child: Column(
          children: [
            _barAtas(),
            const Divider(height: 1, thickness: 1, color: _divider),
            Expanded(
              child: daftar.isEmpty
                  ? const _KosongState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: daftar.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: _divider,
                        indent: 20,
                        endIndent: 20,
                      ),
                      itemBuilder: (context, index) => _ItemRiwayat(
                        item: daftar[index],
                        onTap: () => _bukaDetail(daftar[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Top bar ----------------
  Widget _barAtas() {
    return Container(
      color: _headerBg,
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
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
          const Expanded(
            child: Text(
              'Riwayat Asesmen',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: _bukaFilter,
            tooltip: 'Filter',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.filter_alt_outlined,
                    color: AppColors.maroon, size: 26),
                if (_filterAktif)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.maroon,
                        shape: BoxShape.circle,
                        border: Border.all(color: _headerBg, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Item riwayat
// ─────────────────────────────────────────────────────────────
class _ItemRiwayat extends StatelessWidget {
  final AssessmentHistory item;
  final VoidCallback onTap;

  const _ItemRiwayat({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.maroon, width: 1.6),
        ),
        child: const Icon(Icons.history, color: AppColors.maroon, size: 24),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          color: _teksGelap,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          item.time,
          style: const TextStyle(color: _teksAbu, fontSize: 12.5),
        ),
      ),
      trailing: Text(
        item.date,
        style: const TextStyle(color: _teksAbu, fontSize: 12.5),
      ),
    );
  }
}

class _KosongState extends StatelessWidget {
  const _KosongState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Tidak ada riwayat asesmen\nyang sesuai dengan filter.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _teksAbu, height: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom sheet filter
// ─────────────────────────────────────────────────────────────
class _FilterHasil {
  final _Periode periode;
  final DateTimeRange? rentang;
  const _FilterHasil(this.periode, this.rentang);
}

class _FilterSheet extends StatefulWidget {
  final _Periode periode;
  final DateTimeRange? rentang;

  const _FilterSheet({required this.periode, required this.rentang});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _Periode _periode = widget.periode;
  late DateTimeRange? _rentang = widget.rentang;

  static const List<String> _bulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  String _fmt(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

  Future<void> _pilihRentang() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: _rentang,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.maroon,
                onPrimary: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (r != null) {
      setState(() {
        _rentang = r;
        _periode = _Periode.rentang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final opsi = <_Periode, String>{
      _Periode.semua: 'Semua',
      _Periode.tujuhHari: '7 hari terakhir',
      _Periode.tigaPuluhHari: '30 hari terakhir',
      _Periode.rentang: (_rentang != null && _periode == _Periode.rentang)
          ? '${_fmt(_rentang!.start)} – ${_fmt(_rentang!.end)}'
          : 'Pilih tanggal...',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: _divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Filter Riwayat',
              style: TextStyle(
                color: _teksGelap,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in opsi.entries)
                  ChoiceChip(
                    label: Text(e.value),
                    selected: _periode == e.key,
                    showCheckmark: false,
                    onSelected: (_) {
                      if (e.key == _Periode.rentang) {
                        _pilihRentang();
                      } else {
                        setState(() => _periode = e.key);
                      }
                    },
                    labelStyle: TextStyle(
                      color:
                          _periode == e.key ? Colors.white : _teksGelap,
                      fontWeight: _periode == e.key
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 13,
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.maroon,
                    side: BorderSide(
                      color: _periode == e.key
                          ? AppColors.maroon
                          : _divider,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      const _FilterHasil(_Periode.semua, null),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.maroon,
                      side: const BorderSide(color: AppColors.maroon),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      _FilterHasil(_periode, _rentang),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}