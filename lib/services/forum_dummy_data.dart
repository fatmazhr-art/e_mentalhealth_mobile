import 'package:e_mentalhealth_mobile/models/thread_post.dart';
import 'package:e_mentalhealth_mobile/models/comment.dart';

// Data sementara (palsu). Nanti diganti pemanggilan API Laravel.

const String kMyAlias = 'Kucing Tenang';
const String kForumName = 'Magang dan Dunia Kerja';
const List<String> kAllTags = ['Curhat', 'Magang', 'Tanya', 'Tips', 'Karier', 'Gaji'];

List<ThreadPost> dummyThreads() => [
      ThreadPost(
        id: '1',
        alias: 'Kopi Hangat',
        timeAgo: '25 Menit lalu',
        content:
            'Minggu pertama magang rasanya capek banget dan sering merasa nggak cukup pintar dibanding anak magang lain. Ada yang pernah ngerasain hal yang sama? Gimana cara kalian bertahan?',
        tags: ['Curhat', 'Magang'],
        likes: 45,
        comments: 16,
      ),
      ThreadPost(
        id: '2',
        alias: 'Awan Senja',
        timeAgo: '1 Jam lalu',
        content:
            'Mau tanya, kalau mentor di tempat magang jarang kasih feedback, sebaiknya aku proaktif minta atau tunggu saja?',
        tags: ['Tanya', 'Magang'],
        likes: 82,
        comments: 23,
      ),
      ThreadPost(
        id: '3',
        alias: 'Daun Pagi',
        timeAgo: '3 Jam lalu',
        content:
            'Tips dari aku: catat pencapaian kecil tiap hari selama magang. Pas evaluasi akhir atau bikin CV, kamu nggak perlu mengingat-ingat lagi.',
        tags: ['Tips', 'Karier'],
        likes: 120,
        comments: 9,
      ),
    ];

/// Komentar contoh (urutan sudah sesuai tampilan: komentar utama, lalu balasannya).
List<Comment> dummyComments() => [
      Comment(
        id: 'c1',
        alias: 'Teh Manis',
        timeAgo: '15 menit lalu',
        text:
            'Semangat ya! Minggu pertama memang paling berat. Pelan-pelan aja, nggak ada yang langsung ngerti semuanya kok.',
        likes: 12,
      ),
      Comment(
        id: 'c2',
        parentId: 'c1',
        alias: 'Kopi Hangat',
        timeAgo: '12 menit lalu',
        text: 'Makasih banyak, jadi lebih tenang bacanya.',
        likes: 4,
      ),
      Comment(
        id: 'c3',
        alias: 'Awan Sore',
        timeAgo: '10 menit lalu',
        text:
            'Coba catat hal yang belum dimengerti, lalu tanyakan ke mentor di akhir hari.',
        likes: 7,
      ),
    ];