import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_cepat/main.dart';
import 'package:laundry_cepat/models/jadwal_laundry.dart';

void main() {
  testWidgets('Laundry Kilat - Fase 1: Beranda tampil dengan benar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LaundryKilatApp());
    await tester.pumpAndSettle();

    expect(find.text('Laundry Kilat'), findsOneWidget);
    expect(find.textContaining('Ringkasan Selesai'), findsOneWidget);
    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(find.text('Pekerjaan Hari Ini'), findsOneWidget);

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Jadwal'), findsOneWidget);
    expect(find.text('Checklist'), findsOneWidget);
    expect(find.text('Info & Promo'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });

  testWidgets('Laundry Kilat - Fase 2: Jadwal, Filter SegmentedButton & Dialog Form Validasi', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LaundryKilatApp());
    await tester.pumpAndSettle();

    // Navigasi ke tab 'Jadwal'
    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();

    // Verifikasi SegmentedButton filter layanan
    final segmentedFinder = find.byType(SegmentedButton<JenisLayananJadwal?>);
    expect(segmentedFinder, findsOneWidget);
    expect(find.descendant(of: segmentedFinder, matching: find.text('Semua')), findsOneWidget);
    expect(find.descendant(of: segmentedFinder, matching: find.text('Antar')), findsOneWidget);
    expect(find.descendant(of: segmentedFinder, matching: find.text('Jemput')), findsOneWidget);
    expect(find.descendant(of: segmentedFinder, matching: find.text('Ambil di Toko')), findsOneWidget);

    // Filter dengan memilih 'Antar'
    await tester.tap(find.descendant(of: segmentedFinder, matching: find.text('Antar')));
    await tester.pumpAndSettle();

    // Buka formulir Tambah Jadwal via FAB
    await tester.tap(find.text('Tambah Jadwal'));
    await tester.pumpAndSettle();

    // Verifikasi formulir tambah terbuka
    expect(find.text('Tambah Jadwal Baru'), findsOneWidget);
    expect(find.text('Nama Pelanggan *'), findsOneWidget);
    expect(find.text('Alamat Pengambilan / Pengantaran *'), findsOneWidget);

    // Coba tekan Simpan tanpa mengisi data (Uji Validasi Form FR-2.2)
    final submitButton = find.widgetWithText(FilledButton, 'Tambah Jadwal');
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verifikasi pesan validasi muncul
    expect(find.text('Nama pelanggan wajib diisi'), findsOneWidget);
    expect(find.text('Alamat wajib diisi'), findsOneWidget);

    // Tutup formulir
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
  });
}
