/// Lapisan Model: Mewakili entitas order cucian yang harus diproses.
enum JenisLayananCucian {
  cuciKering,
  cuciSetrika,
  setrikaSaja,
}

extension JenisLayananCucianExt on JenisLayananCucian {
  String get label {
    switch (this) {
      case JenisLayananCucian.cuciKering:
        return 'Cuci Kering';
      case JenisLayananCucian.cuciSetrika:
        return 'Cuci Setrika';
      case JenisLayananCucian.setrikaSaja:
        return 'Setrika Saja';
    }
  }

  static JenisLayananCucian fromString(String val) {
    switch (val.toLowerCase().replaceAll(' ', '')) {
      case 'cucikering':
        return JenisLayananCucian.cuciKering;
      case 'cucisetrika':
        return JenisLayananCucian.cuciSetrika;
      case 'setrikasaja':
        return JenisLayananCucian.setrikaSaja;
      default:
        return JenisLayananCucian.cuciSetrika;
    }
  }
}

class CucianOrder {
  final String id;
  final String namaPelanggan;
  final double beratKg;
  final JenisLayananCucian jenisLayanan;
  final bool isDone;

  const CucianOrder({
    required this.id,
    required this.namaPelanggan,
    required this.beratKg,
    required this.jenisLayanan,
    this.isDone = false,
  });

  CucianOrder copyWith({
    String? id,
    String? namaPelanggan,
    double? beratKg,
    JenisLayananCucian? jenisLayanan,
    bool? isDone,
  }) {
    return CucianOrder(
      id: id ?? this.id,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      beratKg: beratKg ?? this.beratKg,
      jenisLayanan: jenisLayanan ?? this.jenisLayanan,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaPelanggan': namaPelanggan,
      'beratKg': beratKg,
      'jenisLayanan': jenisLayanan.name,
      'isDone': isDone,
    };
  }

  factory CucianOrder.fromMap(Map<String, dynamic> map) {
    return CucianOrder(
      id: map['id'] as String,
      namaPelanggan: map['namaPelanggan'] as String,
      beratKg: (map['beratKg'] as num).toDouble(),
      jenisLayanan: JenisLayananCucianExt.fromString(map['jenisLayanan'] as String),
      isDone: map['isDone'] as bool? ?? false,
    );
  }
}
