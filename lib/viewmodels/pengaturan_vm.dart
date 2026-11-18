import 'package:flutter/foundation.dart';
import '../models/profil_usaha.dart';
import '../models/layanan_harga.dart';
import '../models/karyawan.dart';
import '../models/user_account.dart';
import '../repositories/pengaturan_repository.dart';

/// Lapisan ViewModel: Mengelola state layar Pengaturan Usaha, Masuk & Akun (Fase 4).
/// Mengatur profil usaha, daftar layanan/harga per kg, data karyawan, dan autentikasi.
class PengaturanViewModel extends ChangeNotifier {
  final PengaturanRepository repository;

  bool _isLoading = false;
  String? _errorMessage;

  PengaturanViewModel({required this.repository}) {
    repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfilUsaha get profilUsaha => repository.getProfilUsaha();
  List<LayananHarga> get layananList => repository.getLayananList();
  List<Karyawan> get karyawanList => repository.getKaryawanList();
  UserAccount get userAccount => repository.getUserAccount();
  bool get isLoggedIn => userAccount.isLoggedIn;

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isLoading = false;
    notifyListeners();
  }

  // Profil Usaha (FR-6.1)
  Future<void> updateProfil(ProfilUsaha profil) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.updateProfilUsaha(profil);
    } catch (e) {
      _errorMessage = 'Gagal menyimpan profil: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Layanan & Harga (FR-6.2)
  Future<void> addLayanan(LayananHarga item) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.addLayanan(item);
    } catch (e) {
      _errorMessage = 'Gagal menambah layanan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLayanan(LayananHarga item) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.updateLayanan(item);
    } catch (e) {
      _errorMessage = 'Gagal mengubah layanan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteLayanan(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.deleteLayanan(id);
    } catch (e) {
      _errorMessage = 'Gagal menghapus layanan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Karyawan (FR-6.3)
  Future<void> addKaryawan(Karyawan item) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.addKaryawan(item);
    } catch (e) {
      _errorMessage = 'Gagal menambah karyawan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateKaryawan(Karyawan item) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.updateKaryawan(item);
    } catch (e) {
      _errorMessage = 'Gagal mengubah data karyawan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleKaryawanStatus(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.toggleKaryawanStatus(id);
    } catch (e) {
      _errorMessage = 'Gagal mengubah status karyawan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteKaryawan(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.deleteKaryawan(id);
    } catch (e) {
      _errorMessage = 'Gagal menghapus karyawan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Masuk, Keluar, Ubah Kata Sandi (FR-7.1, FR-7.2, FR-7.3)
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    final success = repository.login(username, password);
    if (!success) {
      _errorMessage = 'Username atau kata sandi salah. Silakan coba lagi.';
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    repository.logout();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> ubahKataSandi(String passwordLama, String passwordBaru) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 200));
    final success = repository.ubahPassword(passwordLama, passwordBaru);
    if (!success) {
      _errorMessage = 'Kata sandi lama tidak sesuai.';
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
