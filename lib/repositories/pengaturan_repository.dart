import 'package:flutter/foundation.dart';
import '../models/profil_usaha.dart';
import '../models/layanan_harga.dart';
import '../models/karyawan.dart';
import '../models/user_account.dart';
import '../services/local_data_service.dart';

/// Lapisan Repository: Pintu akses tunggal untuk Profil Usaha, Layanan & Harga,
/// Data Karyawan, dan Autentikasi / Akun Pengelola (Fase 4).
class PengaturanRepository extends ChangeNotifier {
  final LocalDataService _service;

  PengaturanRepository(this._service) {
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

  // Profil Usaha
  ProfilUsaha getProfilUsaha() => _service.getProfilUsaha();
  Future<void> updateProfilUsaha(ProfilUsaha profil) async {
    _service.updateProfilUsaha(profil);
  }

  // Layanan & Harga
  List<LayananHarga> getLayananList() => _service.getLayananList();
  Future<void> addLayanan(LayananHarga item) async {
    _service.addLayanan(item);
  }

  Future<void> updateLayanan(LayananHarga item) async {
    _service.updateLayanan(item);
  }

  Future<void> deleteLayanan(String id) async {
    _service.deleteLayanan(id);
  }

  // Karyawan
  List<Karyawan> getKaryawanList() => _service.getKaryawanList();
  Future<void> addKaryawan(Karyawan item) async {
    _service.addKaryawan(item);
  }

  Future<void> updateKaryawan(Karyawan item) async {
    _service.updateKaryawan(item);
  }

  Future<void> toggleKaryawanStatus(String id) async {
    _service.toggleKaryawanStatus(id);
  }

  Future<void> deleteKaryawan(String id) async {
    _service.deleteKaryawan(id);
  }

  // Masuk & Akun
  UserAccount getUserAccount() => _service.getUserAccount();
  bool login(String username, String password) =>
      _service.login(username, password);
  void logout() => _service.logout();
  bool ubahPassword(String passwordLama, String passwordBaru) =>
      _service.ubahPassword(passwordLama, passwordBaru);
}
