import 'package:flutter/foundation.dart';
import '../models/cucian_order.dart';
import '../repositories/cucian_repository.dart';

/// Lapisan ViewModel: Mengelola state layar Checklist Cucian & Estimasi Selesai (Fase 3).
/// Bertanggung jawab atas daftar cucian aktif, cucian selesai, dan pembaruan status isDone.
class ChecklistViewModel extends ChangeNotifier {
  final CucianRepository repository;

  bool _isLoading = false;
  String? _errorMessage;

  // Pengaturan lama pengerjaan standar (dalam jam) per jenis layanan
  double jamCuciSetrika = 24.0;
  double jamCuciKering = 12.0;
  double jamSetrikaSaja = 8.0;

  ChecklistViewModel({required this.repository}) {
    repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CucianOrder> get cucianAktif => repository.getCucianAktif();
  List<CucianOrder> get cucianSelesai => repository.getCucianSelesai();
  int get totalCount => repository.totalCount;
  int get selesaiCount => repository.selesaiCount;

  Future<void> toggleSelesai(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.toggleStatus(id);
    } catch (e) {
      _errorMessage = 'Gagal memperbarui status order: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCucian(CucianOrder order) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.addCucian(order);
    } catch (e) {
      _errorMessage = 'Gagal menambahkan order: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menghitung estimasi jam pengerjaan berdasarkan jenis layanan dan berat (FR-4.1)
  double hitungEstimasiJam(JenisLayananCucian layanan, double beratKg) {
    double baseJam;
    switch (layanan) {
      case JenisLayananCucian.cuciKering:
        baseJam = jamCuciKering;
        break;
      case JenisLayananCucian.cuciSetrika:
        baseJam = jamCuciSetrika;
        break;
      case JenisLayananCucian.setrikaSaja:
        baseJam = jamSetrikaSaja;
        break;
    }
    // Tambahan waktu jika cucian besar (> 5kg)
    final extraJam = beratKg > 5 ? (beratKg - 5) * 1.0 : 0.0;
    return baseJam + extraJam;
  }

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
