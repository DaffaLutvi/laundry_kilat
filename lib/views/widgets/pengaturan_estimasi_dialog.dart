import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Lapisan View: Dialog untuk mengatur lama pengerjaan standar per jenis layanan (FR-4.2).
class PengaturanEstimasiDialog extends StatefulWidget {
  final double initialCuciSetrika;
  final double initialCuciKering;
  final double initialSetrikaSaja;
  final double initialKilat;
  final Function({
    required double cuciSetrika,
    required double cuciKering,
    required double setrikaSaja,
    required double kilat,
  }) onSave;

  const PengaturanEstimasiDialog({
    super.key,
    required this.initialCuciSetrika,
    required this.initialCuciKering,
    required this.initialSetrikaSaja,
    required this.initialKilat,
    required this.onSave,
  });

  @override
  State<PengaturanEstimasiDialog> createState() =>
      _PengaturanEstimasiDialogState();
}

class _PengaturanEstimasiDialogState extends State<PengaturanEstimasiDialog> {
  late TextEditingController _cuciSetrikaController;
  late TextEditingController _cuciKeringController;
  late TextEditingController _setrikaSajaController;
  late TextEditingController _kilatController;

  @override
  void initState() {
    super.initState();
    _cuciSetrikaController = TextEditingController(
      text: widget.initialCuciSetrika.toStringAsFixed(0),
    );
    _cuciKeringController = TextEditingController(
      text: widget.initialCuciKering.toStringAsFixed(0),
    );
    _setrikaSajaController = TextEditingController(
      text: widget.initialSetrikaSaja.toStringAsFixed(0),
    );
    _kilatController = TextEditingController(
      text: widget.initialKilat.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _cuciSetrikaController.dispose();
    _cuciKeringController.dispose();
    _setrikaSajaController.dispose();
    _kilatController.dispose();
    super.dispose();
  }

  void _simpan() {
    final cs =
        double.tryParse(_cuciSetrikaController.text) ?? widget.initialCuciSetrika;
    final ck =
        double.tryParse(_cuciKeringController.text) ?? widget.initialCuciKering;
    final ss =
        double.tryParse(_setrikaSajaController.text) ?? widget.initialSetrikaSaja;
    final kl = double.tryParse(_kilatController.text) ?? widget.initialKilat;

    widget.onSave(
      cuciSetrika: cs,
      cuciKering: ck,
      setrikaSaja: ss,
      kilat: kl,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.tune_rounded, color: AppTheme.primaryColor),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Atur Lama Pengerjaan',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sesuaikan estimasi jam standar untuk masing-masing jenis layanan (FR-4.2):',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            _buildField(
              'Cuci Setrika',
              _cuciSetrikaController,
              Icons.iron_rounded,
            ),
            const SizedBox(height: 12),
            _buildField(
              'Cuci Kering',
              _cuciKeringController,
              Icons.dry_cleaning_rounded,
            ),
            const SizedBox(height: 12),
            _buildField(
              'Setrika Saja',
              _setrikaSajaController,
              Icons.checkroom_rounded,
            ),
            const SizedBox(height: 12),
            _buildField(
              'Layanan Kilat',
              _kilatController,
              Icons.bolt_rounded,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _simpan,
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '$label (jam)',
        prefixIcon: Icon(icon, size: 20),
        suffixText: 'jam',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}
