import 'package:flutter/material.dart';
import '../../models/jadwal_laundry.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_helper.dart';

/// Lapisan View: Formulir modal bottom sheet untuk Tambah & Ubah JadwalLaundry.
/// Menjalankan validasi ketat bahwa semua kolom wajib diisi (FR-2.2).
class JadwalFormSheet extends StatefulWidget {
  final JadwalLaundry? jadwalToEdit;
  final Function(JadwalLaundry) onSave;

  const JadwalFormSheet({
    super.key,
    this.jadwalToEdit,
    required this.onSave,
  });

  @override
  State<JadwalFormSheet> createState() => _JadwalFormSheetState();
}

class _JadwalFormSheetState extends State<JadwalFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _jamController;
  late String _selectedHari;
  late JenisLayananJadwal _selectedLayanan;

  @override
  void initState() {
    super.initState();
    final edit = widget.jadwalToEdit;
    _namaController = TextEditingController(text: edit?.namaPelanggan ?? '');
    _alamatController = TextEditingController(text: edit?.alamat ?? '');
    _jamController = TextEditingController(text: edit?.jam ?? '09:00');
    _selectedHari = edit?.hari ?? DateHelper.getHariIni();
    _selectedLayanan = edit?.jenisLayanan ?? JenisLayananJadwal.jemput;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _jamController.dispose();
    super.dispose();
  }

  Future<void> _pilihJam() async {
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);
    try {
      final parts = _jamController.text.split(':');
      if (parts.length == 2) {
        initialTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final jamStr = picked.hour.toString().padLeft(2, '0');
      final menitStr = picked.minute.toString().padLeft(2, '0');
      setState(() {
        _jamController.text = '$jamStr:$menitStr';
      });
    }
  }

  void _simpan() {
    if (_formKey.currentState?.validate() ?? false) {
      final id = widget.jadwalToEdit?.id ??
          'JDW-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      final item = JadwalLaundry(
        id: id,
        namaPelanggan: _namaController.text.trim(),
        alamat: _alamatController.text.trim(),
        hari: _selectedHari,
        jam: _jamController.text.trim(),
        jenisLayanan: _selectedLayanan,
      );

      widget.onSave(item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.jadwalToEdit != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Modern
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.outlineBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Sheet
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isEdit
                          ? Icons.edit_calendar_rounded
                          : Icons.add_circle_outline_rounded,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isEdit ? 'Ubah Jadwal' : 'Tambah Jadwal Baru',
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

              // 1. Jenis Layanan (SegmentedButton)
              Text(
                'Jenis Layanan',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SegmentedButton<JenisLayananJadwal>(
                  segments: const [
                    ButtonSegment(
                      value: JenisLayananJadwal.jemput,
                      label: Text('Jemput'),
                      icon: Icon(Icons.call_received_rounded, size: 16),
                    ),
                    ButtonSegment(
                      value: JenisLayananJadwal.antar,
                      label: Text('Antar'),
                      icon: Icon(Icons.local_shipping_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: JenisLayananJadwal.ambilDiToko,
                      label: Text('Ambil di Toko'),
                      icon: Icon(Icons.storefront_outlined, size: 16),
                    ),
                  ],
                  selected: {_selectedLayanan},
                  onSelectionChanged: (Set<JenisLayananJadwal> newSelection) {
                    setState(() {
                      _selectedLayanan = newSelection.first;
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
                  hintText: 'Contoh: Ibu Siti Rahma',
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
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 3. Alamat Pelanggan
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat Pengambilan / Pengantaran *',
                  hintText: 'Contoh: Jl. Melati No. 12, RT 02/05',
                  prefixIcon: const Icon(Icons.place_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 4. Hari & Jam
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Hari
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedHari,
                      decoration: InputDecoration(
                        labelText: 'Hari *',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: DateHelper.daftarHari.map((hari) {
                        return DropdownMenuItem(
                          value: hari,
                          child: Text(hari),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedHari = val;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih hari';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Jam Input dengan Time Picker
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _jamController,
                      readOnly: true,
                      onTap: _pilihJam,
                      decoration: InputDecoration(
                        labelText: 'Jam *',
                        prefixIcon: const Icon(Icons.schedule_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Jam wajib diisi';
                        }
                        final regex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
                        if (!regex.hasMatch(value.trim())) {
                          return 'Format HH:mm';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(
                    isEdit ? 'Simpan Perubahan' : 'Tambah Jadwal',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
