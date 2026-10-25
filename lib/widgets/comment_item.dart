import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/comment.dart';
import 'package:e_mentalhealth_mobile/widgets/initial_avatar.dart';

/// Satu komentar (bubble). Balasan otomatis menjorok ke kanan.
class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isAuthor; // true = tampilkan badge "Penulis"
  final VoidCallback onLike;
  final VoidCallback onReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isAuthor,
    required this.onLike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: comment.isReply ? 44 : 0, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InitialAvatar(
            initial: comment.alias[0],
            size: comment.isReply ? 30 : 34,
            pastel: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.alias,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text),
                      ),
                    ),
                    if (isAuthor) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Penulis',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(comment.timeAgo,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.muted)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(comment.text,
                      style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.text)),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    InkWell(
                      onTap: onLike,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              comment.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 17,
                              color: comment.isLiked
                                  ? AppColors.primary
                                  : AppColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Text('${comment.likes} Suka',
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    InkWell(
                      onTap: onReply,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('Balas',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ),
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