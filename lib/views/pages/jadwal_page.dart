import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/jadwal_laundry.dart';
import '../../utils/date_helper.dart';
import '../../viewmodels/jadwal_vm.dart';
import '../widgets/jadwal_card.dart';
import '../widgets/jadwal_form_sheet.dart';
import '../widgets/empty_state_widget.dart';

/// Lapisan View: Layar Jadwal Antar-Jemput (Fase 2).
/// Menampilkan:
/// 1. Filter SegmentedButton jenis layanan (Semua, Antar, Jemput, Ambil di Toko) (FR-2.1)
/// 2. Filter hari (Semua, Hari Ini, dan hari-hari lainnya)
/// 3. Tambah jadwal lewat form modal dengan validasi ketat (FR-2.2)
/// 4. Ubah dan hapus jadwal dengan konfirmasi dialog (FR-2.3)
/// 5. Pembaruan data otomatis sinkron ke Beranda (FR-2.4)
class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  void _bukaFormJadwal(BuildContext context, {JadwalLaundry? jadwalToEdit}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return JadwalFormSheet(
          jadwalToEdit: jadwalToEdit,
          onSave: (jadwal) async {
            final vm = context.read<JadwalViewModel>();
            if (jadwalToEdit != null) {
              await vm.updateJadwal(jadwal);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Jadwal "${jadwal.namaPelanggan}" berhasil diperbarui',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } else {
              await vm.addJadwal(jadwal);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Jadwal baru untuk "${jadwal.namaPelanggan}" berhasil ditambahkan',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Future<void> _konfirmasiHapus(
    BuildContext context,
    JadwalLaundry jadwal,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal untuk "${jadwal.namaPelanggan}" pada hari ${jadwal.hari} jam ${jadwal.jam}?',
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
      await context.read<JadwalViewModel>().deleteJadwal(jadwal.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jadwal "${jadwal.namaPelanggan}" telah dihapus'),
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
    final hariIni = DateHelper.getHariIni();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Antar-Jemput'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Tambah Jadwal',
            onPressed: () => _bukaFormJadwal(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaFormJadwal(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Jadwal'),
      ),
      body: Consumer<JadwalViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
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

          final list = vm.jadwalList;

          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                const SizedBox(height: 8),

                // 1. FILTER SEGMENTED BUTTON (FR-2.1)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<JenisLayananJadwal?>(
                    segments: const [
                      ButtonSegment<JenisLayananJadwal?>(
                        value: null,
                        label: Text('Semua'),
                        icon: Icon(Icons.all_inclusive_rounded, size: 16),
                      ),
                      ButtonSegment<JenisLayananJadwal?>(
                        value: JenisLayananJadwal.antar,
                        label: Text('Antar'),
                        icon: Icon(Icons.local_shipping_outlined, size: 16),
                      ),
                      ButtonSegment<JenisLayananJadwal?>(
                        value: JenisLayananJadwal.jemput,
                        label: Text('Jemput'),
                        icon: Icon(Icons.call_received_rounded, size: 16),
                      ),
                      ButtonSegment<JenisLayananJadwal?>(
                        value: JenisLayananJadwal.ambilDiToko,
                        label: Text('Ambil di Toko'),
                        icon: Icon(Icons.storefront_outlined, size: 16),
                      ),
                    ],
                    selected: {vm.filterLayanan},
                    onSelectionChanged: (newSelection) {
                      vm.setFilterLayanan(newSelection.first);
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // 2. FILTER HARI (Chips)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Chip 'Semua Hari'
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: const Text('Semua Hari'),
                          selected: vm.filterHari == 'Semua',
                          onSelected: (_) => vm.setFilterHari('Semua'),
                        ),
                      ),
                      // Chip 'Hari Ini'
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text('Hari Ini ($hariIni)'),
                          selected: vm.filterHari == hariIni,
                          onSelected: (_) => vm.setFilterHari(hariIni),
                        ),
                      ),
                      // Chips per hari
                      ...DateHelper.daftarHari.map((hari) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(hari),
                            selected: vm.filterHari == hari,
                            onSelected: (_) => vm.setFilterHari(hari),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Info Jumlah Jadwal Terfilter
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Menampilkan ${list.length} jadwal',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (vm.filterLayanan != null || vm.filterHari != 'Semua')
                        TextButton(
                          onPressed: () {
                            vm.setFilterLayanan(null);
                            vm.setFilterHari('Semua');
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text('Reset Filter'),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // 3. DAFTAR JADWAL
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: EmptyStateWidget(
                                icon: Icons.event_busy_rounded,
                                title: 'Tidak ada jadwal ditemukan',
                                subtitle: 'Belum ada jadwal yang cocok dengan filter yang dipilih.',
                                actionLabel: 'Tambah Jadwal Baru',
                                onAction: () => _bukaFormJadwal(context),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 80, // Ruang untuk FloatingActionButton
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final jadwal = list[index];
                            return JadwalCard(
                              jadwal: jadwal,
                              showActions: true,
                              showHari: true,
                              onEdit: () => _bukaFormJadwal(
                                context,
                                jadwalToEdit: jadwal,
                              ),
                              onDelete: () => _konfirmasiHapus(context, jadwal),
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
