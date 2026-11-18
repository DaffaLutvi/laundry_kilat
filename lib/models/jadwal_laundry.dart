/// Lapisan Model: Mewakili entitas jadwal antar-jemput cucian pelanggan.
enum JenisLayananJadwal {
  antar,
  jemput,
  ambilDiToko,
}

extension JenisLayananJadwalExt on JenisLayananJadwal {
  String get label {
    switch (this) {
      case JenisLayananJadwal.antar:
        return 'Antar';
      case JenisLayananJadwal.jemput:
        return 'Jemput';
      case JenisLayananJadwal.ambilDiToko:
        return 'Ambil di Toko';
    }
  }

  static JenisLayananJadwal fromString(String val) {
    switch (val.toLowerCase()) {
      case 'antar':
        return JenisLayananJadwal.antar;
      case 'jemput':
        return JenisLayananJadwal.jemput;
      case 'ambilditoko':
      case 'ambil di toko':
        return JenisLayananJadwal.ambilDiToko;
      default:
        return JenisLayananJadwal.jemput;
    }
  }
}

class JadwalLaundry {
  final String id;
  final String namaPelanggan;
  final String alamat;
  final String hari;
  final String jam;
  final JenisLayananJadwal jenisLayanan;

  const JadwalLaundry({
    required this.id,
    required this.namaPelanggan,
    required this.alamat,
    required this.hari,
    required this.jam,
    required this.jenisLayanan,
  });

  JadwalLaundry copyWith({
    String? id,
    String? namaPelanggan,
    String? alamat,
    String? hari,
    String? jam,
    JenisLayananJadwal? jenisLayanan,
  }) {
    return JadwalLaundry(
      id: id ?? this.id,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      alamat: alamat ?? this.alamat,
      hari: hari ?? this.hari,
      jam: jam ?? this.jam,
      jenisLayanan: jenisLayanan ?? this.jenisLayanan,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaPelanggan': namaPelanggan,
      'alamat': alamat,
      'hari': hari,
      'jam': jam,
      'jenisLayanan': jenisLayanan.name,
    };
  }

  factory JadwalLaundry.fromMap(Map<String, dynamic> map) {
    return JadwalLaundry(
      id: map['id'] as String,
      namaPelanggan: map['namaPelanggan'] as String,
      alamat: map['alamat'] as String,
      hari: map['hari'] as String,
      jam: map['jam'] as String,
      jenisLayanan: JenisLayananJadwalExt.fromString(map['jenisLayanan'] as String),
    );
  }
}
