import 'package:flutter/material.dart';

// Memakai enum Mood dari halaman Mood Tracker (label, gambar, ikon cadangan).
// Sesuaikan path jika file ini tidak satu folder dengan 0012_mood_tracker.dart.
import '0012_mood_tracker.dart' show Mood;

// ─────────────────────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────────────────────
class _C {
  static const maroon = Color(0xFF7A0C2E);
  static const sheetBg = Color(0xFFFFFBF5);
  static const cardBg = Color(0xFFF7EFE5);
  static const tagBg = Color(0xFFF3D0D7);
  static const handle = Color(0xFFD9CFC4);
  static const textMuted = Color(0xFF8A7F78);
  static const textBody = Color(0xFF3E3430);
  static final scrim = const Color(0xFF3A0A18).withOpacity(0.45);
}

// ─────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────
class MoodJournalData {
  final Mood mood; // dari enum Mood di 0012_mood_tracker.dart
  final String moodNote;
  final DateTime moodRecordedAt;
  final List<String> factors;

  final String? journalTitle; // null = belum ada jurnal
  final String? journalContent;
  final DateTime? journalRecordedAt;

  const MoodJournalData({
    required this.mood,
    required this.moodRecordedAt,
    this.moodNote = '',
    this.factors = const [],
    this.journalTitle,
    this.journalContent,
    this.journalRecordedAt,
  });

  String get moodTitle => mood.label;

  bool get hasJournal =>
      (journalTitle?.isNotEmpty ?? false) ||
      (journalContent?.isNotEmpty ?? false);
}

/// Mengambil data berdasarkan tanggal (dari DB / provider / API).
typedef MoodDataLoader = MoodJournalData? Function(DateTime date);

// ─────────────────────────────────────────────────────────────
// Cara memanggil
// ─────────────────────────────────────────────────────────────
Future<void> showMoodDetailBottomSheet(
  BuildContext context, {
  required DateTime selectedDate,
  required MoodJournalData? data,
  MoodDataLoader? dataLoader, // opsional: aktifkan navigasi < >
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: _C.scrim,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.92,
    ),
    builder: (_) => MoodDetailBottomSheet(
      selectedDate: selectedDate,
      data: data,
      dataLoader: dataLoader,
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// Widget utama
// ─────────────────────────────────────────────────────────────
class MoodDetailBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final MoodJournalData? data;
  final MoodDataLoader? dataLoader;

  const MoodDetailBottomSheet({
    super.key,
    required this.selectedDate,
    required this.data,
    this.dataLoader,
  });

  @override
  State<MoodDetailBottomSheet> createState() => _MoodDetailBottomSheetState();
}

class _MoodDetailBottomSheetState extends State<MoodDetailBottomSheet> {
  late DateTime _date;
  MoodJournalData? _data;

  static const _days = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];
  static const _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _date = DateUtils.dateOnly(widget.selectedDate);
    _data = widget.data;
  }

  bool get _isToday => DateUtils.isSameDay(_date, DateTime.now());
  bool get _canGoNext => _date.isBefore(DateUtils.dateOnly(DateTime.now()));
  bool get _canNavigate => widget.dataLoader != null;

  String get _dateLabel =>
      '${_days[_date.weekday - 1]}, ${_date.day} ${_months[_date.month - 1]}';

  String _time(DateTime t) =>
      'dicatat pukul ${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')} WIB';

  void _go(int offset) {
    final next = _date.add(Duration(days: offset));
    setState(() {
      _date = DateUtils.dateOnly(next);
      _data = widget.dataLoader?.call(_date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.sheetBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // Drag handle
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: _C.handle,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 14),
            _buildHeader(),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Column(
                    key: ValueKey(_date),
                    mainAxisSize: MainAxisSize.min,
                    children: _data == null
                        ? [_buildEmptyState()]
                        : [
                            _buildMoodCard(_data!),
                            if (_data!.hasJournal) ...[
                              const SizedBox(height: 14),
                              _buildJournalCard(_data!),
                            ],
                          ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Tutup Lembar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Flexible(
            child: Text(
              _dateLabel,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _C.maroon,
              ),
            ),
          ),
          if (_isToday) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _C.maroon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Hari ini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const Spacer(),
          _NavIcon(
            icon: Icons.chevron_left_rounded,
            onTap: _canNavigate ? () => _go(-1) : null,
          ),
          _NavIcon(
            icon: Icons.chevron_right_rounded,
            onTap: (_canNavigate && _canGoNext) ? () => _go(1) : null,
          ),
          _NavIcon(
            icon: Icons.close_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ── Card 1: Mood ──────────────────────────────────────────
  Widget _buildMoodCard(MoodJournalData d) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Image.asset(
                  d.mood.gambar,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(
                      color: _C.tagBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(d.mood.ikon, color: _C.maroon, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.moodTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _C.maroon,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _time(d.moodRecordedAt),
                      style: const TextStyle(fontSize: 12.5, color: _C.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (d.moodNote.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              d.moodNote,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: _C.textBody,
              ),
            ),
          ],
          if (d.factors.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: d.factors.map((f) => _FactorChip(label: f)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Card 2: Jurnal ────────────────────────────────────────
  Widget _buildJournalCard(MoodJournalData d) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (d.journalTitle != null)
            Text(
              d.journalTitle!,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _C.maroon,
              ),
            ),
          if (d.journalRecordedAt != null) ...[
            const SizedBox(height: 2),
            Text(
              _time(d.journalRecordedAt!),
              style: const TextStyle(fontSize: 12.5, color: _C.textMuted),
            ),
          ],
          if (d.journalContent != null) ...[
            const SizedBox(height: 12),
            Text(
              d.journalContent!,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: _C.textBody,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return _SurfaceCard(
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Belum ada catatan mood atau jurnal\npada tanggal ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _C.textMuted, height: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Komponen kecil
// ─────────────────────────────────────────────────────────────
class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _FactorChip extends StatelessWidget {
  final String label;
  const _FactorChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _C.tagBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _C.maroon,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 26,
          color: enabled ? _C.maroon : _C.maroon.withOpacity(0.25),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Contoh penggunaan (hapus jika tidak perlu)
// ─────────────────────────────────────────────────────────────
//
// onDayTapped(DateTime date) {
//   showMoodDetailBottomSheet(
//     context,
//     selectedDate: date,
//     data: repo.getByDate(date),
//     dataLoader: repo.getByDate, // aktifkan tombol < >
//   );
// }
//
// final contoh = MoodJournalData(
//   mood: Mood.luarBiasa,
//   moodRecordedAt: DateTime(2026, 10, 23, 9, 7),
//   moodNote: 'Habis keliling perpustakaan dan dengerin musik favorit.',
//   factors: ['Istirahat cukup', 'Keluarga'],
//   journalTitle: 'Refleksi Tugas Akhir',
//   journalRecordedAt: DateTime(2026, 10, 23, 9, 7),
//   journalContent:
//       'Awalnya cemas banget sebelum maju presentasi, tapi setelah latihan '
//       'pernapasan yang direkomendasikan konselor, deg-degannya berkurang drastis...',
// );