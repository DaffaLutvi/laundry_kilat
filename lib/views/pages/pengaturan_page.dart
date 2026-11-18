import 'package:flutter/material.dart';

/// Lapisan View: Layar Pengaturan Usaha, Masuk & Akun (Fase 4).
/// Mengelola profil usaha, layanan & harga, karyawan, serta autentikasi/akun.
class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Usaha'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.store_rounded,
                size: 64,
                color: colorScheme.primary.withAlpha(180),
              ),
              const SizedBox(height: 16),
              Text(
                'Modul Pengaturan Usaha & Akun',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Akan diimplementasikan pada Fase 4 sesuai alur pengerjaan bertahap.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
