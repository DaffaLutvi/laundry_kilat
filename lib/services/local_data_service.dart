import 'package:flutter/foundation.dart';
import '../models/jadwal_laundry.dart';
import '../models/cucian_order.dart';
import '../models/info_laundry.dart';
import '../utils/date_helper.dart';

/// Lapisan Service: Sumber data lokal in-memory (tanpa backend).
/// Berfungsi sebagai penyedia data utama yang mudah diganti ke REST API/Database nantinya.
/// Menggunakan ChangeNotifier agar perubahan data mentah dapat disiarkan ke lapisan Repository.
class LocalDataService extends ChangeNotifier {
  final List<JadwalLaundry> _jadwalList = [];
  final List<CucianOrder> _cucianList = [];
  final List<InfoLaundry> _infoList = [];

  LocalDataService() {
    _initSampleData();
  }

  void _initSampleData() {
    final hariIni = DateHelper.getHariIni();
    final idxHariIni = DateHelper.daftarHari.indexOf(hariIni);
    final hariBesok = DateHelper.daftarHari[(idxHariIni + 1) % DateHelper.daftarHari.length];
    final hariLusa = DateHelper.daftarHari[(idxHariIni + 2) % DateHelper.daftarHari.length];

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
        deskripsi: 'Potongan 20% untuk cuci pertama minimal 5 kg. Masukkan kupon: BARUKILAT.',
        kategori: 'Promo',
        isPenting: true,
      ),
      const InfoLaundry(
        id: 'INF-002',
        judul: 'Paket Langganan Hemat Bulanan',
        deskripsi: 'Paket 30 kg seharga Rp 180.000 (hemat Rp 30.000). Gratis antar-jemput 4 kali.',
        kategori: 'Paket',
        isPenting: true,
      ),
      const InfoLaundry(
        id: 'INF-003',
        judul: 'Layanan Kilat Super Cepat (3 Jam)',
        deskripsi: 'Cucian selesai dalam 3 jam! Bersih, harum tahan lama, dan langsung siap pakai.',
        kategori: 'Layanan',
        isPenting: false,
      ),
      const InfoLaundry(
        id: 'INF-004',
        judul: 'Estimasi Pengerjaan Standar',
        deskripsi: 'Cuci Setrika 24 jam. Cuci Kering 12 jam. Setrika Saja 8 jam.',
        kategori: 'Estimasi',
        isPenting: false,
      ),
      const InfoLaundry(
        id: 'INF-005',
        judul: 'Tips Merawat Serat Pakaian',
        deskripsi: 'Pisahkan cucian luntur dan bahan rajut/katun agar pakaian tetap terjaga awet.',
        kategori: 'Tips',
        isPenting: false,
      ),
      const InfoLaundry(
        id: 'INF-006',
        judul: 'Promo Akhir Pekan Ceria',
        deskripsi: 'Diskon 10% setiap hari Sabtu dan Minggu untuk semua paket Cuci Setrika.',
        kategori: 'Promo',
        isPenting: true,
      ),
    ]);
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
}
