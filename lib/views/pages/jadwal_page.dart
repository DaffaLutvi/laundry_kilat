import 'package:flutter/material.dart';

/// Lapisan View: Layar Jadwal Antar-Jemput (Fase 2).
/// Menampilkan daftar jadwal lengkap dengan filter SegmentedButton dan form tambah/ubah.
class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Antar-Jemput'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 64,
                color: colorScheme.primary.withAlpha(180),
              ),
              const SizedBox(height: 16),
              Text(
                'Modul Jadwal Antar-Jemput',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Akan diimplementasikan pada Fase 2 sesuai alur pengerjaan bertahap.',
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
