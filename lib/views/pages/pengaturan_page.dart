import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/profil_usaha.dart';
import '../../models/layanan_harga.dart';
import '../../models/karyawan.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/pengaturan_vm.dart';
import '../widgets/empty_state_widget.dart';

/// Lapisan View: Layar Pengaturan Usaha, Masuk & Akun (Fase 4).
/// Mengelola:
/// 1. Profil usaha (nama, alamat, kontak, jam operasional) (FR-6.1)
/// 2. Daftar layanan dan harga per kilogram (FR-6.2)
/// 3. Data karyawan (tambah, ubah, aktif/nonaktifkan) (FR-6.3)
/// 4. Masuk, keluar, dan ubah kata sandi (FR-7.1, FR-7.2, FR-7.3)
class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  // ==================== 1. DIALOG PROFIL USAHA ====================
  void _bukaDialogUbahProfil(BuildContext context, ProfilUsaha profil) {
    final formKey = GlobalKey<FormState>();
    final namaCtrl = TextEditingController(text: profil.namaUsaha);
    final alamatCtrl = TextEditingController(text: profil.alamat);
    final kontakCtrl = TextEditingController(text: profil.kontak);
    final jamCtrl = TextEditingController(text: profil.jamOperasional);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit_note_rounded),
            SizedBox(width: 8),
            Text('Ubah Profil Usaha'),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Usaha *',
                    prefixIcon: Icon(Icons.storefront_rounded),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama usaha wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: alamatCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Alamat *',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  maxLines: 2,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Alamat wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: kontakCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kontak / Telepon *',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Kontak wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: jamCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Jam Operasional *',
                    prefixIcon: Icon(Icons.access_time_rounded),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Jam operasional wajib diisi'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final updated = profil.copyWith(
                  namaUsaha: namaCtrl.text.trim(),
                  alamat: alamatCtrl.text.trim(),
                  kontak: kontakCtrl.text.trim(),
                  jamOperasional: jamCtrl.text.trim(),
                );
                await context.read<PengaturanViewModel>().updateProfil(updated);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil usaha berhasil diperbarui'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ==================== 2. DIALOG LAYANAN & HARGA ====================
  void _bukaDialogLayanan(BuildContext context, {LayananHarga? itemToEdit}) {
    final formKey = GlobalKey<FormState>();
    final isEdit = itemToEdit != null;
    final namaCtrl = TextEditingController(text: itemToEdit?.namaLayanan ?? '');
    final hargaCtrl = TextEditingController(
      text: itemToEdit != null
          ? itemToEdit.hargaPerKg.toStringAsFixed(0)
          : '7000',
    );
    final jamCtrl = TextEditingController(
      text: itemToEdit != null
          ? itemToEdit.estimasiJam.toStringAsFixed(0)
          : '24',
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isEdit ? Icons.edit_rounded : Icons.add_circle_outline_rounded,
            ),
            const SizedBox(width: 8),
            Text(isEdit ? 'Ubah Layanan & Harga' : 'Tambah Layanan Baru'),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Layanan *',
                    hintText: 'Contoh: Cuci Karpet / Selimut',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama layanan wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: hargaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga per Kg (Rp) *',
                    prefixText: 'Rp ',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Harga wajib diisi';
                    }
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0) {
                      return 'Masukkan nominal valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: jamCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Estimasi Pengerjaan (Jam) *',
                    suffixText: 'jam',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Estimasi jam wajib diisi';
                    }
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0) {
                      return 'Masukkan jam valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final vm = context.read<PengaturanViewModel>();
                final id =
                    itemToEdit?.id ??
                    'LYN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                final item = LayananHarga(
                  id: id,
                  namaLayanan: namaCtrl.text.trim(),
                  hargaPerKg: double.parse(hargaCtrl.text.trim()),
                  estimasiJam: double.parse(jamCtrl.text.trim()),
                );

                if (isEdit) {
                  await vm.updateLayanan(item);
                } else {
                  await vm.addLayanan(item);
                }

                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Layanan "${item.namaLayanan}" berhasil disimpan',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ==================== 3. DIALOG DATA KARYAWAN ====================
  void _bukaDialogKaryawan(BuildContext context, {Karyawan? itemToEdit}) {
    final formKey = GlobalKey<FormState>();
    final isEdit = itemToEdit != null;
    final namaCtrl = TextEditingController(text: itemToEdit?.nama ?? '');
    final posisiCtrl = TextEditingController(text: itemToEdit?.posisi ?? '');
    final telpCtrl = TextEditingController(text: itemToEdit?.noTelepon ?? '');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isEdit ? Icons.person_outline_rounded : Icons.person_add_rounded,
            ),
            const SizedBox(width: 8),
            Text(isEdit ? 'Ubah Data Karyawan' : 'Tambah Karyawan'),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap *',
                    hintText: 'Contoh: Ahmad Fauzi',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama karyawan wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: posisiCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Posisi / Tanggung Jawab *',
                    hintText: 'Contoh: Kurir / Operator Setrika',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Posisi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: telpCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp / Telepon *',
                    hintText: 'Contoh: 0812-3344-5566',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nomor telepon wajib diisi'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final vm = context.read<PengaturanViewModel>();
                final id =
                    itemToEdit?.id ??
                    'KRY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                final item = Karyawan(
                  id: id,
                  nama: namaCtrl.text.trim(),
                  posisi: posisiCtrl.text.trim(),
                  noTelepon: telpCtrl.text.trim(),
                  isAktif: itemToEdit?.isAktif ?? true,
                );

                if (isEdit) {
                  await vm.updateKaryawan(item);
                } else {
                  await vm.addKaryawan(item);
                }

                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Data karyawan "${item.nama}" berhasil disimpan',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ==================== 4. DIALOG UBAH KATA SANDI ====================
  void _bukaDialogUbahPassword(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final passLamaCtrl = TextEditingController();
    final passBaruCtrl = TextEditingController();
    final passKonfCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.password_rounded),
            SizedBox(width: 8),
            Text('Ubah Kata Sandi'),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: passLamaCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi Lama *',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Masukkan kata sandi lama'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passBaruCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi Baru *',
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Masukkan kata sandi baru';
                    }
                    if (v.length < 6) return 'Kata sandi minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passKonfCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi Baru *',
                    prefixIcon: Icon(Icons.lock_clock_rounded),
                  ),
                  validator: (v) {
                    if (v != passBaruCtrl.text) {
                      return 'Konfirmasi kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final vm = context.read<PengaturanViewModel>();
                final sukses = await vm.ubahKataSandi(
                  passLamaCtrl.text,
                  passBaruCtrl.text,
                );

                if (ctx.mounted) {
                  if (sukses) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kata sandi berhasil diubah!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text(
                          vm.errorMessage ?? 'Gagal mengubah kata sandi',
                        ),
                        backgroundColor: Theme.of(ctx).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ==================== 5. DIALOG KONFIRMASI KELUAR ====================
  Future<void> _konfirmasiLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun pengelola Laundry Kilat?',
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
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<PengaturanViewModel>().logout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda telah keluar dari akun'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Usaha & Akun')),
      body: Consumer<PengaturanViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profil = vm.profilUsaha;
          final layananList = vm.layananList;
          final karyawanList = vm.karyawanList;
          final isLoggedIn = vm.isLoggedIn;
          final user = vm.userAccount;

          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // 1. BAGIAN MASUK & AKUN (FR-7.1, FR-7.2, FR-7.3)
                if (isLoggedIn)
                  _buildAkunCard(context, vm, user)
                else
                  _buildLoginCard(context, vm),

                const SizedBox(height: 20),

                // 2. BAGIAN PROFIL USAHA (FR-6.1)
                _buildProfilUsahaCard(context, profil),

                const SizedBox(height: 20),

                // 3. BAGIAN LAYANAN & HARGA PER KG (FR-6.2)
                _buildLayananHargaCard(context, vm, layananList),

                const SizedBox(height: 20),

                // 4. BAGIAN KELOLA KARYAWAN (FR-6.3)
                _buildKaryawanCard(context, vm, karyawanList),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== WIDGET BUILDER SECTION ====================

  Widget _buildAkunCard(
    BuildContext context,
    PengaturanViewModel vm,
    dynamic user,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.namaLengkap,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Username: @${user.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreenBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.successGreenBorder),
                  ),
                  child: const Text(
                    'Aktif',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _bukaDialogUbahPassword(context),
                  icon: const Icon(Icons.key_rounded, size: 16),
                  label: const Text('Ubah Kata Sandi'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _konfirmasiLogout(context),
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 16,
                    color: colorScheme.error,
                  ),
                  label: Text(
                    'Keluar',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, PengaturanViewModel vm) {
    final formKey = GlobalKey<FormState>();
    final userCtrl = TextEditingController(text: 'admin');
    final passCtrl = TextEditingController();

    return Card(
      elevation: 0,
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.amber.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.amber.shade900,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Masuk Akun Pengelola (FR-7.1)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Anda sedang dalam status keluar. Masuk untuk mengelola data usaha.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: userCtrl,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Masukkan username' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Sandi (default: admin123)',
                  prefixIcon: Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Masukkan kata sandi' : null,
              ),
              if (vm.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  vm.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      await vm.login(userCtrl.text, passCtrl.text);
                    }
                  },
                  child: const Text('Masuk Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilUsahaCard(BuildContext context, ProfilUsaha profil) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Profil Usaha (FR-6.1)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _bukaDialogUbahProfil(context, profil),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: const Text('Ubah'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              profil.namaUsaha,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.place_outlined,
              label: profil.alamat,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 6),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: profil.kontak,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 6),
            _buildInfoRow(
              icon: Icons.access_time_rounded,
              label: profil.jamOperasional,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLayananHargaCard(
    BuildContext context,
    PengaturanViewModel vm,
    List<LayananHarga> list,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Layanan & Harga / kg (FR-6.2)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _bukaDialogLayanan(context),
                  icon: const Icon(Icons.add_rounded, size: 14),
                  label: const Text('Tambah'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            if (list.isEmpty)
              EmptyStateWidget(
                icon: Icons.local_laundry_service_outlined,
                title: 'Belum ada layanan',
                subtitle: 'Tambahkan layanan dan harga untuk usaha Anda.',
                actionLabel: 'Tambah Layanan',
                onAction: () => _bukaDialogLayanan(context),
              )
            else
              ...list.map((layanan) {
                final hargaFmt =
                    'Rp ${layanan.hargaPerKg.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} / kg';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.outlineBorderLight),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                layanan.namaLayanan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Estimasi: ${layanan.estimasiJam.toStringAsFixed(0)} jam',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            hargaFmt,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () =>
                              _bukaDialogLayanan(context, itemToEdit: layanan),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildKaryawanCard(
    BuildContext context,
    PengaturanViewModel vm,
    List<Karyawan> list,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Kelola Karyawan (FR-6.3)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _bukaDialogKaryawan(context),
                  icon: const Icon(Icons.add_rounded, size: 14),
                  label: const Text('Tambah'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            if (list.isEmpty)
              EmptyStateWidget(
                icon: Icons.groups_outlined,
                title: 'Belum ada karyawan',
                subtitle:
                    'Data karyawan yang Anda tambahkan akan tampil di sini.',
                actionLabel: 'Tambah Karyawan',
                onAction: () => _bukaDialogKaryawan(context),
              )
            else
              ...list.map((karyawan) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: karyawan.isAktif
                          ? AppTheme.surfaceMuted
                          : AppTheme.surfaceMuted.withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.outlineBorderLight),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: karyawan.isAktif
                              ? AppTheme.primaryLight
                              : colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_rounded,
                            size: 20,
                            color: karyawan.isAktif
                                ? AppTheme.primaryColor
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                karyawan.nama,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: karyawan.isAktif
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '${karyawan.posisi} • ${karyawan.noTelepon}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Chip Status Aktif / Nonaktif
                        InkWell(
                          onTap: () => vm.toggleKaryawanStatus(karyawan.id),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: karyawan.isAktif
                                  ? AppTheme.successGreenBg
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: karyawan.isAktif
                                    ? AppTheme.successGreenBorder
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              karyawan.isAktif ? 'Aktif' : 'Nonaktif',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: karyawan.isAktif
                                    ? AppTheme.successGreen
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _bukaDialogKaryawan(
                            context,
                            itemToEdit: karyawan,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
