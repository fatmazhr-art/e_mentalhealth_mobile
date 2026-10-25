import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/services/forum_dummy_data.dart';

/// Bar input komentar di bagian bawah layar.
class CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  /// Nama yang sedang dibalas. null = komentar biasa.
  final String? replyingTo;
  final VoidCallback onCancelReply;
  final VoidCallback onSend;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.replyingTo,
    required this.onCancelReply,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyingTo != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
              decoration: BoxDecoration(
                color: AppColors.softPink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Membalas ',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.primary),
                        children: [
                          TextSpan(
                            text: replyingTo,
                            style:
                                const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onCancelReply,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close,
                          size: 16, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          Text.rich(
            const TextSpan(
              text: 'Berkomentar sebagai ',
              style: TextStyle(fontSize: 12, color: AppColors.muted),
              children: [
                TextSpan(
                  text: kMyAlias,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Tulis komentar...',
                    hintStyle: const TextStyle(
                        fontSize: 14, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.card,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onSend,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.send_rounded,
                        size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}