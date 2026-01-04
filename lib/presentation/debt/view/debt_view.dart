import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core.dart';

class DebtView extends StatelessWidget {
  const DebtView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DebtController());
    final profileController = Get.put(ProfileController());
    final double appBarHeight = AppBar().preferredSize.height;

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
        backgroundColor: profileController.isDarkMode.value
            ? Colors.black87
            : primaryColor,
        appBar: AppBar(
          title: Text(
            "Daftar Hutang",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: profileController.isDarkMode.value
                  ? Colors.white
                  : Colors.white,
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
                    ? Colors.white
                    : Colors.white,
                size: 32.0,
              ),
            ),
          ],
          backgroundColor: profileController.isDarkMode.value
              ? Colors.grey[800]
              : primaryColor,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
          height: MediaQuery.of(context).size.height - appBarHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(44.0),
              topRight: Radius.circular(44.0),
            ),
            color: profileController.isDarkMode.value
                ? Colors.grey[800]
                : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summaries for debt
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: profileController.isDarkMode.value
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: profileController.isDarkMode.value
                              ? Colors.orange.withOpacity(0.5)
                              : Colors.orange.withValues(alpha: 0.3),
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
                                      ? Colors.grey[700]
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.money_off,
                                  color: Colors.orange,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Total Hutang",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: profileController.isDarkMode.value
                                      ? Colors.orange.shade200
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            double totalDebt = controller.debts.fold(
                              0,
                              (sum, debt) => sum + debt.amount,
                            );
                            return Text(
                              "Rp. ${NumberFormat.decimalPattern('id').format(totalDebt)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: profileController.isDarkMode.value
                                    ? Colors.orange.shade200
                                    : Colors.orange,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: profileController.isDarkMode.value
                            ? Colors.green.withOpacity(0.2)
                            : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: profileController.isDarkMode.value
                              ? Colors.green.withOpacity(0.5)
                              : Colors.green.withValues(alpha: 0.3),
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
                                      ? Colors.grey[700]
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Lunas",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: profileController.isDarkMode.value
                                      ? Colors.green.shade200
                                      : Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            int settledDebt = controller.debts
                                .where((debt) => debt.isSettled)
                                .length;
                            return Text(
                              "${settledDebt} hutang",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: profileController.isDarkMode.value
                                    ? Colors.green.shade200
                                    : Colors.green,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  if (controller.debts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.money_off,
                            size: 60,
                            color: profileController.isDarkMode.value
                                ? Colors.grey.shade600
                                : Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Tidak ada data",
                            style: TextStyle(
                              color: profileController.isDarkMode.value
                                  ? Colors.grey.shade600
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.debts.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final item = controller.debts[index];
                      return _buildDebtItem(item, controller, index, profileController);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "debt_fab", // Unique hero tag to avoid conflicts
          onPressed: () => Get.to(() => FormDebtView()),
          backgroundColor: profileController.isDarkMode.value
              ? Colors.grey[700]
              : primaryColor,
          child: Icon(
            Icons.add,
            color: profileController.isDarkMode.value
                ? Colors.white
                : Colors.white,
          ),
        ),
      );
    });
  }

  Widget _buildDebtItem(DebtModel item, DebtController controller, int index, ProfileController profileController) {
    Color color = profileController.isDarkMode.value ? Colors.orange.shade300 : Colors.orange;
    IconData icon = Icons.money_off;
    Color iconBg = profileController.isDarkMode.value ? Colors.grey[700]! : (item.isSettled ? Colors.green.shade50 : item.dueDate != null && item.dueDate!.isBefore(DateTime.now()) && !item.isSettled ? Colors.red.shade50 : Colors.orange.shade50);

    if (item.isSettled) {
      color = profileController.isDarkMode.value ? Colors.green.shade300 : Colors.green;
      icon = Icons.check_circle;
      iconBg = profileController.isDarkMode.value ? Colors.grey[700]! : Colors.green.shade50;
    } else if (item.dueDate != null && item.dueDate!.isBefore(DateTime.now())) {
      color = profileController.isDarkMode.value ? Colors.red.shade300 : Colors.red;
      icon = Icons.money_off;
      iconBg = profileController.isDarkMode.value ? Colors.grey[700]! : Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: profileController.isDarkMode.value
            ? Colors.grey[800]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: profileController.isDarkMode.value
                ? Colors.grey.shade800.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: profileController.isDarkMode.value
              ? Colors.grey.shade700
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
            child: GestureDetector(
              onTap: () {
                // Navigate to the form view for editing
                Get.to(() => FormDebtView(editingDebt: item, index: index));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.creditorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: profileController.isDarkMode.value
                          ? Colors.white
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Jumlah: Rp ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0).format(item.amount)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: profileController.isDarkMode.value
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                  if (item.dueDate != null)
                    Text(
                      "Jatuh Tempo: ${DateFormat("dd MMM yyyy").format(item.dueDate!)}",
                      style: TextStyle(
                        fontSize: 11,
                        color: item.isSettled
                            ? (profileController.isDarkMode.value
                                ? Colors.grey[500]
                                : Colors.grey[400])
                            : item.dueDate!.isBefore(DateTime.now())
                            ? (profileController.isDarkMode.value
                                ? Colors.red[300]
                                : Colors.red[400])
                            : (profileController.isDarkMode.value
                                ? Colors.orange[300]
                                : Colors.orange[400]),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.isSettled
                  ? (profileController.isDarkMode.value
                      ? Colors.green.withOpacity(0.2)
                      : Colors.green.withValues(alpha: 0.1))
                  : (item.dueDate != null &&
                        item.dueDate!.isBefore(DateTime.now()) &&
                        !item.isSettled)
                  ? (profileController.isDarkMode.value
                      ? Colors.red.withOpacity(0.2)
                      : Colors.red.withValues(alpha: 0.1))
                  : (profileController.isDarkMode.value
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.orange.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: item.isSettled
                    ? (profileController.isDarkMode.value
                        ? Colors.green.withOpacity(0.5)
                        : Colors.green.withValues(alpha: 0.3))
                    : (item.dueDate != null &&
                          item.dueDate!.isBefore(DateTime.now()) &&
                          !item.isSettled)
                    ? (profileController.isDarkMode.value
                        ? Colors.red.withOpacity(0.5)
                        : Colors.red.withValues(alpha: 0.3))
                    : (profileController.isDarkMode.value
                        ? Colors.orange.withOpacity(0.5)
                        : Colors.orange.withValues(alpha: 0.3)),
              ),
            ),
            child: Text(
              item.isSettled ? "Lunas" : "Belum Lunas",
              style: TextStyle(
                color: item.isSettled
                    ? (profileController.isDarkMode.value
                        ? Colors.green.shade300
                        : Colors.green)
                    : (item.dueDate != null &&
                          item.dueDate!.isBefore(DateTime.now()) &&
                          !item.isSettled)
                    ? (profileController.isDarkMode.value
                        ? Colors.red.shade300
                        : Colors.red)
                    : (profileController.isDarkMode.value
                        ? Colors.orange.shade300
                        : Colors.orange),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String action) async {
              if (action == 'edit') {
                Get.to(() => FormDebtView(editingDebt: item, index: index));
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
                            ? Colors.grey[800]
                            : Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: profileController.isDarkMode.value
                                ? Colors.grey.shade800.withValues(alpha: 0.5)
                                : Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
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
                              color: profileController.isDarkMode.value
                                  ? Colors.red.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              size: 40,
                              color: profileController.isDarkMode.value
                                  ? Colors.red.shade300
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Konfirmasi Hapus",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: profileController.isDarkMode.value
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Apakah Anda yakin ingin menghapus data transaksi ini?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: profileController.isDarkMode.value
                                  ? Colors.grey[400]
                                  : Colors.grey,
                            ),
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
                                    side: BorderSide(
                                      color: profileController.isDarkMode.value
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(
                                      color: profileController.isDarkMode.value
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
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
                  controller.deleteDebt(index);
                }
              } else if (action == 'settle') {
                // Toggle settled status
                controller.toggleSettled(index);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: profileController.isDarkMode.value
                          ? Colors.blue.shade300
                          : Colors.blue.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: profileController.isDarkMode.value
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settle',
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: profileController.isDarkMode.value
                          ? Colors.green.shade300
                          : Colors.green.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.isSettled ? 'Batalkan Lunas' : 'Tandai Lunas',
                      style: TextStyle(
                        color: profileController.isDarkMode.value
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: profileController.isDarkMode.value
                          ? Colors.red.shade300
                          : Colors.red.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hapus',
                      style: TextStyle(
                        color: profileController.isDarkMode.value
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
