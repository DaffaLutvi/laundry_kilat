import 'package:flutter/foundation.dart';
import '../models/jadwal_laundry.dart';
import '../models/cucian_order.dart';
import '../models/info_laundry.dart';
import '../models/profil_usaha.dart';
import '../models/layanan_harga.dart';
import '../models/karyawan.dart';
import '../models/user_account.dart';
import '../utils/date_helper.dart';

/// Lapisan Service: Sumber data lokal in-memory (tanpa backend).
/// Berfungsi sebagai penyedia data utama yang mudah diganti ke REST API/Database nantinya.
/// Menggunakan ChangeNotifier agar perubahan data mentah dapat disiarkan ke lapisan Repository.
class LocalDataService extends ChangeNotifier {
  final List<JadwalLaundry> _jadwalList = [];
  final List<CucianOrder> _cucianList = [];
  final List<InfoLaundry> _infoList = [];

  // Data Fase 4
  late ProfilUsaha _profilUsaha;
  final List<LayananHarga> _layananList = [];
  final List<Karyawan> _karyawanList = [];
  late UserAccount _userAccount;

  LocalDataService() {
    _initSampleData();
  }

  void _initSampleData() {
    final hariIni = DateHelper.getHariIni();
    final idxHariIni = DateHelper.daftarHari.indexOf(hariIni);
    final hariBesok =
        DateHelper.daftarHari[(idxHariIni + 1) % DateHelper.daftarHari.length];
    final hariLusa =
        DateHelper.daftarHari[(idxHariIni + 2) % DateHelper.daftarHari.length];

    // Minimal 6 data contoh JadwalLaundry (sebagian hari ini, sebagian hari lain)
    _jadwalList.addAll([
      JadwalLaundry(
        id: 'JDW-001',
        namaPelanggan: 'Ibu Siti Rahma',
        alamat: 'Jl. Melati No. 12, RT 02/05',
        hari: hariIni,
        jam: '08:00',
        jenisLayanan: JenisLayananJadwal.jemput,
      ),
      JadwalLaundry(
        id: 'JDW-002',
        namaPelanggan: 'Bapak Bambang',
        alamat: 'Perum Griya Asri Blok B4',
        hari: hariIni,
        jam: '09:30',
        jenisLayanan: JenisLayananJadwal.antar,
      ),
      JadwalLaundry(
        id: 'JDW-003',
        namaPelanggan: 'Ibu Dewi Lestari',
        alamat: 'Jl. Mawar Indah No. 5',
        hari: hariIni,
        jam: '11:00',
        jenisLayanan: JenisLayananJadwal.ambilDiToko,
      ),
      JadwalLaundry(
        id: 'JDW-004',
        namaPelanggan: 'Mas Dimas',
        alamat: 'Kost Podomoro Kamar 10',
        hari: hariIni,
        jam: '14:15',
        jenisLayanan: JenisLayananJadwal.jemput,
      ),
      JadwalLaundry(
        id: 'JDW-005',
        namaPelanggan: 'Mbak Rina',
        alamat: 'Apartemen Sentral Tower A Lt. 7',
        hari: hariIni,
        jam: '16:30',
        jenisLayanan: JenisLayananJadwal.antar,
      ),
      JadwalLaundry(
        id: 'JDW-006',
        namaPelanggan: 'Bapak Hendra',
        alamat: 'Jl. Kenanga No. 88',
        hari: hariBesok,
        jam: '09:00',
        jenisLayanan: JenisLayananJadwal.jemput,
      ),
      JadwalLaundry(
        id: 'JDW-007',
        namaPelanggan: 'Ibu Maya Santoso',
        alamat: 'Jl. Cempaka No. 15',
        hari: hariLusa,
        jam: '10:00',
        jenisLayanan: JenisLayananJadwal.antar,
      ),
    ]);

    // Minimal 6 data contoh CucianOrder (8 contoh: 5 aktif, 3 selesai -> 3 dari 8 selesai)
    _cucianList.addAll([
      const CucianOrder(
        id: 'CCN-001',
        namaPelanggan: 'Budi Santoso',
        beratKg: 4.5,
        jenisLayanan: JenisLayananCucian.cuciSetrika,
        isDone: false,
      ),
      const CucianOrder(
        id: 'CCN-002',
        namaPelanggan: 'Ibu Ani Suryani',
        beratKg: 3.0,
        jenisLayanan: JenisLayananCucian.cuciKering,
        isDone: false,
      ),
      const CucianOrder(
        id: 'CCN-003',
        namaPelanggan: 'Pak Joko',
        beratKg: 7.0,
        jenisLayanan: JenisLayananCucian.cuciSetrika,
        isDone: false,
      ),
      const CucianOrder(
        id: 'CCN-004',
        namaPelanggan: 'Mbak Citra',
        beratKg: 2.0,
        jenisLayanan: JenisLayananCucian.setrikaSaja,
        isDone: false,
      ),
      const CucianOrder(
        id: 'CCN-005',
        namaPelanggan: 'Kak Aldi',
        beratKg: 5.5,
        jenisLayanan: JenisLayananCucian.cuciKering,
        isDone: false,
      ),
      const CucianOrder(
        id: 'CCN-006',
        namaPelanggan: 'Ibu Ratna',
        beratKg: 6.0,
        jenisLayanan: JenisLayananCucian.cuciSetrika,
        isDone: true,
      ),
      const CucianOrder(
        id: 'CCN-007',
        namaPelanggan: 'Mas Gilang',
        beratKg: 3.5,
        jenisLayanan: JenisLayananCucian.setrikaSaja,
        isDone: true,
      ),
      const CucianOrder(
        id: 'CCN-008',
        namaPelanggan: 'Bapak Agus',
        beratKg: 4.0,
        jenisLayanan: JenisLayananCucian.cuciKering,
        isDone: true,
      ),
    ]);

    // Minimal 6 data contoh InfoLaundry
    _infoList.addAll([
      const InfoLaundry(
        id: 'INF-001',
        judul: 'Diskon 20% Pelanggan Baru',
        deskripsi:
            'Potongan 20% untuk cuci pertama minimal 5 kg. Masukkan kupon: BARUKILAT.',
        kategori: 'Promo',
        isPenting: true,
      ),
      const InfoLaundry(
        id: 'INF-002',
        judul: 'Paket Langganan Hemat Bulanan',
        deskripsi:
            'Paket 30 kg seharga Rp 180.000 (hemat Rp 30.000). Gratis antar-jemput 4 kali.',
        kategori: 'Paket',
        isPenting: true,
      ),
      const InfoLaundry(
        id: 'INF-003',
        judul: 'Layanan Kilat Super Cepat (3 Jam)',
        deskripsi:
            'Cucian selesai dalam 3 jam! Bersih, harum tahan lama, dan langsung siap pakai.',
        kategori: 'Layanan',
        isPenting: false,
      ),
      const InfoLaundry(
        id: 'INF-004',
        judul: 'Estimasi Pengerjaan Standar',
        deskripsi:
            'Cuci Setrika 24 jam. Cuci Kering 12 jam. Setrika Saja 8 jam.',
        kategori: 'Estimasi',
        isPenting: false,
      ),
      const InfoLaundry(
        id: 'INF-005',
        judul: 'Tips Merawat Serat Pakaian',
        deskripsi:
            'Pisahkan cucian luntur dan bahan rajut/katun agar pakaian tetap terjaga awet.',
        kategori: 'Tips',
        isPenting: false,
      ),
      const InfoLaundry(
        id: 'INF-006',
        judul: 'Promo Akhir Pekan Ceria',
        deskripsi:
            'Diskon 10% setiap hari Sabtu dan Minggu untuk semua paket Cuci Setrika.',
        kategori: 'Promo',
        isPenting: true,
      ),
    ]);

    // 4. Data Contoh Fase 4: Profil Usaha, Layanan & Harga, Karyawan, Akun
    _profilUsaha = const ProfilUsaha(
      namaUsaha: 'Laundry Kilat Sleman',
      alamat: 'Jl. Kaliurang KM 9.5 No. 18, Sleman, DI Yogyakarta',
      kontak: '0812-3456-7890',
      jamOperasional: '07.00 - 21.00 WIB (Setiap Hari)',
    );

    _layananList.addAll([
      const LayananHarga(
        id: 'LYN-001',
        namaLayanan: 'Cuci Setrika Reguler',
        hargaPerKg: 7000.0,
        estimasiJam: 24.0,
      ),
      const LayananHarga(
        id: 'LYN-002',
        namaLayanan: 'Cuci Kering Saja',
        hargaPerKg: 5000.0,
        estimasiJam: 12.0,
      ),
      const LayananHarga(
        id: 'LYN-003',
        namaLayanan: 'Setrika Rapi Saja',
        hargaPerKg: 4000.0,
        estimasiJam: 8.0,
      ),
      const LayananHarga(
        id: 'LYN-004',
        namaLayanan: 'Cuci Kilat Super Express',
        hargaPerKg: 12000.0,
        estimasiJam: 3.0,
      ),
    ]);

    _karyawanList.addAll([
      const Karyawan(
        id: 'KRY-001',
        nama: 'Agus Purnomo',
        posisi: 'Kurir Antar-Jemput',
        noTelepon: '0813-9876-5432',
        isAktif: true,
      ),
      const Karyawan(
        id: 'KRY-002',
        nama: 'Sri Wahyuni',
        posisi: 'Operator Setrika',
        noTelepon: '0857-1234-5678',
        isAktif: true,
      ),
      const Karyawan(
        id: 'KRY-003',
        nama: 'Bayu Pratama',
        posisi: 'Operator Cuci & Pengering',
        noTelepon: '0878-8765-4321',
        isAktif: true,
      ),
    ]);

    _userAccount = UserAccount(
      username: 'admin',
      namaLengkap: 'Ibu Nurhayati (Pemilik)',
      passwordHash: UserAccount.hashPassword('admin123'),
      isLoggedIn: true,
    );
  }

