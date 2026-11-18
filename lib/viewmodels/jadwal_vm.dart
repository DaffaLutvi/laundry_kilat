import 'package:flutter/foundation.dart';
import '../models/jadwal_laundry.dart';
import '../repositories/jadwal_repository.dart';

/// Lapisan ViewModel: Mengelola state layar Jadwal Antar-Jemput (Fase 2).
/// Mendukung filter SegmentedButton, CRUD jadwal, dan validasi form.
class JadwalViewModel extends ChangeNotifier {
  final JadwalRepository repository;

  JenisLayananJadwal? _filterLayanan; // null berarti 'Semua'
  String _filterHari = 'Semua';
  bool _isLoading = false;
  String? _errorMessage;

  JadwalViewModel({required this.repository}) {
    repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  JenisLayananJadwal? get filterLayanan => _filterLayanan;
  String get filterHari => _filterHari;

  List<JadwalLaundry> get jadwalList {
    return repository.getJadwalFiltered(
      jenisLayanan: _filterLayanan,
      hari: _filterHari,
    );
  }

  void setFilterLayanan(JenisLayananJadwal? layanan) {
    _filterLayanan = layanan;
    notifyListeners();
  }

  void setFilterHari(String hari) {
    _filterHari = hari;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addJadwal(JadwalLaundry item) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.addJadwal(item);
    } catch (e) {
      _errorMessage = 'Gagal menambah jadwal: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateJadwal(JadwalLaundry item) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.updateJadwal(item);
    } catch (e) {
      _errorMessage = 'Gagal mengubah jadwal: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteJadwal(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.deleteJadwal(id);
    } catch (e) {
      _errorMessage = 'Gagal menghapus jadwal: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
