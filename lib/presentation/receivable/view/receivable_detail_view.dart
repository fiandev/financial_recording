import 'package:financial_recording/core.dart';
import 'package:financial_recording/models/receivable_model/receivable_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReceivableDetailView extends StatelessWidget {
  final ReceivableModel receivable;
  const ReceivableDetailView({super.key, required this.receivable});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.purple;
    String typeLabel = "Piutang";
    IconData typeIcon = Icons.money;

    if (receivable.isSettled) {
      color = Colors.green;
      typeLabel = "Piutang Lunas";
      typeIcon = Icons.check_circle;
    } else if (receivable.dueDate != null &&
        receivable.dueDate!.isBefore(DateTime.now())) {
      color = Colors.red;
      typeLabel = "Piutang Jatuh Tempo";
      typeIcon = Icons.money;
    }

    final formattedAmount = NumberFormat.decimalPattern(
      'id',
    ).format(receivable.amount);
    final formattedDate = receivable.dueDate != null
        ? DateFormat("dd MMMM yyyy", "id").format(receivable.dueDate!)
        : "Tidak Ditentukan";

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: const Text(
          "Detail Piutang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String action) async {
              final controller = Get.find<ReceivableController>();
              if (action == 'edit') {
                // Get the index of the receivable in the list for editing
                Get.back(); // Close the current detail view
                // The edit functionality would need the index which is not available here
                // For now, I'll navigate to form with the receivable data
                Get.to(() => FormReceivableView(editingReceivable: receivable));
              } else if (action == 'delete') {
                // Show confirmation dialog
                bool? confirm = await Get.defaultDialog(
                  title: "Konfirmasi",
                  middleText:
                      "Apakah Anda yakin ingin menghapus data piutang ini?",
                  textConfirm: "Hapus",
                  textCancel: "Batal",
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.grey,
                  backgroundColor: Colors.white,
                  buttonColor: Colors.red,
                  onCancel: () => Get.back(),
                  onConfirm: () => Get.back(result: true),
                );

                if (confirm == true) {
                  controller.deleteReceivableByModel(receivable);
                  Get.back(); // Return to the previous screen after deletion
                }
              } else if (action == 'settle') {
                controller.toggleSettledByModel(receivable);
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
                    Text(
                      receivable.isSettled ? 'Batalkan Lunas' : 'Tandai Lunas',
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
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
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        typeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Rp. $formattedAmount",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Dari: ${receivable.debtorName}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rincian",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                        Icons.person_outlined,
                        "Peminjam",
                        receivable.debtorName,
                        color,
                      ),
                      _buildDetailRow(
                        Icons.description_outlined,
                        "Deskripsi",
                        receivable.description ?? "-",
                        color,
                      ),
                      _buildDetailRow(
                        Icons.monetization_on_outlined,
                        "Jumlah",
                        "Rp ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0).format(receivable.amount)}",
                        color,
                      ),

                      _buildDetailRow(
                        Icons.event_outlined,
                        "Jatuh Tempo",
                        formattedDate,
                        color,
                      ),
                      _buildDetailRow(
                        Icons.payments_outlined,
                        "Status",
                        receivable.isSettled ? "Lunas" : "Belum Lunas",
                        receivable.isSettled
                            ? Colors.green
                            : (receivable.dueDate != null &&
                                      receivable.dueDate!.isBefore(
                                        DateTime.now(),
                                      )
                                  ? Colors.red
                                  : Colors.purple),
                      ),
                      if (receivable.settledAt != null)
                        _buildDetailRow(
                          Icons.check_circle_outline,
                          "Tanggal Dilunasi",
                          DateFormat(
                            "dd MMMM yyyy",
                            "id",
                          ).format(receivable.settledAt!),
                          Colors.green,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
