import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/thread_post.dart';
import 'package:e_mentalhealth_mobile/widgets/initial_avatar.dart';
import 'package:e_mentalhealth_mobile/widgets/tag_label.dart';

class ThreadCard extends StatelessWidget {
  final ThreadPost post;
  final VoidCallback onLike;
  final VoidCallback? onTap; // dibuka saat kartu diketuk
  const ThreadCard({required this.post, required this.onLike, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
              InitialAvatar(initial: post.alias[0]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.alias,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.text)),
                    Text(post.timeAgo,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content,
              style: const TextStyle(
                  fontSize: 14, height: 1.45, color: AppColors.text)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: post.tags.map((t) => TagLabel(t)).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: post.isLiked ? AppColors.primary : AppColors.muted,
                    ),
                    const SizedBox(width: 5),
                    Text('${post.likes} Dukungan',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.chat_bubble_outline,
                  size: 19, color: AppColors.muted),
              const SizedBox(width: 5),
              Text('${post.comments} Komentar',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    ),
    );
  }
}