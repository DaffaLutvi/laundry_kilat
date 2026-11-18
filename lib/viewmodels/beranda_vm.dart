import 'package:flutter/foundation.dart';
import '../models/jadwal_laundry.dart';
import '../models/cucian_order.dart';
import '../repositories/jadwal_repository.dart';
import '../repositories/cucian_repository.dart';

/// Lapisan ViewModel: Mengelola state layar Beranda Hari Ini.
/// Menghubungkan View dengan JadwalRepository dan CucianRepository.
/// Merespons pembaruan data secara real-time saat status cucian atau jadwal berubah.
class BerandaViewModel extends ChangeNotifier {
  final JadwalRepository jadwalRepo;
  final CucianRepository cucianRepo;

  bool _isLoading = false;
  String? _errorMessage;

  List<JadwalLaundry> _jadwalHariIni = [];
  List<CucianOrder> _pekerjaanHariIni = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<JadwalLaundry> get jadwalHariIni => _jadwalHariIni;
  List<CucianOrder> get pekerjaanHariIni => _pekerjaanHariIni;

  int get totalOrder => cucianRepo.totalCount;
  int get selesaiOrder => cucianRepo.selesaiCount;
  int get aktifOrder => cucianRepo.aktifCount;
  String get ringkasanSelesai => cucianRepo.ringkasanSelesaiText;
  double get persentaseSelesai =>
      totalOrder == 0 ? 0.0 : (selesaiOrder / totalOrder).clamp(0.0, 1.0);

  BerandaViewModel({
    required this.jadwalRepo,
    required this.cucianRepo,
  }) {
    jadwalRepo.addListener(_onRepositoryChanged);
    cucianRepo.addListener(_onRepositoryChanged);
    _loadData();
  }

  void _onRepositoryChanged() {
    _loadData();
    notifyListeners();
  }

  void _loadData() {
    try {
      _jadwalHariIni = jadwalRepo.getJadwalHariIni();
      _pekerjaanHariIni = cucianRepo.getCucianAktif();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat memuat data: $e';
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    _loadData();
    _isLoading = false;
    notifyListeners();
  }

  /// Aksi cepat untuk menandai cucian selesai langsung dari Beranda jika diinginkan
  Future<void> toggleSelesaiCucian(String id) async {
    try {
      await cucianRepo.toggleStatus(id);
    } catch (e) {
      _errorMessage = 'Gagal memperbarui status order: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    jadwalRepo.removeListener(_onRepositoryChanged);
    cucianRepo.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
