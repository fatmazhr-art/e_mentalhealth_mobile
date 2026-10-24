import 'package:e_mentalhealth_mobile/models/thread_post.dart';

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