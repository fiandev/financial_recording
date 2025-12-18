import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core.dart';

class ButtonTransaction extends StatelessWidget {
  const ButtonTransaction({super.key});

  // Button sizing and style constants
  static const double _containerPadding = 20.0;
  static const double _buttonIconSize = 16.0;
  static const double _buttonPadding = 6.0;
  static const double _buttonMinSize = 40.0;
  static const double _verticalSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(_containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Get.to(() => FormIncomeView()),
                  tooltip: "Tambah Pemasukan",
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.green.withValues(
                        alpha: 0.12,
                      ), // soft green background
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      Colors.green.shade700, // warna ikon hijau soft
                    ),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.all(_buttonPadding),
                    ),
                    minimumSize: WidgetStateProperty.all(
                      Size(_buttonMinSize, _buttonMinSize),
                    ),
                  ),
                  icon: Icon(Icons.arrow_downward, size: _buttonIconSize),
                ),

                SizedBox(height: _verticalSpacing),
              ],
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(_containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Get.to(() => FormExpenseView()),
                  tooltip: "Tambah Pengeluaran",
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.red.withValues(alpha: 0.12),
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      Colors.red.shade700,
                    ),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.all(_buttonPadding),
                    ),
                    minimumSize: WidgetStateProperty.all(
                      Size(_buttonMinSize, _buttonMinSize),
                    ),
                  ),
                  icon: Icon(Icons.arrow_upward, size: _buttonIconSize),
                ),

                SizedBox(height: _verticalSpacing),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(_containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Get.to(() => FormTransferView()),
                  tooltip: "Transfer",
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.blue.withOpacity(0.12), // soft blue background
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      Colors.blue.shade700, // warna ikon biru soft
                    ),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.all(_buttonPadding),
                    ),
                    minimumSize: WidgetStateProperty.all(
                      Size(_buttonMinSize, _buttonMinSize),
                    ),
                  ),
                  icon: Icon(
                    Icons.sync_alt,
                    size: _buttonIconSize,
                  ), // ikon transfer
                ),

                SizedBox(height: _verticalSpacing),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(_containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Get.to(() => DebtView()),
                  tooltip: "Lihat Hutang",
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.orange.withValues(
                        alpha: 0.12,
                      ), // soft orange background
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      Colors.orange.shade700, // warna ikon orange soft
                    ),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.all(_buttonPadding),
                    ),
                    minimumSize: WidgetStateProperty.all(
                      Size(_buttonMinSize, _buttonMinSize),
                    ),
                  ),
                  icon: Icon(
                    Icons.money_off,
                    size: _buttonIconSize,
                  ), // ikon hutang
                ),

                SizedBox(height: _verticalSpacing),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(_containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Get.to(() => ReceivableView()),
                  tooltip: "Lihat Piutang",
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.purple.withValues(
                        alpha: 0.12,
                      ), // soft purple background
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      Colors.purple.shade700, // warna ikon purple soft
                    ),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.all(_buttonPadding),
                    ),
                    minimumSize: WidgetStateProperty.all(
                      Size(_buttonMinSize, _buttonMinSize),
                    ),
                  ),
                  icon: Icon(
                    Icons.money,
                    size: _buttonIconSize,
                  ), // ikon piutang
                ),

                SizedBox(height: _verticalSpacing),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
