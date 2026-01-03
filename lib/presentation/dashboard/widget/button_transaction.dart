import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Pastikan import path ini sesuai dengan struktur project Anda
import '../../../core.dart';

class ButtonTransaction extends StatelessWidget {
  const ButtonTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Logika Responsif
        // Jika lebar parent kurang dari 600 (seukuran HP), gunakan layout compact
        final isSmallScreen = constraints.maxWidth < 600;
        final isVerySmallScreen =
            constraints.maxWidth < 350; // HP kecil (iPhone SE/Android lama)

        // Variabel ukuran dinamis
        final double containerPadding = isSmallScreen ? 8.0 : 32.0;
        final double buttonInnerPadding = isSmallScreen ? 12.0 : 16.0;
        final double iconSize = isSmallScreen ? 28.0 : 36.0;
        final double fontSize = isSmallScreen ? 12.0 : 14.0;
        final double gapHeight = isSmallScreen ? 8.0 : 16.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TransactionButtonItem(
                label: "Pemasukan",
                icon: Icons.arrow_downward,
                color: Colors.green,
                onTap: () => Get.to(() => const FormIncomeView()),
                containerPadding: containerPadding,
                buttonInnerPadding: buttonInnerPadding,
                iconSize: iconSize,
                fontSize: fontSize,
                gapHeight: gapHeight,
                hideLabel: isVerySmallScreen,
              ),
              _TransactionButtonItem(
                label: "Pengeluaran",
                icon: Icons.arrow_upward,
                color: Colors.red,
                onTap: () => Get.to(() => const FormExpenseView()),
                containerPadding: containerPadding,
                buttonInnerPadding: buttonInnerPadding,
                iconSize: iconSize,
                fontSize: fontSize,
                gapHeight: gapHeight,
                hideLabel: isVerySmallScreen,
              ),
              _TransactionButtonItem(
                label: "Transfer",
                icon: Icons.sync_alt,
                color: Colors.blue,
                onTap: () => Get.to(() => const FormTransferView()),
                containerPadding: containerPadding,
                buttonInnerPadding: buttonInnerPadding,
                iconSize: iconSize,
                fontSize: fontSize,
                gapHeight: gapHeight,
                hideLabel: isVerySmallScreen,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget Helper untuk mengurangi duplikasi kode
class _TransactionButtonItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final MaterialColor color;
  final VoidCallback onTap;

  // Responsive parameters
  final double containerPadding;
  final double buttonInnerPadding;
  final double iconSize;
  final double fontSize;
  final double gapHeight;
  final bool hideLabel;

  const _TransactionButtonItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.containerPadding,
    required this.buttonInnerPadding,
    required this.iconSize,
    required this.fontSize,
    required this.gapHeight,
    this.hideLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // Padding horizontal antar item
        padding: EdgeInsets.symmetric(horizontal: containerPadding / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(100), // Efek ripple bulat
                child: Container(
                  padding: EdgeInsets.all(buttonInnerPadding),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: iconSize, color: color.shade700),
                ),
              ),
            ),

            if (!hideLabel) ...[
              SizedBox(height: gapHeight),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