  // ===================== CRUD JADWAL =====================
  List<JadwalLaundry> getJadwalList() {
    return List.unmodifiable(_jadwalList);
  }

  void addJadwal(JadwalLaundry item) {
    _jadwalList.add(item);
    notifyListeners();
  }

  void updateJadwal(JadwalLaundry item) {
    final idx = _jadwalList.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _jadwalList[idx] = item;
      notifyListeners();
    }
  }

  void deleteJadwal(String id) {
    _jadwalList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ===================== CRUD & TOGGLE CUCIAN =====================
  List<CucianOrder> getCucianList() {
    return List.unmodifiable(_cucianList);
  }

  void addCucian(CucianOrder item) {
    _cucianList.add(item);
    notifyListeners();
  }

  void toggleCucianStatus(String id) {
    final idx = _cucianList.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _cucianList[idx];
      _cucianList[idx] = current.copyWith(isDone: !current.isDone);
      notifyListeners();
    }
  }

  void setCucianStatus(String id, bool isDone) {
    final idx = _cucianList.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _cucianList[idx];
      if (current.isDone != isDone) {
        _cucianList[idx] = current.copyWith(isDone: isDone);
        notifyListeners();
      }
    }
  }

  void updateCucian(CucianOrder item) {
    final idx = _cucianList.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _cucianList[idx] = item;
      notifyListeners();
    }
  }

  void deleteCucian(String id) {
    _cucianList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ===================== CRUD & TOGGLE INFO =====================
  List<InfoLaundry> getInfoList() {
    return List.unmodifiable(_infoList);
  }

  void addInfo(InfoLaundry item) {
    _infoList.add(item);
    notifyListeners();
  }

  void toggleInfoPenting(String id) {
    final idx = _infoList.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _infoList[idx];
      _infoList[idx] = current.copyWith(isPenting: !current.isPenting);
      notifyListeners();
    }
  }

  void updateInfo(InfoLaundry item) {
    final idx = _infoList.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _infoList[idx] = item;
      notifyListeners();
    }
  }

  void deleteInfo(String id) {
    _infoList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ===================== FASE 4: PROFIL USAHA =====================
  ProfilUsaha getProfilUsaha() {
    return _profilUsaha;
  }

  void updateProfilUsaha(ProfilUsaha profil) {
    _profilUsaha = profil;
    notifyListeners();
  }

  // ===================== FASE 4: LAYANAN & HARGA =====================
  List<LayananHarga> getLayananList() {
    return List.unmodifiable(_layananList);
  }

  void addLayanan(LayananHarga item) {
    _layananList.add(item);
    notifyListeners();
  }

  void updateLayanan(LayananHarga item) {
    final idx = _layananList.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _layananList[idx] = item;
      notifyListeners();
    }
  }

  void deleteLayanan(String id) {
    _layananList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ===================== FASE 4: KARYAWAN =====================
  List<Karyawan> getKaryawanList() {
    return List.unmodifiable(_karyawanList);
  }

  void addKaryawan(Karyawan item) {
    _karyawanList.add(item);
    notifyListeners();
  }

  void updateKaryawan(Karyawan item) {
    final idx = _karyawanList.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _karyawanList[idx] = item;
      notifyListeners();
    }
  }

  void toggleKaryawanStatus(String id) {
    final idx = _karyawanList.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final cur = _karyawanList[idx];
      _karyawanList[idx] = cur.copyWith(isAktif: !cur.isAktif);
      notifyListeners();
    }
  }

  void deleteKaryawan(String id) {
    _karyawanList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ===================== FASE 4: MASUK & AKUN =====================
  UserAccount getUserAccount() {
    return _userAccount;
  }

  bool login(String username, String password) {
    if (username.trim().toLowerCase() == _userAccount.username.toLowerCase() &&
        _userAccount.verifikasiPassword(password)) {
      _userAccount = _userAccount.copyWith(isLoggedIn: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _userAccount = _userAccount.copyWith(isLoggedIn: false);
    notifyListeners();
  }

  bool ubahPassword(String passwordLama, String passwordBaru) {
    if (_userAccount.verifikasiPassword(passwordLama)) {
      _userAccount = _userAccount.copyWith(
        passwordHash: UserAccount.hashPassword(passwordBaru),
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
