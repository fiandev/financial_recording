import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_recording/core.dart';

class FormExpenseView extends StatelessWidget {
  const FormExpenseView({super.key, this.transaction});
  final TransactionModel? transaction;

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(FormExpenseController(transaction: transaction));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          transaction != null ? "Edit Pengeluaran" : "Tambah Pengeluaran",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.wallets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: controller.formKey,
          child: Column(
            children: [
              // --- Bagian Atas: Wallet & Kategori ---
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown Wallet
                    QDropdownField(
                      label: "Wallet",
                      validator: Validator.required,
                      items: controller.wallets,
                      // Pastikan value ter-bind ke controller
                      value: controller.selectedWalletKey.value.isEmpty
                          ? null
                          : controller.selectedWalletKey.value,
                      onChanged: (value, label) {
                        controller.selectedWalletKey.value = value ?? "";
                        if (label != null) {
                          // Update logic saldo saat user ganti wallet manual
                          String totalBalance = label
                              .split("Rp. ")[1]
                              .replaceAll(".", "")
                              .replaceAll(",", "");

                          // Set saldo baru ke controller
                          controller.walletBalance.value = int.parse(
                            totalBalance,
                          );

                          // Cek ulang tombol simpan
                          controller.checkEnableStatus();
                        }
                      },
                    ),

                    // Dropdown Category
                    QDropdownField(
                      label: "Kategori Pengeluaran",
                      validator: Validator.required,
                      items: controller.categories,
                      value: controller.selectedCategoryKey.value.isEmpty
                          ? null
                          : controller.selectedCategoryKey.value,
                      onChanged: (value, label) {
                        controller.selectedCategoryKey.value = value ?? "";
                      },
                    ),
                    const SizedBox(height: 12),

                    // Info Total Pengeluaran
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: dangerColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: dangerColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: dangerColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Total Pengeluaran",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: dangerColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Rp ${controller.totalIncome.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: dangerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Header List Item ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Daftar Item",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => controller.addItem(),
                      icon: const Icon(Icons.add_circle, size: 20),
                      label: const Text("Tambah Item"),
                      style: TextButton.styleFrom(foregroundColor: dangerColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // --- List Item Dynamic ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  itemCount: controller.incomeList.length,
                  itemBuilder: (context, i) {
                    // Ambil referensi map item
                    var currentItem = controller.incomeList[i];

                    return Container(
                      // Gunakan Key agar flutter tidak bingung saat render ulang list
                      key: ValueKey("item_$i"),
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
                          // Header Per Item (Nomor & Hapus)
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
                                        color: dangerColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 16,
                                        color: dangerColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Item #${i + 1}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                // Tombol Hapus (Hanya muncul jika item > 1)
                                if (controller.incomeList.length > 1)
                                  InkWell(
                                    onTap: () =>
                                        controller.removeItem(currentItem),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Form Input Item
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                QTextField(
                                  label: "Nama Item",
                                  hint: "Contoh: Nasi Padang, Token Listrik",
                                  validator: Validator.required,
                                  // PENTING: Bind value dari list controller
                                  value: currentItem["name"],
                                  onChanged: (value) {
                                    currentItem["name"] = value;
                                    // Tidak perlu refresh list UI, cukup update data
                                  },
                                ),
                                const SizedBox(height: 12),
                                QTextField(
                                  label: "Nominal (Rp)",
                                  hint: "0",
                                  isNumberOnly: true,
                                  validator: Validator.required,
                                  prefixIcon: Icons.attach_money,
                                  // PENTING: Bind value dari list controller
                                  value: currentItem["nominal"],
                                  onChanged: (value) {
                                    currentItem["nominal"] = value;

                                    // PENTING: Panggil validasi tombol simpan
                                    controller.checkEnableStatus();

                                    // Refresh agar total income di atas update real-time
                                    controller.incomeList.refresh();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // --- Tombol Simpan ---
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
                child: QButton(
                  label: transaction != null
                      ? "Perbarui Pengeluaran"
                      : "Simpan Pengeluaran",
                  color: dangerColor,
                  // Menggunakan status dari controller
                  enabled: controller.isEnable.value,
                  onPressed: () {
                    if (!controller.formKey.currentState!.validate()) {
                      Get.snackbar(
                        "Perhatian",
                        "Mohon lengkapi semua data",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    controller.saveExpense();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
