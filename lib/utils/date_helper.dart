/// Helper utility untuk penanggalan dan hari dalam Bahasa Indonesia.
class DateHelper {
  static const List<String> daftarHari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> daftarBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static String getHariIni() {
    return getNamaHari(DateTime.now());
  }

  static String getNamaHari(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return 'Senin';
    }
  }

  static String getTanggalLengkap(DateTime date) {
    final hari = getNamaHari(date);
    final tgl = date.day;
    final bln = daftarBulan[date.month - 1];
    final thn = date.year;
    return '$hari, $tgl $bln $thn';
  }

  /// Membantu pengurutan waktu jam 'HH:mm' menjadi menit sejak tengah malam
  static int parseMenit(String jamStr) {
    try {
      final parts = jamStr.trim().split(':');
      if (parts.length >= 2) {
        final jam = int.tryParse(parts[0]) ?? 0;
        final menit = int.tryParse(parts[1]) ?? 0;
        return (jam * 60) + menit;
      }
    } catch (_) {}
    return 0;
  }
}
