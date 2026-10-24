import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/thread_post.dart';
import 'package:e_mentalhealth_mobile/services/forum_dummy_data.dart';
import 'package:e_mentalhealth_mobile/widgets/circle_icon_button.dart';
import 'package:e_mentalhealth_mobile/widgets/initial_avatar.dart';
import 'package:e_mentalhealth_mobile/widgets/lock_banner.dart';
import 'package:e_mentalhealth_mobile/widgets/dashed_border_painter.dart';

class CreateThreadScreen extends StatefulWidget {
  const CreateThreadScreen({super.key});

  @override
  State<CreateThreadScreen> createState() => _CreateThreadScreenState();
}

class _CreateThreadScreenState extends State<CreateThreadScreen> {
  static const int _maxChars = 500;
  static const int _maxTags = 3;

  final _controller = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _allowComments = true;

  @override
  void initState() {
    super.initState();
    // Perbarui counter karakter setiap teks berubah
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else if (_selectedTags.length < _maxTags) {
        _selectedTags.add(tag);
      } else {
        _snack('Maksimal $_maxTags label');
      }
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _snack('Ceritakan sesuatu dulu ya');
      return;
    }
    if (_selectedTags.isEmpty) {
      _snack('Pilih minimal 1 label');
      return;
    }
    final post = ThreadPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      alias: kMyAlias,
      timeAgo: 'Baru saja',
      content: text,
      tags: _selectedTags.toList(),
    );
    Navigator.pop(context, post); // kembalikan ke feed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleIconButton(
                      icon: Icons.close,
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                  const Text('Buat Utasan',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text)),
                ],
              ),
            ),
            // Konten scrollable (aman dari keyboard overflow)
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIdentity(),
                    const SizedBox(height: 12),
                    const LockBanner(),
                    const SizedBox(height: 20),
                    _buildTextArea(),
                    const SizedBox(height: 20),
                    _buildTagSection(),
                    const SizedBox(height: 20),
                    _buildPhotoPicker(),
                    const SizedBox(height: 12),
                    _buildCommentToggle(),
                  ],
                ),
              ),
            ),
            // Tombol posting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_rounded, size: 20),
                  label: const Text('Posting Utasan',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentity() {
    return Row(
      children: [
        const InitialAvatar(initial: 'K', size: 46),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(kMyAlias,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text)),
              Text('Posting ke Forum $kForumName',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ceritakan di sini',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                minLines: 5,
                maxLines: 6,
                maxLength: _maxChars,
                style: const TextStyle(fontSize: 14, color: AppColors.text),
                decoration: const InputDecoration(
                  hintText: 'Tulis ceritamu, pertanyaan, atau tips di sini...',
                  hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                  border: InputBorder.none,
                  counterText: '', // counter dibuat manual di bawah
                  contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('${_controller.text.length}/$_maxChars',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pilih label',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text)),
            Text('${_selectedTags.length}/$_maxTags dipilih',
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kAllTags.map((tag) {
            final selected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border),
                ),
                child: Text(tag,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.text)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      // TODO: sambungkan ke package image_picker
      onTap: () => _snack('Fitur tambah foto segera hadir'),
      child: CustomPaint(
        painter: DashedRRectPainter(
            color: AppColors.tag, radius: 16, dash: 6, gap: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: const Column(
            children: [
              Icon(Icons.image_outlined, size: 30, color: AppColors.tag),
              SizedBox(height: 6),
              Text('Tambah foto',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tag)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text('Izinkan komentar',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text)),
          ),
          Switch(
            value: _allowComments,
            onChanged: (v) => setState(() => _allowComments = v),
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}