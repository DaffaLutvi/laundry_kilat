import 'package:flutter/material.dart';

import '../../models/jadwal_laundry.dart';
import '../../theme/app_theme.dart';

/// Lapisan View: Widget kartu untuk menampilkan informasi JadwalLaundry.
/// Menampilkan ikon dan warna spesifik per jenis layanan (Antar, Jemput, Ambil di Toko),
/// sudut membulat 16, bayangan tipis, dan padding kelipatan 8.
class JadwalCard extends StatelessWidget {
  final JadwalLaundry jadwal;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool showHari;

  const JadwalCard({
    super.key,
    required this.jadwal,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
    this.showHari = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeBg;
    Color badgeFg;
    IconData serviceIcon;

    switch (jadwal.jenisLayanan) {
      case JenisLayananJadwal.jemput:
        badgeBg = AppTheme.jemputBg;
        badgeFg = AppTheme.jemputColor;
        serviceIcon = Icons.call_received_rounded;
        break;
      case JenisLayananJadwal.antar:
        badgeBg = AppTheme.antarBg;
        badgeFg = AppTheme.antarColor;
        serviceIcon = Icons.local_shipping_rounded;
        break;
      case JenisLayananJadwal.ambilDiToko:
        badgeBg = AppTheme.ambilTokoBg;
        badgeFg = AppTheme.ambilTokoColor;
        serviceIcon = Icons.storefront_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge Jam & Hari
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jadwal.jam,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  if (showHari) ...[
                    const SizedBox(height: 2),
                    Text(
                      jadwal.hari,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark.withAlpha(200),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Informasi Utama
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          jadwal.namaPelanggan,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge Jenis Layanan
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(serviceIcon, size: 14, color: badgeFg),
                            const SizedBox(width: 4),
                            Text(
                              jadwal.jenisLayanan.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: badgeFg,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Alamat Pelanggan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 15,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          jadwal.alamat,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Aksi Ubah & Hapus (jika diaktifkan)
                  if (showActions) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onEdit != null)
                          TextButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text('Ubah'),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(60, 48),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        if (onDelete != null)
                          TextButton.icon(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 16,
                              color: colorScheme.error,
                            ),
                            label: Text(
                              'Hapus',
                              style: TextStyle(color: colorScheme.error),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(60, 48),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
