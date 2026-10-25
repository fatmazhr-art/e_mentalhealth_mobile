import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/thread_post.dart';
import 'package:e_mentalhealth_mobile/models/comment.dart';
import 'package:e_mentalhealth_mobile/services/forum_dummy_data.dart';
import 'package:e_mentalhealth_mobile/widgets/circle_icon_button.dart';
import 'package:e_mentalhealth_mobile/widgets/initial_avatar.dart';
import 'package:e_mentalhealth_mobile/widgets/tag_label.dart';
import 'package:e_mentalhealth_mobile/widgets/comment_item.dart';
import 'package:e_mentalhealth_mobile/widgets/comment_input_bar.dart';

/// Detail utasan + daftar komentar + input komentar.
class ThreadDetailScreen extends StatefulWidget {
  final ThreadPost post;
  const ThreadDetailScreen({super.key, required this.post});

  @override
  State<ThreadDetailScreen> createState() => _ThreadDetailScreenState();
}

class _ThreadDetailScreenState extends State<ThreadDetailScreen> {
  late final List<Comment> _comments;
  final _inputC = TextEditingController();
  final _inputFocus = FocusNode();

  Comment? _replyTarget; // komentar yang sedang dibalas
  int _added = 0; // jumlah komentar baru yang ditambahkan di layar ini

  @override
  void initState() {
    super.initState();
    // Data contoh hanya ditampilkan kalau utasan memang punya komentar
    _comments = widget.post.comments > 0 ? dummyComments() : [];
  }

  @override
  void dispose() {
    _inputC.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  void _toggleLikePost() {
    final p = widget.post;
    setState(() {
      p.isLiked = !p.isLiked;
      p.likes += p.isLiked ? 1 : -1;
    });
  }

  void _toggleLikeComment(Comment c) {
    setState(() {
      c.isLiked = !c.isLiked;
      c.likes += c.isLiked ? 1 : -1;
    });
  }

  void _startReply(Comment c) {
    setState(() => _replyTarget = c);
    _inputFocus.requestFocus();
  }

  void _cancelReply() => setState(() => _replyTarget = null);

  void _send() {
    final text = _inputC.text.trim();
    if (text.isEmpty) return;

    // Balasan selalu ditempel ke komentar utamanya (maksimal 1 tingkat)
    final target = _replyTarget;
    final parentId = target == null ? null : (target.parentId ?? target.id);

    final c = Comment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      alias: kMyAlias,
      timeAgo: 'Baru saja',
      text: text,
      parentId: parentId,
    );

    setState(() {
      if (parentId == null) {
        _comments.add(c);
      } else {
        var idx = _comments.indexWhere((e) => e.id == parentId);
        if (idx == -1) {
          _comments.add(c);
        } else {
          idx++;
          while (idx < _comments.length && _comments[idx].parentId == parentId) {
            idx++;
          }
          _comments.insert(idx, c);
        }
      }
      _added++;
      _replyTarget = null;
      _inputC.clear();
    });
    FocusScope.of(context).unfocus();
    // TODO: kirim komentar ke backend
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = 2 + (_comments.isEmpty ? 1 : _comments.length);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const CircleBackButton(),
                  ),
                  const Text('Utasan',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                itemCount: itemCount,
                itemBuilder: (context, i) {
                  if (i == 0) return _buildThreadCard();
                  if (i == 1) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 22, bottom: 14),
                      child: Text('Komentar',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary)),
                    );
                  }
                  if (_comments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Belum ada komentar. Jadi yang pertama ya!',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.muted)),
                    );
                  }
                  final c = _comments[i - 2];
                  return CommentItem(
                    comment: c,
                    isAuthor: c.alias == widget.post.alias,
                    onLike: () => _toggleLikeComment(c),
                    onReply: () => _startReply(c),
                  );
                },
              ),
            ),
            CommentInputBar(
              controller: _inputC,
              focusNode: _inputFocus,
              replyingTo: _replyTarget?.alias,
              onCancelReply: _cancelReply,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreadCard() {
    final p = widget.post;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InitialAvatar(initial: p.alias[0], size: 42, pastel: true),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.alias,
                        style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text)),
                    Text('${p.timeAgo} · $kForumName',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 14),
          Text(p.content,
              style: const TextStyle(
                  fontSize: 14.5, height: 1.5, color: AppColors.text)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: p.tags.map((t) => TagLabel(t)).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: _toggleLikePost,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: p.isLiked ? AppColors.softPink : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        p.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text('${p.likes} Dukungan',
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline,
                  size: 19, color: AppColors.muted),
              const SizedBox(width: 5),
              Text('${p.comments + _added} Komentar',
                  style:
                      const TextStyle(fontSize: 12.5, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}