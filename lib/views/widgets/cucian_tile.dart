import 'package:flutter/material.dart';

import '../../models/cucian_order.dart';
import '../../theme/app_theme.dart';

/// Lapisan View: Widget tile untuk item order cucian.
/// Menggunakan AnimatedContainer untuk transisi halus saat item dicentang (FR-3.2),
/// item selesai berwarna hijau lembut dengan teks dicoret, ikon & warna spesifik per layanan,
/// serta padding kelipatan 8 dan target sentuh tombol minimal 48dp.
class CucianTile extends StatelessWidget {
  final CucianOrder order;
  final ValueChanged<bool?>? onToggle;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const CucianTile({
    super.key,
    required this.order,
    this.onToggle,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color serviceBg;
    Color serviceFg;
    IconData serviceIcon;

    switch (order.jenisLayanan) {
      case JenisLayananCucian.cuciKering:
        serviceBg = AppTheme.cuciKeringBg;
        serviceFg = AppTheme.cuciKeringColor;
        serviceIcon = Icons.dry_cleaning_rounded;
        break;
      case JenisLayananCucian.cuciSetrika:
        serviceBg = AppTheme.cuciSetrikaBg;
        serviceFg = AppTheme.cuciSetrikaColor;
        serviceIcon = Icons.iron_rounded;
        break;
      case JenisLayananCucian.setrikaSaja:
        serviceBg = AppTheme.setrikaSajaBg;
        serviceFg = AppTheme.setrikaSajaColor;
        serviceIcon = Icons.checkroom_rounded;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: order.isDone ? AppTheme.successGreenBg : AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: order.isDone
              ? AppTheme.successGreenBorder
              : AppTheme.outlineBorder,
          width: order.isDone ? 1.4 : 1.0,
        ),
        boxShadow: order.isDone ? null : AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            // Checkbox status selesai (Target sentuh luas 48dp)
            SizedBox(
              width: 48,
              height: 48,
              child: Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: order.isDone,
                  onChanged: onToggle,
                  activeColor: AppTheme.successGreen,
                  checkColor: Colors.white,
                  side: BorderSide(
                    color: order.isDone
                        ? AppTheme.successGreen
                        : AppTheme.textSecondary.withAlpha(160),
                    width: 1.8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Detail Order
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.namaPelanggan,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: order.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: AppTheme.successGreen,
                            color: order.isDone
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (order.isDone)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.successGreen.withAlpha(80),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 12,
                                color: AppTheme.successGreen,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Tuntas',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Badge Berat
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.scale_rounded,
                              size: 13,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${order.beratKg.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge Jenis Layanan dengan Ikon
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: serviceBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(serviceIcon, size: 13, color: serviceFg),
                            const SizedBox(width: 4),
                            Text(
                              order.jenisLayanan.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: serviceFg,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tombol Bagikan Estimasi (Target sentuh minimal 48dp)
            if (onShare != null)
              SizedBox(
                width: 44,
                height: 48,
                child: IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: AppTheme.primaryColor,
                    size: 19,
                  ),
                  tooltip: 'Bagikan Estimasi ke Pelanggan',
                  onPressed: onShare,
                ),
              ),

            // Tombol Hapus Order
            if (onDelete != null)
              SizedBox(
                width: 44,
                height: 48,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colorScheme.error.withAlpha(190),
                    size: 19,
                  ),
                  tooltip: 'Hapus Order',
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
