/// Lapisan Model: Mewakili data layanan dan harga per kilogram (FR-6.2).
class LayananHarga {
  final String id;
  final String namaLayanan;
  final double hargaPerKg;
  final double estimasiJam;

  const LayananHarga({
    required this.id,
    required this.namaLayanan,
    required this.hargaPerKg,
    required this.estimasiJam,
  });

  LayananHarga copyWith({
    String? id,
    String? namaLayanan,
    double? hargaPerKg,
    double? estimasiJam,
  }) {
    return LayananHarga(
      id: id ?? this.id,
      namaLayanan: namaLayanan ?? this.namaLayanan,
      hargaPerKg: hargaPerKg ?? this.hargaPerKg,
      estimasiJam: estimasiJam ?? this.estimasiJam,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaLayanan': namaLayanan,
      'hargaPerKg': hargaPerKg,
      'estimasiJam': estimasiJam,
    };
  }

  factory LayananHarga.fromMap(Map<String, dynamic> map) {
    return LayananHarga(
      id: map['id'] as String,
      namaLayanan: map['namaLayanan'] as String,
      hargaPerKg: (map['hargaPerKg'] as num).toDouble(),
      estimasiJam: (map['estimasiJam'] as num).toDouble(),
    );
  }
}
