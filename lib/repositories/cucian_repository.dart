import 'package:flutter/foundation.dart';
import '../models/cucian_order.dart';
import '../services/local_data_service.dart';

/// Lapisan Repository: Pintu akses tunggal untuk data CucianOrder.
/// Mengelola daftar order aktif, order selesai, serta perhitungan ringkasan selesai.
class CucianRepository extends ChangeNotifier {
  final LocalDataService _service;

  CucianRepository(this._service) {
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

  List<CucianOrder> getAllCucian() {
    return _service.getCucianList();
  }

  /// Mengambil daftar cucian yang belum selesai (Pekerjaan Hari Ini - FR-1.2)
  List<CucianOrder> getCucianAktif() {
    return _service.getCucianList().where((c) => !c.isDone).toList();
  }

  /// Mengambil daftar cucian yang sudah selesai (Bagian Selesai - FR-3.3)
  List<CucianOrder> getCucianSelesai() {
    return _service.getCucianList().where((c) => c.isDone).toList();
  }

  int get totalCount => _service.getCucianList().length;
  int get selesaiCount => _service.getCucianList().where((c) => c.isDone).length;
  int get aktifCount => _service.getCucianList().where((c) => !c.isDone).length;

  /// String ringkasan selesai, contoh "3 dari 8 selesai" (FR-1.3)
  String get ringkasanSelesaiText => '$selesaiCount dari $totalCount selesai';

  Future<void> toggleStatus(String id) async {
    _service.toggleCucianStatus(id);
  }

  Future<void> setStatus(String id, bool isDone) async {
    _service.setCucianStatus(id, isDone);
  }

  Future<void> addCucian(CucianOrder item) async {
    _service.addCucian(item);
  }

  Future<void> updateCucian(CucianOrder item) async {
    _service.updateCucian(item);
  }

  Future<void> deleteCucian(String id) async {
    _service.deleteCucian(id);
  }
}
