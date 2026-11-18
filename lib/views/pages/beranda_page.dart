import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/date_helper.dart';
import '../../viewmodels/beranda_vm.dart';
import '../../viewmodels/pengaturan_vm.dart';
import '../widgets/jadwal_card.dart';
import '../widgets/cucian_tile.dart';
import '../widgets/empty_state_widget.dart';

/// Lapisan View: Layar Beranda Hari Ini (Fase 1).
/// Menampilkan:
/// 1. Ringkasan selesai (FR-1.3)
/// 2. Daftar Jadwal Hari Ini terurut berdasarkan jam (FR-1.1)
/// 3. Daftar Cucian belum selesai sebagai pekerjaan hari ini (FR-1.2)
/// Seluruh informasi tampil dalam satu layar tanpa perlu berpindah halaman (FR-1.4).
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final namaUsaha = context
        .watch<PengaturanViewModel>()
        .profilUsaha
        .namaUsaha;
    final jam = DateTime.now().hour;
    final sapaan = jam < 11
        ? 'Selamat pagi'
        : jam < 15
        ? 'Selamat siang'
        : jam < 18
        ? 'Selamat sore'
        : 'Selamat malam';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 92,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$sapaan, $namaUsaha',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.local_laundry_service_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Laundry Kilat',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              DateHelper.getTanggalLengkap(DateTime.now()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Data',
            onPressed: () {
              context.read<BerandaViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<BerandaViewModel>(
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
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.error),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: vm.refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. KARTU RINGKASAN SELESAI (FR-1.3)
                _buildRingkasanCard(context, vm),
                const SizedBox(height: 20),

                // 2. DAFTAR JADWAL HARI INI (FR-1.1)
                _buildJadwalSection(context, vm),
                const SizedBox(height: 24),

                // 3. DAFTAR PEKERJAAN HARI INI (FR-1.2)
                _buildPekerjaanSection(context, vm),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget Ringkasan Selesai (FR-1.3)
  Widget _buildRingkasanCard(BuildContext context, BerandaViewModel vm) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = vm.persentaseSelesai;
    final persenInt = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withAlpha(160),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withAlpha(60)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Selesai Hari Ini',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vm.ringkasanSelesai,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$persenInt%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: colorScheme.surface.withAlpha(180),
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),

          // Rincian Singkat
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildBadgeStat(
                context,
                icon: Icons.check_circle_outline_rounded,
                label: '${vm.selesaiOrder} Selesai',
                color: Colors.green.shade800,
                bgColor: Colors.green.shade100,
              ),
              _buildBadgeStat(
                context,
                icon: Icons.pending_actions_rounded,
                label: '${vm.aktifOrder} Menunggu',
                color: Colors.orange.shade800,
                bgColor: Colors.orange.shade100,
              ),
              _buildBadgeStat(
                context,
                icon: Icons.inventory_2_outlined,
                label: '${vm.totalOrder} Total Order',
                color: colorScheme.primary,
                bgColor: colorScheme.surface,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Bagian Daftar Jadwal Hari Ini (FR-1.1)
  Widget _buildJadwalSection(BuildContext context, BerandaViewModel vm) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final list = vm.jadwalHariIni;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule_rounded, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Jadwal Hari Ini',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${list.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Urut jam',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (list.isEmpty)
          const EmptyStateWidget(
            icon: Icons.event_available_outlined,
            title: 'Jadwal masih kosong',
            subtitle: 'Belum ada jadwal antar-jemput untuk hari ini.',
          )
        else
          ...list.map(
            (jadwal) => JadwalCard(jadwal: jadwal, showActions: false),
          ),
      ],
    );
  }

  /// Bagian Pekerjaan Hari Ini (Order belum selesai) (FR-1.2)
  Widget _buildPekerjaanSection(BuildContext context, BerandaViewModel vm) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final list = vm.pekerjaanHariIni;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_laundry_service_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pekerjaan Hari Ini',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${list.length} Belum Selesai',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Daftar cucian yang perlu diproses hari ini. Centang untuk menyelesaikan.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),

        if (list.isEmpty)
          const EmptyStateWidget(
            icon: Icons.check_circle_rounded,
            title: 'Semua cucian hari ini selesai!',
            subtitle: 'Bagus sekali! Tidak ada cucian yang tertunda.',
            iconColor: Colors.green,
          )
        else
          ...list.map(
            (order) => CucianTile(
              order: order,
              onToggle: (val) {
                vm.toggleSelesaiCucian(order.id);
              },
            ),
          ),
      ],
    );
  }
}
