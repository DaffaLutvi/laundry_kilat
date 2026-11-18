import 'package:flutter/foundation.dart';
import '../models/info_laundry.dart';
import '../services/local_data_service.dart';

/// Lapisan Repository: Pintu akses tunggal untuk data InfoLaundry.
/// Menangani pengambilan info, penyaringan kategori, dan pemilahan status penting.
class InfoRepository extends ChangeNotifier {
  final LocalDataService _service;

  InfoRepository(this._service) {
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

  /// Mengambil semua info dengan prioritas info penting berada di atas (FR-5.3)
  List<InfoLaundry> getAllInfo() {
    final list = List<InfoLaundry>.from(_service.getInfoList());
    list.sort((a, b) {
      if (a.isPenting && !b.isPenting) return -1;
      if (!a.isPenting && b.isPenting) return 1;
      return 0;
    });
    return list;
  }

  /// Mengambil info yang difilter berdasarkan kategori
  List<InfoLaundry> getInfoByKategori(String kategori) {
    if (kategori == 'Semua') {
      return getAllInfo();
    }
    final list = _service
        .getInfoList()
        .where((info) => info.kategori.toLowerCase() == kategori.toLowerCase())
        .toList();
    list.sort((a, b) {
      if (a.isPenting && !b.isPenting) return -1;
      if (!a.isPenting && b.isPenting) return 1;
      return 0;
    });
    return list;
  }

  /// Mengambil daftar semua kategori unik
  List<String> getKategoriList() {
    final categories = _service.getInfoList().map((e) => e.kategori).toSet().toList();
    categories.sort();
    return ['Semua', ...categories];
  }

  Future<void> togglePenting(String id) async {
    _service.toggleInfoPenting(id);
  }

  Future<void> addInfo(InfoLaundry item) async {
    _service.addInfo(item);
  }

  Future<void> updateInfo(InfoLaundry item) async {
    _service.updateInfo(item);
  }

  Future<void> deleteInfo(String id) async {
    _service.deleteInfo(id);
  }
}
