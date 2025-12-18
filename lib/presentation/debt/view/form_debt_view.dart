import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_recording/core.dart';
import 'package:intl/intl.dart';
import '../controller/debt_controller.dart';

class FormDebtView extends StatelessWidget {
  final DebtModel? editingDebt;
  final int? index;

  const FormDebtView({super.key, this.editingDebt, this.index});

  @override
  Widget build(BuildContext context) {
    final DebtController controller = Get.find<DebtController>() ?? Get.put(DebtController());

    // Initialize form values
    final TextEditingController creditorNameController = TextEditingController(
      text: editingDebt?.creditorName,
    );
    final TextEditingController amountController = TextEditingController(
      text: editingDebt?.amount.toString(),
    );
    final TextEditingController descriptionController = TextEditingController(
      text: editingDebt?.description ?? "",
    );
    DateTime selectedDate = editingDebt?.date ?? DateTime.now();
    DateTime? dueDate = editingDebt?.dueDate;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          editingDebt == null ? "Tambah Hutang" : "Edit Hutang",
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
            // Top Section: Creditors & Amount
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
                    label: "Pemberi Pinjaman",
                    validator: Validator.required,
                    value: creditorNameController.text,
                    onChanged: (value) {
                      creditorNameController.text = value;
                    },
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  QTextField(
                    label: "Jumlah Hutang (Rp)",
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
                              "Tanggal Pinjaman",
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
                              // Update UI - we'll need to rebuild the widget or use a state management solution
                              // For now, we'll show a snackbar to indicate the date was selected
                              Get.snackbar("Tanggal Diubah", 
                                "Tanggal pinjaman: ${DateFormat('dd MMM yyyy').format(selectedDate)}");
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
                    "Detail Hutang",
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

            // Debt Details
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
                                        // Since we can't update the text field directly with the QTextField approach,
                                        // we can trigger a rebuild or show a snackbar
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
                  if (creditorNameController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Nama pemberi pinjaman harus diisi");
                    return;
                  }

                  // Remove formatting characters (like dots or commas) before parsing
                  String cleanAmount = amountController.text.replaceAll(RegExp(r'[^\d]'), '');
                  double amount = double.tryParse(cleanAmount) ?? 0;
                  if (amount <= 0) {
                    Get.snackbar("Error", "Jumlah hutang harus lebih dari 0");
                    return;
                  }

                  DebtModel debt = DebtModel(
                    creditorName: creditorNameController.text.trim(),
                    amount: amount,
                    date: selectedDate,
                    dueDate: dueDate,
                    description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                    isSettled: editingDebt?.isSettled ?? false,
                    settledAt: editingDebt?.settledAt,
                  );

                  if (editingDebt != null && index != null) {
                    await controller.updateDebt(index!, debt);
                  } else {
                    await controller.addDebt(debt);
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
                  editingDebt == null ? "Simpan Hutang" : "Perbarui Hutang",
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