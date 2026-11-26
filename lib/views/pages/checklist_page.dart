import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/cucian_order.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/checklist_vm.dart';
import '../widgets/cucian_tile.dart';
import '../widgets/cucian_form_sheet.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/pengaturan_estimasi_dialog.dart';

/// Lapisan View: Layar Checklist Cucian & Estimasi Selesai (Fase 3).
/// Menampilkan:
/// 1. Daftar cucian aktif (FR-3.1)
/// 2. Centang untuk isDone = true (FR-3.2)
/// 3. Bagian Selesai dengan opsi membatalkan centang (FR-3.3)
/// 4. Estimasi selesai otomatis & atur lama pengerjaan (FR-4.1, FR-4.2)
/// 5. Tombol bagikan via share bawaan ponsel (FR-4.3)
class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  void _bukaFormCucian(BuildContext context) {
    final vm = context.read<ChecklistViewModel>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return CucianFormSheet(
          onHitungEstimasiJam: (layanan, berat) {
            return vm.hitungEstimasiJam(layanan, berat);
          },
          onSave: (order, shareLangsung) async {
            await vm.addCucian(order);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Order "${order.namaPelanggan}" berhasil dicatat',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );

              if (shareLangsung) {
                final pesan = vm.buatPesanBagikan(order);
                await SharePlus.instance.share(
                  ShareParams(
                    text: pesan,
                    subject:
                        'Estimasi Selesai Laundry Kilat - ${order.namaPelanggan}',
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  void _bukaPengaturanEstimasi(BuildContext context) {
    final vm = context.read<ChecklistViewModel>();

    showDialog<void>(
      context: context,
      builder: (ctx) => PengaturanEstimasiDialog(
        initialCuciSetrika: vm.jamCuciSetrika,
        initialCuciKering: vm.jamCuciKering,
        initialSetrikaSaja: vm.jamSetrikaSaja,
        initialKilat: vm.jamKilat,
        onSave:
            ({
              required double cuciSetrika,
              required double cuciKering,
              required double setrikaSaja,
              required double kilat,
            }) {
              vm.updatePengaturanLamaPengerjaan(
                cuciSetrika: cuciSetrika,
                cuciKering: cuciKering,
                setrikaSaja: setrikaSaja,
                kilat: kilat,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Pengaturan estimasi lama pengerjaan berhasil disimpan',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
      ),
    );
  }

  Future<void> _bagikanEstimasi(BuildContext context, CucianOrder order) async {
    final vm = context.read<ChecklistViewModel>();
    final pesan = vm.buatPesanBagikan(order);
    await SharePlus.instance.share(
      ShareParams(
        text: pesan,
        subject: 'Estimasi Selesai Laundry Kilat - ${order.namaPelanggan}',
      ),
    );
  }

  Future<void> _konfirmasiHapus(BuildContext context, CucianOrder order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Order'),
        content: Text(
          'Hapus order cucian untuk "${order.namaPelanggan}" (${order.beratKg} kg)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ChecklistViewModel>().deleteCucian(order.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order "${order.namaPelanggan}" telah dihapus'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist Cucian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Atur Lama Pengerjaan Standar',
            onPressed: () => _bukaPengaturanEstimasi(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
              tooltip: 'Catat Cucian',
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                foregroundColor: AppTheme.primaryColor,
              ),
              onPressed: () => _bukaFormCucian(context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaFormCucian(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Catat Cucian'),
      ),
      body: Consumer<ChecklistViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      vm.errorMessage!,
                      style: TextStyle(color: colorScheme.error),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: vm.refresh,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final aktif = vm.cucianAktif;
          final selesai = vm.cucianSelesai;

          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 84, // Ruang untuk FAB
              ),
              children: [
                // Info Banner Ringkas Bergaya Modern
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.primaryColor.withAlpha(40),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Centang cucian untuk memindahkannya ke "Selesai". Tap icon share untuk kirim estimasi ke pelanggan.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.onPrimaryContainer,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 1. BAGIAN CUCIAN AKTIF (FR-3.1)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.pending_actions_rounded,
                        size: 18,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cucian Aktif (Proses)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${aktif.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: aktif.isEmpty
                      ? const EmptyStateWidget(
                          key: ValueKey('active-empty'),
                          icon: Icons.local_laundry_service_outlined,
                          title: 'Belum ada cucian aktif',
                          subtitle:
                              'Cucian yang perlu diproses akan muncul di sini.',
                        )
                      : Column(
                          key: ValueKey(
                            'active-${aktif.map((order) => order.id).join(',')}',
                          ),
                          children: aktif
                              .map(
                                (order) => CucianTile(
                                  order: order,
                                  onToggle: (_) => vm.toggleSelesai(order.id),
                                  onShare: () =>
                                      _bagikanEstimasi(context, order),
                                  onDelete: () =>
                                      _konfirmasiHapus(context, order),
                                ),
                              )
                              .toList(),
                        ),
                ),

                const SizedBox(height: 24),

                // 2. BAGIAN SELESAI (FR-3.3)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreenBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                        color: AppTheme.successGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Selesai',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${selesai.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Cucian yang telah selesai dicuci & disetrika. Buka centang jika ingin membatalkan.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: selesai.isEmpty
                      ? const EmptyStateWidget(
                          key: ValueKey('complete-empty'),
                          icon: Icons.check_circle_outline_rounded,
                          title: 'Belum ada cucian selesai',
                          subtitle:
                              'Cucian yang sudah ditandai selesai akan muncul di sini.',
                          iconColor: AppTheme.successGreen,
                        )
                      : Column(
                          key: ValueKey(
                            'complete-${selesai.map((order) => order.id).join(',')}',
                          ),
                          children: selesai
                              .map(
                                (order) => CucianTile(
                                  order: order,
                                  onToggle: (_) => vm.toggleSelesai(order.id),
                                  onShare: () =>
                                      _bagikanEstimasi(context, order),
                                  onDelete: () =>
                                      _konfirmasiHapus(context, order),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
