import 'package:flutter/material.dart';
import '../../models/jadwal_laundry.dart';

/// Lapisan View: Widget kartu untuk menampilkan informasi JadwalLaundry.
/// Digunakan di layar Beranda dan layar Jadwal Antar-Jemput.
class JadwalCard extends StatelessWidget {
  final JadwalLaundry jadwal;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const JadwalCard({
    super.key,
    required this.jadwal,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
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
        badgeBg = Colors.amber.shade100;
        badgeFg = Colors.amber.shade900;
        serviceIcon = Icons.call_received_rounded;
        break;
      case JenisLayananJadwal.antar:
        badgeBg = Colors.blue.shade100;
        badgeFg = Colors.blue.shade900;
        serviceIcon = Icons.local_shipping_outlined;
        break;
      case JenisLayananJadwal.ambilDiToko:
        badgeBg = Colors.teal.shade100;
        badgeFg = Colors.teal.shade900;
        serviceIcon = Icons.storefront_outlined;
        break;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(120),
        ),
      ),
      color: colorScheme.surfaceContainerLowest,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge Jam
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    jadwal.jam,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

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
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Badge Jenis Layanan
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
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
                  const SizedBox(height: 6),

                  // Alamat Pelanggan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 15,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          jadwal.alamat,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
