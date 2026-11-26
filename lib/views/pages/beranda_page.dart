import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
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
        toolbarHeight: 96,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$sapaan, $namaUsaha',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_laundry_service_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Laundry Kilat',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 11,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  DateHelper.getTanggalLengkap(DateTime.now()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'Segarkan Data',
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.surfaceMuted,
                foregroundColor: AppTheme.primaryColor,
              ),
              onPressed: () {
                context.read<BerandaViewModel>().refresh();
              },
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // 1. KARTU RINGKASAN SELESAI (FR-1.3)
                _buildRingkasanCard(context, vm),
                const SizedBox(height: 22),

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
    final progress = vm.persentaseSelesai;
    final persenInt = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.ringkasanGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppTheme.elevatedShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Aksen dekoratif lingkaran halus di pojok kanan atas
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(16),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -35,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(10),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.white,
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
                              color: Colors.white.withAlpha(220),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vm.ringkasanSelesai,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '$persenInt%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar Elegan
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white.withAlpha(50),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Rincian Micro-stat Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: Icons.check_circle_rounded,
                        label: '${vm.selesaiOrder} Selesai',
                        color: const Color(0xFF6EE7B7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: Icons.pending_actions_rounded,
                        label: '${vm.aktifOrder} Menunggu',
                        color: const Color(0xFFFDE047),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildGlassStatCard(
                        icon: Icons.inventory_2_rounded,
                        label: '${vm.totalOrder} Total Order',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassStatCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withAlpha(40),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white.withAlpha(240),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 18,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Jadwal Hari Ini',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
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
        const SizedBox(height: 10),

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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_laundry_service_rounded,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Pekerjaan Hari Ini',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
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
        const SizedBox(height: 6),
        Text(
          'Daftar cucian yang perlu diproses hari ini. Centang untuk menyelesaikan.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),

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
