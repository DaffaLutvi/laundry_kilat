import 'package:flutter/material.dart';

/// Lapisan View: Layar Info & Promo (Fase 3).
/// Menampilkan daftar promo, filter kategori chip, dan label penting.
class InfoPromoPage extends StatelessWidget {
  const InfoPromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Info & Promo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.campaign_rounded,
                size: 64,
                color: colorScheme.primary.withAlpha(180),
              ),
              const SizedBox(height: 16),
              Text(
                'Modul Info & Promo',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Akan diimplementasikan pada Fase 3 sesuai alur pengerjaan bertahap.',
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
