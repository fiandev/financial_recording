import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_recording/core.dart';
import 'package:intl/intl.dart';
import '../controller/receivable_controller.dart';

class FormReceivableView extends StatelessWidget {
  final ReceivableModel? editingReceivable;
  final int? index;

  const FormReceivableView({super.key, this.editingReceivable, this.index});

  @override
  Widget build(BuildContext context) {
    final ReceivableController controller = Get.find<ReceivableController>() ?? Get.put(ReceivableController());

    // Initialize form values
    final TextEditingController debtorNameController = TextEditingController(
      text: editingReceivable?.debtorName,
    );
    final TextEditingController amountController = TextEditingController(
      text: editingReceivable?.amount.toString(),
    );
    final TextEditingController descriptionController = TextEditingController(
      text: editingReceivable?.description ?? "",
    );
    DateTime selectedDate = editingReceivable?.date ?? DateTime.now();
    DateTime? dueDate = editingReceivable?.dueDate;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          editingReceivable == null ? "Tambah Piutang" : "Edit Piutang",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          children: [
            // Top Section: Debtors & Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QTextField(
                    label: "Peminjam Uang",
                    validator: Validator.required,
                    value: debtorNameController.text,
                    onChanged: (value) {
                      debtorNameController.text = value;
                    },
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  QTextField(
                    label: "Jumlah Piutang (Rp)",
                    validator: Validator.required,
                    value: amountController.text,
                    onChanged: (value) {
                      amountController.text = value;
                    },
                    isNumberOnly: true,
                    prefixIcon: Icons.monetization_on,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Tanggal Peminjaman",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              selectedDate = pickedDate;
                              Get.snackbar("Tanggal Diubah", 
                                "Tanggal peminjaman: ${DateFormat('dd MMM yyyy').format(selectedDate)}");
                            }
                          },
                          child: Text(
                            DateFormat("dd MMM yyyy", "id").format(selectedDate),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Detail Piutang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Receivable Details
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.description,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Detail Informasi",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal Jatuh Tempo",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: dueDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        dueDate = pickedDate;
                                        Get.snackbar("Tanggal Diubah", 
                                          "Tanggal jatuh tempo: ${DateFormat('dd MMM yyyy').format(dueDate!)}");
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dueDate != null 
                                              ? DateFormat('dd MMM yyyy', 'id').format(dueDate!) 
                                              : "Pilih tanggal jatuh tempo",
                                            style: TextStyle(
                                              color: dueDate != null 
                                                ? Colors.black
                                                : Colors.grey.shade600,
                                            ),
                                          ),
                                          Icon(
                                            Icons.event,
                                            color: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              QTextField(
                                label: "Deskripsi",
                                value: descriptionController.text,
                                onChanged: (value) {
                                  descriptionController.text = value;
                                },
                                maxLines: 3,
                                prefixIcon: Icons.description,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate inputs
                  if (debtorNameController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Nama peminjam harus diisi");
                    return;
                  }

                  // Remove formatting characters (like dots or commas) before parsing
                  String cleanAmount = amountController.text.replaceAll(RegExp(r'[^\d]'), '');
                  double amount = double.tryParse(cleanAmount) ?? 0;
                  if (amount <= 0) {
                    Get.snackbar("Error", "Jumlah piutang harus lebih dari 0");
                    return;
                  }

                  ReceivableModel receivable = ReceivableModel(
                    debtorName: debtorNameController.text.trim(),
                    amount: amount,
                    date: selectedDate,
                    dueDate: dueDate,
                    description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                    isSettled: editingReceivable?.isSettled ?? false,
                    settledAt: editingReceivable?.settledAt,
                  );

                  if (editingReceivable != null && index != null) {
                    await controller.updateReceivable(index!, receivable);
                  } else {
                    await controller.addReceivable(receivable);
                  }

                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  editingReceivable == null ? "Simpan Piutang" : "Perbarui Piutang",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}