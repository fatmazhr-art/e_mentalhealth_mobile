class ThreadPost {
  final String id;
  final String alias;
  final String timeAgo;
  final String content;
  final List<String> tags;
  int likes;
  final int comments;
  bool isLiked;

  ThreadPost({
    required this.id,
    required this.alias,
    required this.timeAgo,
    required this.content,
    required this.tags,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}