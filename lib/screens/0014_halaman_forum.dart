import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/thread_post.dart';
import 'package:e_mentalhealth_mobile/services/forum_dummy_data.dart';
import 'package:e_mentalhealth_mobile/widgets/circle_icon_button.dart';
import 'package:e_mentalhealth_mobile/widgets/lock_banner.dart';
import 'package:e_mentalhealth_mobile/widgets/thread_card.dart';
import 'package:e_mentalhealth_mobile/screens/0023_buat_utasan.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});

  @override
  State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final List<ThreadPost> _posts = dummyThreads();
  int _tabIndex = 0; // 0 = Terbaru, 1 = Populer
  bool _joined = true;

  List<ThreadPost> get _visiblePosts {
    final list = List<ThreadPost>.from(_posts);
    if (_tabIndex == 1) list.sort((a, b) => b.likes.compareTo(a.likes));
    return list; // "Terbaru" = urutan insert (post baru ditaruh di depan)
  }

  Future<void> _openCreateThread() async {
    final result = await Navigator.push<ThreadPost>(
      context,
      MaterialPageRoute(builder: (_) => const CreateThreadScreen()),
    );
    if (result != null) {
      setState(() => _posts.insert(0, result));
    }
  }

  void _toggleLike(ThreadPost p) {
    setState(() {
      p.isLiked = !p.isLiked;
      p.likes += p.isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = _visiblePosts;
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateThread,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit_outlined),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          itemCount: posts.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return _buildTop();
            final p = posts[i - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ThreadCard(post: p, onLike: () => _toggleLike(p)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CircleIconButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.maybePop(context),
              ),
            ),
            const Text('Komunitas',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text)),
          ],
        ),
        const SizedBox(height: 18),
        _buildHeroCard(),
        const SizedBox(height: 18),
        _buildTabs(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeroCard() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(kForumName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _joined = !_joined),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _joined ? AppColors.softPink : AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _joined ? '✓ Bergabung' : 'Gabung',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _joined ? AppColors.primary : Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('1234 anggota',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
              const SizedBox(width: 14),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              const Text('34 online',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Berbagi pengalaman, kekhawatiran, dan cerita seputar magang serta rencana masa depan.',
            style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.text),
          ),
          const SizedBox(height: 12),
          const LockBanner(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const labels = ['Terbaru', 'Populer'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : AppColors.muted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}