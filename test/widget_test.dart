import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_cepat/main.dart';

void main() {
  testWidgets('Laundry Kilat smoke test - Beranda tampil dengan benar', (WidgetTester tester) async {
    // Set ukuran layar agar muat tampilan vertikal
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build app dan render frame
    await tester.pumpWidget(const LaundryKilatApp());
    await tester.pumpAndSettle();

    // Verifikasi judul aplikasi muncul di Beranda
    expect(find.text('Laundry Kilat'), findsOneWidget);

    // Verifikasi teks ringkasan selesai muncul
    expect(find.textContaining('Ringkasan Selesai'), findsOneWidget);

    // Verifikasi bagian Jadwal Hari Ini dan Pekerjaan Hari Ini muncul
    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(find.text('Pekerjaan Hari Ini'), findsOneWidget);

    // Verifikasi tombol navigasi Material 3
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Jadwal'), findsOneWidget);
    expect(find.text('Checklist'), findsOneWidget);
    expect(find.text('Info & Promo'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });
}
