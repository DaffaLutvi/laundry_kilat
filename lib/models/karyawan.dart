/// Lapisan Model: Mewakili data karyawan usaha laundry (FR-6.3).
class Karyawan {
  final String id;
  final String nama;
  final String posisi;
  final String noTelepon;
  final bool isAktif;

  const Karyawan({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.noTelepon,
    this.isAktif = true,
  });

  Karyawan copyWith({
    String? id,
    String? nama,
    String? posisi,
    String? noTelepon,
    bool? isAktif,
  }) {
    return Karyawan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      posisi: posisi ?? this.posisi,
      noTelepon: noTelepon ?? this.noTelepon,
      isAktif: isAktif ?? this.isAktif,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'posisi': posisi,
      'noTelepon': noTelepon,
      'isAktif': isAktif,
    };
  }

  factory Karyawan.fromMap(Map<String, dynamic> map) {
    return Karyawan(
      id: map['id'] as String,
      nama: map['nama'] as String,
      posisi: map['posisi'] as String,
      noTelepon: map['noTelepon'] as String,
      isAktif: map['isAktif'] as bool? ?? true,
    );
  }
}
