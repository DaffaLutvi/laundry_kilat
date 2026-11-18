import 'package:flutter/material.dart';
import '../../models/cucian_order.dart';
import '../../utils/date_helper.dart';

/// Lapisan View: Formulir modal bottom sheet untuk mencatat CucianOrder baru.
/// Menghitung estimasi selesai otomatis secara real-time saat berat dan jenis layanan dipilih (FR-4.1).
class CucianFormSheet extends StatefulWidget {
  final double Function(JenisLayananCucian, double) onHitungEstimasiJam;
  final Function(CucianOrder order, bool shareLangsung) onSave;

  const CucianFormSheet({
    super.key,
    required this.onHitungEstimasiJam,
    required this.onSave,
  });

  @override
  State<CucianFormSheet> createState() => _CucianFormSheetState();
}

class _CucianFormSheetState extends State<CucianFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _beratController = TextEditingController(text: '3.0');
  JenisLayananCucian _selectedLayanan = JenisLayananCucian.cuciSetrika;

  @override
  void dispose() {
    _namaController.dispose();
    _beratController.dispose();
    super.dispose();
  }

  double get _beratParsed {
    return double.tryParse(_beratController.text.replaceAll(',', '.')) ?? 0.0;
  }

  double get _estimasiJam {
    return widget.onHitungEstimasiJam(_selectedLayanan, _beratParsed);
  }

  DateTime get _targetSelesai {
    final jam = _estimasiJam;
    return DateTime.now().add(Duration(minutes: (jam * 60).round()));
  }

  void _simpan({required bool shareLangsung}) {
    if (_formKey.currentState?.validate() ?? false) {
      final id =
          'CCN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      final order = CucianOrder(
        id: id,
        namaPelanggan: _namaController.text.trim(),
        beratKg: _beratParsed,
        jenisLayanan: _selectedLayanan,
        isDone: false,
      );

      widget.onSave(order, shareLangsung);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final target = _targetSelesai;
    final jamEstimasi = _estimasiJam;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.add_shopping_cart_rounded,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Catat Cucian Masuk',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),

              // 1. Jenis Layanan
              Text(
                'Jenis Layanan Cucian *',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<JenisLayananCucian>(
                  segments: const [
                    ButtonSegment(
                      value: JenisLayananCucian.cuciSetrika,
                      label: Text('Cuci Setrika'),
                      icon: Icon(Icons.iron_rounded, size: 16),
                    ),
                    ButtonSegment(
                      value: JenisLayananCucian.cuciKering,
                      label: Text('Cuci Kering'),
                      icon: Icon(Icons.dry_cleaning_rounded, size: 16),
                    ),
                    ButtonSegment(
                      value: JenisLayananCucian.setrikaSaja,
                      label: Text('Setrika Saja'),
                      icon: Icon(Icons.checkroom_rounded, size: 16),
                    ),
                  ],
                  selected: {_selectedLayanan},
                  onSelectionChanged: (Set<JenisLayananCucian> val) {
                    setState(() {
                      _selectedLayanan = val.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 2. Nama Pelanggan
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan *',
                  hintText: 'Contoh: Budi Santoso',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama pelanggan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 3. Berat Cucian (kg)
              TextFormField(
                controller: _beratController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Berat Cucian (kg) *',
                  hintText: 'Contoh: 3.5',
                  prefixIcon: const Icon(Icons.scale_rounded),
                  suffixText: 'kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Berat cucian wajib diisi';
                  }
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Masukkan berat valid lebih dari 0 kg';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. KARTU KALKULASI ESTIMASI OTOMATIS (FR-4.1)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withAlpha(90),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.secondary.withAlpha(60),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Estimasi Selesai Otomatis',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '~${jamEstimasi.toStringAsFixed(0)} Jam',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Perkiraan selesai: ${DateHelper.getTanggalLengkap(target)} jam ${target.hour.toString().padLeft(2, '0')}:${target.minute.toString().padLeft(2, '0')} WIB',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Tombol Aksi
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => _simpan(shareLangsung: false),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text(
                    'Simpan Order Cucian',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () => _simpan(shareLangsung: true),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Simpan & Langsung Bagikan Estimasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
