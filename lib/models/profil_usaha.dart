/// Lapisan Model: Mewakili data profil usaha laundry kiloan (FR-6.1).
class ProfilUsaha {
  final String namaUsaha;
  final String alamat;
  final String kontak;
  final String jamOperasional;

  const ProfilUsaha({
    required this.namaUsaha,
    required this.alamat,
    required this.kontak,
    required this.jamOperasional,
  });

  ProfilUsaha copyWith({
    String? namaUsaha,
    String? alamat,
    String? kontak,
    String? jamOperasional,
  }) {
    return ProfilUsaha(
      namaUsaha: namaUsaha ?? this.namaUsaha,
      alamat: alamat ?? this.alamat,
      kontak: kontak ?? this.kontak,
      jamOperasional: jamOperasional ?? this.jamOperasional,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaUsaha': namaUsaha,
      'alamat': alamat,
      'kontak': kontak,
      'jamOperasional': jamOperasional,
    };
  }

  factory ProfilUsaha.fromMap(Map<String, dynamic> map) {
    return ProfilUsaha(
      namaUsaha: map['namaUsaha'] as String,
      alamat: map['alamat'] as String,
      kontak: map['kontak'] as String,
      jamOperasional: map['jamOperasional'] as String,
    );
  }
}
