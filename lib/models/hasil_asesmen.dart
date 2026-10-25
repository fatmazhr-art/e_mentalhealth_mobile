/// Hasil satu aspek DASS-21 (Depresi / Kecemasan / Stres).
class SubskalaHasil {
  final String nama;
  final int skor;
  final String tingkat;
  final String deskripsi;

  const SubskalaHasil({
    required this.nama,
    required this.skor,
    required this.tingkat,
    this.deskripsi = '',
  });
}

class HasilAsesmen {
  final String nama;
  final String nim;
  final String prodi;
  final List<SubskalaHasil> subskala;

  const HasilAsesmen({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.subskala,
  });

  SubskalaHasil _getSubskala(String namaTarget) {
    return subskala.firstWhere(
      (s) => s.nama.toLowerCase() == namaTarget.toLowerCase(),
      orElse: () => SubskalaHasil(nama: namaTarget, skor: 0, tingkat: 'Normal'),
    );
  }

  int get skorUtama => _getSubskala('Stres').skor;
  String get labelUtama => 'Stress';
  String get tingkatUtama => _getSubskala('Stres').tingkat;
  String get deskripsiStres => _getSubskala('Stres').deskripsi.isNotEmpty
      ? _getSubskala('Stres').deskripsi
      : 'Beban akumulasi dari tugas akhir dan rutinitas harian membuat Anda merasa berada di titik jenuh.';

  int get skorKecemasan => _getSubskala('Kecemasan').skor;
  String get labelKecemasan => _getSubskala('Kecemasan').tingkat;
  String get deskripsiKecemasan => _getSubskala('Kecemasan').deskripsi.isNotEmpty
      ? _getSubskala('Kecemasan').deskripsi
      : 'Anda merasakan ketakutan atau panik berlebih terkait persaingan dunia kerja.';

  int get skorDepresi => _getSubskala('Depresi').skor;
  String get labelDepresi => _getSubskala('Depresi').tingkat;
  String get deskripsiDepresi => _getSubskala('Depresi').deskripsi.isNotEmpty
      ? _getSubskala('Depresi').deskripsi
      : 'Suasana hati Anda dalam keadaan terkelola dengan baik.';

  bool get isTinggi {
    final daftarTinggi = ['sangat berat', 'berat'];
    return subskala.any((s) => daftarTinggi.contains(s.tingkat.toLowerCase()));
  }

  String get deskripsiSingkat {
    if (isTinggi) {
      return 'Kondisimu saat ini didominasi oleh beban stres tingkat sangat berat yang mempengaruhi kenyamanan fisik dan pikiran.';
    }
    return 'Kamu sedang mengalami tingkat stres sedang. Ini wajar terjadi saat menghadapi dinamika tugas akhir atau rutinitas harian.';
  }

  String get penjelasanApaArtinya {
    if (isTinggi) {
      return 'Beban akumulasi dari tugas akhir, tekanan magang, dan ekspektasi tinggi membuat kamu merasa berada di titik jenuh dan sangat kewalahan. Ingat, kamu tidak sendirian dan respon ini adalah tanda alami bahwa tubuhmu membutuhkan waktu jeda dan pendampingan yang tepat.';
    }
    return 'Secara umum kondisimu dalam batas yang dapat dikelola dengan baik. Suasana hati cukup stabil, namun ada beberapa tekanan harian yang memicu ketegangan ringan hingga sedang. Luangkan waktu sejenak untuk relaksasi teratur agar energi pikiranmu tetap prima.';
  }

  String get deskripsiLengkap {
    if (isTinggi) {
      return 'Kamu sedang mengalami tingkat kecemasan dan stres sangat berat dan perlu pendamping. Silahkan hubungi Konselor.';
    }
    return 'Kamu sedang mengalami tingkat kecemasan dan stres sedang. Ini wajar terjadi saat menghadapi tekanan magang dan tugas akhir bersamaan.';
  }

  factory HasilAsesmen.contoh({
    required String nama,
    required String nim,
    required String prodi,
  }) {
    return HasilAsesmen(
      nama: nama,
      nim: nim,
      prodi: prodi,
      subskala: const [
        SubskalaHasil(
          nama: 'Depresi',
          skor: 12,
          tingkat: 'Sedang',
          deskripsi: 'Anda merasa kesulitan untuk tetap bersemangat saat mengerjakan skripsi, serta sering kehilangan fokus.',
        ),
        SubskalaHasil(
          nama: 'Kecemasan',
          skor: 21,
          tingkat: 'Berat',
          deskripsi: 'Anda merasakan ketakutan atau panik berlebih terkait persaingan dunia kerja setelah magang.',
        ),
        SubskalaHasil(
          nama: 'Stres',
          skor: 40,
          tingkat: 'Sangat Berat',
          deskripsi: 'Beban akumulasi dari tugas akhir, tekanan magang, dan ekspektasi tinggi membuat Anda berada di titik jenuh.',
        ),
      ],
    );
  }
}