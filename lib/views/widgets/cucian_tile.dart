import 'package:flutter/material.dart';
import '../../models/cucian_order.dart';

/// Lapisan View: Widget tile untuk menampilkan item order cucian.
/// Menampilkan nama pelanggan, berat (kg), jenis layanan, dan checkbox status selesai.
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
    switch (order.jenisLayanan) {
      case JenisLayananCucian.cuciKering:
        serviceBg = Colors.blue.shade50;
        serviceFg = Colors.blue.shade800;
        break;
      case JenisLayananCucian.cuciSetrika:
        serviceBg = Colors.purple.shade50;
        serviceFg = Colors.purple.shade800;
        break;
      case JenisLayananCucian.setrikaSaja:
        serviceBg = Colors.orange.shade50;
        serviceFg = Colors.orange.shade800;
        break;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: order.isDone
              ? colorScheme.outlineVariant.withAlpha(60)
              : colorScheme.outlineVariant.withAlpha(120),
        ),
      ),
      color: order.isDone
          ? colorScheme.surfaceContainerLow.withAlpha(150)
          : colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Checkbox status selesai
            Checkbox(
              value: order.isDone,
              onChanged: onToggle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 8),

            // Detail Order
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.namaPelanggan,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: order.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: order.isDone
                          ? colorScheme.onSurface.withAlpha(120)
                          : colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      // Badge Berat
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.scale_rounded,
                              size: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${order.beratKg.toStringAsFixed(1)} kg',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge Jenis Layanan
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: serviceBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order.jenisLayanan.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: serviceFg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (onShare != null)
              IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Bagikan Estimasi ke Pelanggan',
                onPressed: onShare,
              ),

            if (onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error.withAlpha(180),
                  size: 20,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
