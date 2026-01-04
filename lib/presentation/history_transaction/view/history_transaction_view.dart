import 'package:financial_recording/presentation/history_transaction/view/transaction_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core.dart';
import 'package:intl/intl.dart';

class HistoryTransactionView extends StatelessWidget {
  const HistoryTransactionView({super.key});

  String _formatCompact(int value) {
    final formatter = NumberFormat("#,##0.##", "id");

    if (value >= 1000000000000) {
      return "${formatter.format(value / 1000000000000)} T";
    } else if (value >= 1000000000) {
      return "${formatter.format(value / 1000000000)} M";
    } else if (value >= 1000000) {
      return "${formatter.format(value / 1000000)} Jt";
    }

    return NumberFormat.decimalPattern('id').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryTransactionController());
    final double appBarHeight = AppBar().preferredSize.height;
    final profileController = Get.put<ProfileController>(ProfileController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (controller.hasError.value) {
        return Scaffold(
          body: Center(child: Text("Error: ${controller.errorMessage.value}")),
        );
      }

      return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Text(
            "Histori Transaksi",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const ProfileView());
              },
              icon: Icon(
                Icons.settings,
                color: profileController.isDarkMode.value
                    ? Colors.black87
                    : Colors.white,
                size: 32.0,
              ),
            ),
          ],
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
          height: MediaQuery.of(context).size.height - appBarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(44.0),
              topRight: Radius.circular(44.0),
            ),
            color: profileController.isDarkMode.value
                ? Colors.black87
                : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Range Tanggal & Tombol Reset
              Obx(() {
                final range = controller.selectedDateRange.value;
                String dateText = "Semua Waktu";
                if (range != null) {
                  final start = range.start;
                  final end = range.end;
                  if (start.year == end.year && start.month == end.month) {
                    dateText = DateFormat("MMMM yyyy", "id").format(start);
                  } else {
                    dateText =
                        "${DateFormat("dd MMM yyyy", "id").format(start)} - ${DateFormat("dd MMM yyyy", "id").format(end)}";
                  }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        dateText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Perbaikan: Padding tidak punya onTap, gunakan GestureDetector/InkWell
                    GestureDetector(
                      onTap: () {
                        controller.resetDateRange();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "Semua Waktu",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: range != null
                                ? Colors.redAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // Summary Cards (Income/Expense)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: profileController.isDarkMode.value
                                      ? Colors.black87
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Pemasukan",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              "Rp. ${_formatCompact(controller.totalIncome.value)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: profileController.isDarkMode.value
                                      ? Colors.black87
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Pengeluaran",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              "Rp. ${_formatCompact(controller.totalExpense.value)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // List Transaksi
              Expanded(
                child: Obx(() {
                  if (controller.filteredHistories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.history, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "Tidak ada data",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredHistories.length,
                    padding: const EdgeInsets.only(
                      bottom: 80,
                    ), // Extra padding for FAB
                    itemBuilder: (context, index) {
                      final item = controller.filteredHistories[index];
                      return _buildTransactionItem(
                        item,
                        controller,
                        profileController,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn_filter_history",
          onPressed: () =>
              _showFilterModal(context, controller, profileController),
          backgroundColor: primaryColor,
          child: Icon(
            Icons.filter_list,
            color: profileController.isDarkMode.value
                ? Colors.black87
                : Colors.white,
          ),
        ),
      );
    });
  }

  void _handleMenuAction(
    String action,
    dynamic item,
    HistoryTransactionController controller,
    ProfileController profileController,
  ) async {
    if (action == 'edit') {
      if (item.type == 'income') {
        Get.to(() => FormIncomeView(transaction: item));
      } else if (item.type == 'expense') {
        Get.to(() => FormExpenseView(transaction: item));
      } else if (item.type == 'transfer') {
        Get.to(() => FormTransferView(transaction: item));
      }
    } else if (action == 'delete') {
      // Show confirmation dialog
      bool? confirm = await Get.dialog<bool>(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Sudut membulat
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: profileController.isDarkMode.value
                  ? Colors.black87
                  : Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Peringatan Besar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Konfirmasi Hapus",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Apakah Anda yakin ingin menghapus data transaksi ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Tombol Batal
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(result: false),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tombol Hapus (Solid Color)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(result: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Hapus"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (confirm == true) {
        controller.deleteTransaction(item);
      }
    }
  }

  Widget _buildTransactionItem(
    dynamic item,
    HistoryTransactionController controller,
    ProfileController profileController,
  ) {
    Color color = Colors.black;
    IconData icon = Icons.help;
    Color iconBg = Colors.grey.shade100;

    if (item.type == 'income') {
      color = Colors.green;
      icon = Icons.arrow_downward;
      iconBg = Colors.green.shade50;
    } else if (item.type == 'expense') {
      color = const Color.fromARGB(255, 230, 88, 78);
      icon = Icons.arrow_upward;
      iconBg = Colors.red.shade50;
    } else {
      color = Colors.blue;
      icon = Icons.swap_horiz;
      iconBg = Colors.blue.shade50;
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => TransactionDetailView(transaction: item));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: profileController.isDarkMode.value
              ? Colors.black87
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: profileController.isDarkMode.value
                ? Colors.black87
                : Colors.grey.shade100,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.categoryName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.walletName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (item.createdAt != null)
                    Text(
                      DateFormat("dd MMM yyyy HH:mm").format(item.createdAt),
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                ],
              ),
            ),
            Text(
              "Rp. ${_formatCompact(item.amount)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 15,
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              borderRadius: BorderRadius.circular(10),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  profileController.isDarkMode.value
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
              onSelected: (String action) => _handleMenuAction(
                action,
                item,
                controller,
                profileController,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue.shade400),
                      const SizedBox(width: 8),
                      const Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red.shade400),
                      const SizedBox(width: 8),
                      const Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(
    BuildContext context,
    HistoryTransactionController controller,
    ProfileController profileController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Transparan agar rounded corners terlihat
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: profileController.isDarkMode.value
                    ? Colors.black87
                    : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar untuk UX drag yang lebih baik
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Filter Transaksi",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.resetFilters();
                                  Get.back();
                                },
                                child: const Text("Reset Semua"),
                              ),
                            ],
                          ),
                          const Divider(),

                          // Date Filter Section
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tanggal",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                // Tombol reset khusus tanggal di dalam modal
                                if (controller.selectedDateRange.value != null)
                                  GestureDetector(
                                    onTap: () {
                                      controller.selectedDateRange.value = null;
                                    },
                                    child: Text(
                                      "Reset Tanggal",
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => InkWell(
                              onTap: () async {
                                final DateTimeRange? result =
                                    await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                      currentDate: DateTime.now(),
                                      saveText: 'Simpan',
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: primaryColor,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                if (result != null) {
                                  controller.selectedDateRange.value = result;
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.selectedDateRange.value == null
                                          ? "Pilih Rentang Tanggal"
                                          : "${DateFormat('dd/MM/yy').format(controller.selectedDateRange.value!.start)} - ${DateFormat('dd/MM/yy').format(controller.selectedDateRange.value!.end)}",
                                      style: TextStyle(
                                        color:
                                            controller
                                                    .selectedDateRange
                                                    .value ==
                                                null
                                            ? Colors.grey
                                            : Colors.black87,
                                        fontWeight:
                                            controller
                                                    .selectedDateRange
                                                    .value ==
                                                null
                                            ? FontWeight.normal
                                            : FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Transaction Type
                          const Text(
                            "Jenis Transaksi",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              children:
                                  [
                                    "Semua",
                                    "Pemasukan",
                                    "Pengeluaran",
                                    "Transfer",
                                  ].map((type) {
                                    final isSelected =
                                        controller.selectedType.value == type;
                                    return ChoiceChip(
                                      label: Text(type),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        if (selected)
                                          controller.selectedType.value = type;
                                      },
                                      selectedColor: primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? primaryColor
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      backgroundColor: Colors.grey.shade100,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: isSelected
                                              ? primaryColor
                                              : Colors.transparent,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Wallet Filter
                          const Text(
                            "Wallet",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: controller.selectedWallet.value.isEmpty
                                  ? null
                                  : controller.selectedWallet.value,
                              hint: const Text("Semua Wallet"),
                              items: [
                                const DropdownMenuItem(
                                  value: "",
                                  child: Text("Semua Wallet"),
                                ),
                                ...controller.walletOptions.map(
                                  (w) => DropdownMenuItem(
                                    value: w,
                                    child: Text(w),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                controller.selectedWallet.value = val ?? "";
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Category Filter
                          const Text(
                            "Kategori",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: controller.selectedCategory.value.isEmpty
                                  ? null
                                  : controller.selectedCategory.value,
                              hint: const Text("Semua Kategori"),
                              items: [
                                const DropdownMenuItem(
                                  value: "",
                                  child: Text("Semua Kategori"),
                                ),
                                ...controller.categoryOptions.map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                controller.selectedCategory.value = val ?? "";
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.applyFilters();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Terapkan Filter",
                                style: TextStyle(
                                  color: profileController.isDarkMode.value
                                      ? Colors.black87
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
