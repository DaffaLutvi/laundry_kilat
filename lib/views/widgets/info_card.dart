import 'package:flutter/material.dart';

import '../../models/info_laundry.dart';
import '../../theme/app_theme.dart';

/// Lapisan View: Widget kartu untuk menampilkan Info & Promo.
/// Menampilkan label "Penting" yang mencolok (FR-5.3), kartu dengan radius 16,
/// bayangan tipis, padding kelipatan 8, dan target tombol minimal 48dp.
class InfoCard extends StatelessWidget {
  final InfoLaundry info;
  final VoidCallback? onTogglePenting;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const InfoCard({
    super.key,
    required this.info,
    this.onTogglePenting,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: info.isPenting ? const Color(0xFFFFF8F8) : AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: info.isPenting
              ? AppTheme.urgentRed.withAlpha(140)
              : AppTheme.outlineBorder,
          width: info.isPenting ? 1.4 : 1.0,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Baris: Kategori & Badge Penting Mencolok
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Badge Kategori
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          info.kategori,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),

                      // Badge PENTING (Mencolok sesuai FR-5.3)
                      if (info.isPenting)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.urgentRed,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.urgentRed.withAlpha(50),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.campaign_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'PENTING',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Tombol Aksi (Target sentuh minimal 48dp)
                if (onShare != null)
                  SizedBox(
                    width: 44,
                    height: 48,
                    child: IconButton(
                      icon: const Icon(Icons.share_outlined, size: 19),
                      tooltip: 'Bagikan Info',
                      color: AppTheme.primaryColor,
                      onPressed: onShare,
                    ),
                  ),

                if (onTogglePenting != null)
                  SizedBox(
                    width: 44,
                    height: 48,
                    child: IconButton(
                      icon: Icon(
                        info.isPenting
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: info.isPenting
                            ? Colors.amber.shade700
                            : AppTheme.textSecondary,
                        size: 22,
                      ),
                      tooltip: info.isPenting
                          ? 'Tandai Biasa'
                          : 'Tandai Penting',
                      onPressed: onTogglePenting,
                    ),
                  ),

                if (onDelete != null)
                  SizedBox(
                    width: 44,
                    height: 48,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 19,
                        color: colorScheme.error.withAlpha(180),
                      ),
                      tooltip: 'Hapus Info',
                      onPressed: onDelete,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Judul Info
            Text(
              info.judul,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            // Deskripsi Info
            Text(
              info.deskripsi,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
