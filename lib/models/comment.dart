class Comment {
  final String id;
  final String alias;
  final String timeAgo;
  final String text;

  /// null = komentar utama, terisi = balasan dari komentar utama itu
  final String? parentId;
  int likes;
  bool isLiked;

  Comment({
    required this.id,
    required this.alias,
    required this.timeAgo,
    required this.text,
    this.parentId,
    this.likes = 0,
    this.isLiked = false,
  });

  bool get isReply => parentId != null;
}