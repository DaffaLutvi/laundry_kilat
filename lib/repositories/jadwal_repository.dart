import 'package:flutter/foundation.dart';
import '../models/jadwal_laundry.dart';
import '../services/local_data_service.dart';
import '../utils/date_helper.dart';

/// Lapisan Repository: Pintu akses tunggal untuk data JadwalLaundry.
/// Bertanggung jawab mengambil data dari Service, menyaring, dan mengurutkannya.
class JadwalRepository extends ChangeNotifier {
  final LocalDataService _service;

  JadwalRepository(this._service) {
    _service.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceChanged);
    super.dispose();
  }

  /// Mengambil seluruh jadwal
  List<JadwalLaundry> getAllJadwal() {
    final list = List<JadwalLaundry>.from(_service.getJadwalList());
    list.sort((a, b) => DateHelper.parseMenit(a.jam).compareTo(DateHelper.parseMenit(b.jam)));
    return list;
  }

  /// Mengambil jadwal khusus hari ini yang telah diurutkan berdasarkan jam (FR-1.1)
  List<JadwalLaundry> getJadwalHariIni() {
    final hariIni = DateHelper.getHariIni().toLowerCase();
    final list = _service
        .getJadwalList()
        .where((j) => j.hari.toLowerCase() == hariIni)
        .toList();
    list.sort((a, b) => DateHelper.parseMenit(a.jam).compareTo(DateHelper.parseMenit(b.jam)));
    return list;
  }

  /// Mengambil jadwal berdasarkan filter jenis layanan atau hari
  List<JadwalLaundry> getJadwalFiltered({
    JenisLayananJadwal? jenisLayanan,
    String? hari,
  }) {
    var list = _service.getJadwalList();
    if (jenisLayanan != null) {
      list = list.where((j) => j.jenisLayanan == jenisLayanan).toList();
    }
    if (hari != null && hari.isNotEmpty && hari != 'Semua') {
      list = list.where((j) => j.hari.toLowerCase() == hari.toLowerCase()).toList();
    }
    final sorted = List<JadwalLaundry>.from(list);
    sorted.sort((a, b) => DateHelper.parseMenit(a.jam).compareTo(DateHelper.parseMenit(b.jam)));
    return sorted;
  }

  Future<void> addJadwal(JadwalLaundry item) async {
    _service.addJadwal(item);
  }

  Future<void> updateJadwal(JadwalLaundry item) async {
    _service.updateJadwal(item);
  }

  Future<void> deleteJadwal(String id) async {
    _service.deleteJadwal(id);
  }
}
