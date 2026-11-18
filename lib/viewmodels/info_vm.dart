import 'package:flutter/foundation.dart';
import '../models/info_laundry.dart';
import '../repositories/info_repository.dart';

/// Lapisan ViewModel: Mengelola state layar Info & Promo (Fase 3).
/// Bertanggung jawab atas daftar info, penyaringan kategori chip, dan label penting.
class InfoViewModel extends ChangeNotifier {
  final InfoRepository repository;

  String _selectedKategori = 'Semua';
  bool _isLoading = false;
  String? _errorMessage;

  InfoViewModel({required this.repository}) {
    repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedKategori => _selectedKategori;

  List<String> get kategoriList => repository.getKategoriList();

  List<InfoLaundry> get infoList =>
      repository.getInfoByKategori(_selectedKategori);

  void selectKategori(String kategori) {
    _selectedKategori = kategori;
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

  Future<void> togglePenting(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.togglePenting(id);
    } catch (e) {
      _errorMessage = 'Gagal mengubah status penting: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addInfo(InfoLaundry item) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.addInfo(item);
    } catch (e) {
      _errorMessage = 'Gagal menambah info: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteInfo(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.deleteInfo(id);
    } catch (e) {
      _errorMessage = 'Gagal menghapus info: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String buatPesanBagikan(InfoLaundry info) {
    return '''
*LAUNDRY KILAT - ${info.kategori.toUpperCase()}*
✨ *${info.judul}* ✨

${info.deskripsi}

Hubungi Laundry Kilat sekarang untuk info dan pemesanan antar-jemput!
'''.trim();
  }

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
