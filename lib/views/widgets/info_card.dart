import 'package:flutter/material.dart';
import '../../models/info_laundry.dart';

/// Lapisan View: Widget kartu untuk menampilkan Info & Promo.
/// Menampilkan judul, deskripsi, kategori, serta badge "Penting" dengan jelas.
class InfoCard extends StatelessWidget {
  final InfoLaundry info;
  final VoidCallback? onTogglePenting;
  final VoidCallback? onDelete;

  const InfoCard({
    super.key,
    required this.info,
    this.onTogglePenting,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: info.isPenting
              ? colorScheme.primary.withAlpha(160)
              : colorScheme.outlineVariant.withAlpha(100),
          width: info.isPenting ? 1.5 : 1.0,
        ),
      ),
      color: info.isPenting
          ? colorScheme.primaryContainer.withAlpha(40)
          : colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Baris: Kategori & Badge Penting
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    info.kategori,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                if (info.isPenting)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.campaign_rounded,
                          size: 13,
                          color: colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'PENTING',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                if (onTogglePenting != null)
                  IconButton(
                    icon: Icon(
                      info.isPenting
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: info.isPenting
                          ? Colors.amber.shade700
                          : colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                    tooltip: info.isPenting
                        ? 'Tandai Biasa'
                        : 'Tandai Penting',
                    onPressed: onTogglePenting,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Judul Info
            Text(
              info.judul,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Deskripsi Info
            Text(
              info.deskripsi,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
