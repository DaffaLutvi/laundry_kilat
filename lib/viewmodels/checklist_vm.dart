import 'package:flutter/foundation.dart';
import '../models/cucian_order.dart';
import '../repositories/cucian_repository.dart';
import '../utils/date_helper.dart';

/// Lapisan ViewModel: Mengelola state layar Checklist Cucian & Estimasi Selesai (Fase 3).
/// Bertanggung jawab atas daftar cucian aktif, cucian selesai, kalkulasi estimasi pengerjaan,
/// pengaturan lama pengerjaan, dan generator pesan bagikan bawaan ponsel.
class ChecklistViewModel extends ChangeNotifier {
  final CucianRepository repository;

  bool _isLoading = false;
  String? _errorMessage;

  // Pengaturan lama pengerjaan standar (dalam jam) per jenis layanan (FR-4.2)
  double jamCuciSetrika = 24.0;
  double jamCuciKering = 12.0;
  double jamSetrikaSaja = 8.0;
  double jamKilat = 3.0;

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

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isLoading = false;
    notifyListeners();
  }

  /// Menandai order selesai atau membatalkan centang (FR-3.2, FR-3.3)
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

  Future<void> deleteCucian(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.deleteCucian(id);
    } catch (e) {
      _errorMessage = 'Gagal menghapus order: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengatur lama pengerjaan per jenis layanan (FR-4.2)
  void updatePengaturanLamaPengerjaan({
    required double cuciSetrika,
    required double cuciKering,
    required double setrikaSaja,
    required double kilat,
  }) {
    jamCuciSetrika = cuciSetrika;
    jamCuciKering = cuciKering;
    jamSetrikaSaja = setrikaSaja;
    jamKilat = kilat;
    notifyListeners();
  }

  /// Menghitung estimasi jam pengerjaan otomatis berdasarkan jenis layanan dan berat (FR-4.1)
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

  /// Menghitung waktu target tanggal & jam selesai
  DateTime hitungTargetSelesai(JenisLayananCucian layanan, double beratKg) {
    final jam = hitungEstimasiJam(layanan, beratKg);
    return DateTime.now().add(Duration(minutes: (jam * 60).round()));
  }

  /// Menghasilkan format pesan teks siap kirim ke pelanggan (FR-4.3)
  String buatPesanBagikan(CucianOrder order) {
    final jam = hitungEstimasiJam(order.jenisLayanan, order.beratKg);
    final target = hitungTargetSelesai(order.jenisLayanan, order.beratKg);
    final tgl = DateHelper.getTanggalLengkap(target);
    final jamStr =
        '${target.hour.toString().padLeft(2, '0')}:${target.minute.toString().padLeft(2, '0')}';

    return '''
*LAUNDRY KILAT - NOTIFIKASI ESTIMASI SELESAI*
Halo Kak *${order.namaPelanggan}*, cucian Anda telah kami terima di Laundry Kilat.

Rincian Order:
• Layanan: ${order.jenisLayanan.label}
• Berat Cucian: ${order.beratKg.toStringAsFixed(1)} kg
• Estimasi Waktu: ${jam.toStringAsFixed(0)} jam
• Perkiraan Selesai: $tgl jam $jamStr WIB

Terima kasih atas kepercayaannya. Pakaian Anda kami cuci bersih, rapi, dan wangi!
'''.trim();
  }

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
