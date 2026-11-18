import 'package:flutter/material.dart';
import '../../models/info_laundry.dart';

/// Lapisan View: Formulir modal bottom sheet untuk menambah Info & Promo baru.
class InfoFormSheet extends StatefulWidget {
  final List<String> availableCategories;
  final Function(InfoLaundry) onSave;

  const InfoFormSheet({
    super.key,
    required this.availableCategories,
    required this.onSave,
  });

  @override
  State<InfoFormSheet> createState() => _InfoFormSheetState();
}

class _InfoFormSheetState extends State<InfoFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  late String _selectedKategori;
  bool _isPenting = false;

  @override
  void initState() {
    super.initState();
    // Gunakan kategori yang bukan 'Semua'
    final validCategories =
        widget.availableCategories.where((c) => c != 'Semua').toList();
    _selectedKategori = validCategories.isNotEmpty ? validCategories.first : 'Promo';
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState?.validate() ?? false) {
      final id =
          'INF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      final item = InfoLaundry(
        id: id,
        judul: _judulController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        kategori: _selectedKategori,
        isPenting: _isPenting,
      );

      widget.onSave(item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final validCategories =
        widget.availableCategories.where((c) => c != 'Semua').toList();

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
                    Icons.campaign_rounded,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tambah Info & Promo',
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

              // 1. Kategori
              DropdownButtonFormField<String>(
                initialValue: _selectedKategori,
                decoration: InputDecoration(
                  labelText: 'Kategori *',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: validCategories.map((kat) {
                  return DropdownMenuItem(
                    value: kat,
                    child: Text(kat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedKategori = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),

              // 2. Judul Info
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Info / Promo *',
                  hintText: 'Contoh: Diskon Kemerdekaan 25%',
                  prefixIcon: const Icon(Icons.title_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul info wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 3. Deskripsi
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi / Detail Info *',
                  hintText: 'Tuliskan syarat promo atau info detail untuk pelanggan...',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi info wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 4. Switch Penting
              SwitchListTile(
                value: _isPenting,
                onChanged: (val) {
                  setState(() {
                    _isPenting = val;
                  });
                },
                title: const Text(
                  'Tandai sebagai Penting',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Info penting akan diberi label merah dan ditampilkan paling atas.',
                  style: TextStyle(fontSize: 12),
                ),
                secondary: Icon(
                  _isPenting ? Icons.star_rounded : Icons.star_border_rounded,
                  color: _isPenting ? Colors.amber.shade700 : null,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 18),

              // 5. Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Simpan Info & Promo',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
