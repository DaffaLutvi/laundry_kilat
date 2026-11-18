/// Lapisan Model: Mewakili entitas informasi paket, promo, estimasi pengerjaan, dan pengumuman.
class InfoLaundry {
  final String id;
  final String judul;
  final String deskripsi;
  final String kategori;
  final bool isPenting;

  const InfoLaundry({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.isPenting,
  });

  InfoLaundry copyWith({
    String? id,
    String? judul,
    String? deskripsi,
    String? kategori,
    bool? isPenting,
  }) {
    return InfoLaundry(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      isPenting: isPenting ?? this.isPenting,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'isPenting': isPenting,
    };
  }

  factory InfoLaundry.fromMap(Map<String, dynamic> map) {
    return InfoLaundry(
      id: map['id'] as String,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      kategori: map['kategori'] as String,
      isPenting: map['isPenting'] as bool? ?? false,
    );
  }
}
