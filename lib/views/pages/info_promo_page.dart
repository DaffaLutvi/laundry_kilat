import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/info_laundry.dart';
import '../../viewmodels/info_vm.dart';
import '../widgets/info_card.dart';
import '../widgets/info_form_sheet.dart';
import '../widgets/empty_state_widget.dart';

/// Lapisan View: Layar Info & Promo (Fase 3 - Fitur Buatan Sendiri).
/// Menampilkan:
/// 1. Daftar InfoLaundry dengan filter kategori chip (FR-5.1, FR-5.2)
/// 2. Prioritas label "Penting" dan pengurutan teratas (FR-5.3)
/// 3. Tambah info baru & bagikan info via share ponsel
class InfoPromoPage extends StatelessWidget {
  const InfoPromoPage({super.key});

  void _bukaFormInfo(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return InfoFormSheet(
          availableCategories: vm.kategoriList,
          onSave: (newItem) async {
            await vm.addInfo(newItem);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Info "${newItem.judul}" berhasil ditambahkan'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _bagikanInfo(BuildContext context, InfoLaundry info) async {
    final vm = context.read<InfoViewModel>();
    final pesan = vm.buatPesanBagikan(info);
    await SharePlus.instance.share(
      ShareParams(
        text: pesan,
        subject: 'Info & Promo Laundry Kilat - ${info.judul}',
      ),
    );
  }

  Future<void> _konfirmasiHapus(BuildContext context, InfoLaundry info) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Info & Promo'),
        content: Text('Apakah Anda yakin ingin menghapus "${info.judul}"?'),
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
      await context.read<InfoViewModel>().deleteInfo(info.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Info "${info.judul}" telah dihapus'),
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
        title: const Text('Info & Promo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Tambah Info & Promo',
            onPressed: () => _bukaFormInfo(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaFormInfo(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Info'),
      ),
      body: Consumer<InfoViewModel>(
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

          final list = vm.infoList;
          final categories = vm.kategoriList;

          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                const SizedBox(height: 8),

                // 1. FILTER KATEGORI (FR-5.2)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: categories.map((kategori) {
                      final isSelected = vm.selectedKategori == kategori;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(kategori),
                          selected: isSelected,
                          onSelected: (_) {
                            vm.selectKategori(kategori);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle Info & Badge
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Menampilkan ${list.length} informasi',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Penting di atas',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // 2. DAFTAR INFO & PROMO (FR-5.1, FR-5.3)
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: EmptyStateWidget(
                                icon: Icons.campaign_outlined,
                                title: 'Tidak ada info ditemukan',
                                subtitle:
                                    'Belum ada info untuk kategori "${vm.selectedKategori}".',
                                actionLabel: 'Buat Info Baru',
                                onAction: () => _bukaFormInfo(context),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 80, // Ruang untuk FAB
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final info = list[index];
                            return InfoCard(
                              info: info,
                              onTogglePenting: () => vm.togglePenting(info.id),
                              onShare: () => _bagikanInfo(context, info),
                              onDelete: () => _konfirmasiHapus(context, info),
                            );
                          },
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
