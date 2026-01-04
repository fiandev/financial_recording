import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core.dart';

class ReceivableView extends StatelessWidget {
  const ReceivableView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReceivableController());
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
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: const Text(
            "Daftar Piutang",
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
              icon: const Icon(Icons.settings, color: Colors.white, size: 32.0),
            ),
          ],
          backgroundColor: primaryColor,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
          height: MediaQuery.of(context).size.height - appBarHeight,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(44.0),
              topRight: Radius.circular(44.0),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summaries for receivables
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.purple.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.money,
                                  color: Colors.purple,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Total Piutang",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            double totalReceivable = controller.receivables
                                .fold(
                                  0,
                                  (sum, receivable) => sum + receivable.amount,
                                );
                            return Text(
                              "Rp. ${NumberFormat.decimalPattern('id').format(totalReceivable)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
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
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Diterima",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            int settledReceivables = controller.receivables
                                .where((receivable) => receivable.isSettled)
                                .length;
                            return Text(
                              "${settledReceivables} piutang",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
                  if (controller.receivables.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.money, size: 60, color: Colors.grey),
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
                    itemCount: controller.receivables.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final item = controller.receivables[index];
                      return _buildReceivableItem(item, controller, index);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "receivable_fab", // Unique hero tag to avoid conflicts
          onPressed: () => Get.to(() => FormReceivableView()),
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    });
  }

  Widget _buildReceivableItem(
    ReceivableModel item,
    ReceivableController controller,
    int index,
  ) {
    Color color = Colors.purple;
    IconData icon = Icons.money;
    Color iconBg = Colors.purple.shade50;

    if (item.isSettled) {
      color = Colors.green;
      icon = Icons.check_circle;
      iconBg = Colors.green.shade50;
    } else if (item.dueDate != null && item.dueDate!.isBefore(DateTime.now())) {
      color = Colors.red;
      icon = Icons.money;
      iconBg = Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
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
                Get.to(
                  () =>
                      FormReceivableView(editingReceivable: item, index: index),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.debtorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Jumlah: Rp ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0).format(item.amount)}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (item.dueDate != null)
                    Text(
                      "Jatuh Tempo: ${DateFormat("dd MMM yyyy").format(item.dueDate!)}",
                      style: TextStyle(
                        fontSize: 11,
                        color: item.isSettled
                            ? Colors.grey[400]
                            : item.dueDate!.isBefore(DateTime.now())
                            ? Colors.red[400]
                            : Colors.purple[400],
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
                  ? Colors.green.withValues(alpha: 0.1)
                  : (item.dueDate != null &&
                        item.dueDate!.isBefore(DateTime.now()) &&
                        !item.isSettled)
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: item.isSettled
                    ? Colors.green.withValues(alpha: 0.3)
                    : (item.dueDate != null &&
                          item.dueDate!.isBefore(DateTime.now()) &&
                          !item.isSettled)
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.purple.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              item.isSettled ? "Lunas" : "Belum Lunas",
              style: TextStyle(
                color: item.isSettled
                    ? Colors.green
                    : (item.dueDate != null &&
                          item.dueDate!.isBefore(DateTime.now()) &&
                          !item.isSettled)
                    ? Colors.red
                    : Colors.purple,
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
                Get.to(
                  () =>
                      FormReceivableView(editingReceivable: item, index: index),
                );
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
                        color: Colors.white,
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                  controller.deleteReceivable(index);
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
                    Icon(Icons.edit, color: Colors.blue.shade400),
                    const SizedBox(width: 8),
                    const Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settle',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade400),
                    const SizedBox(width: 8),
                    Text(item.isSettled ? 'Batalkan Lunas' : 'Tandai Lunas'),
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
    );
  }
}
