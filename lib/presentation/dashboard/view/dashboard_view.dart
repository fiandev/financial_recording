import 'package:financial_recording/presentation/history_transaction/view/transaction_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_recording/core.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Best practice: Definisikan controller di awal build atau gunakan GetView
    final controller = Get.put(DashboardController());
    final profileController = Get.put(ProfileController());

    final double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: profileController.isDarkMode.value
          ? Colors.black87
          : Colors.white,
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigasi aman ke ProfileView
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
        padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
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
            CardWallet(controller: controller),
            const SizedBox(height: 20),
            const ButtonTransaction(), // Pastikan const jika widget statis
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Transaksi",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const HistoryTransactionView());
                  },
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(fontSize: 14.0, color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.transactions.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = controller.transactions[index];
                    return ListTile(
                      onTap: () {
                        Get.to(() => TransactionDetailView(transaction: item));
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: item.type == "income"
                          ? const IncomeIcon()
                          : item.type == "expense"
                          ? const ExpenseIcon()
                          : const TransferIcon(),
                      title: Text(
                        item.categoryName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Rp. ${NumberFormat.decimalPattern('id').format(item.amount)}",
                        style: TextStyle(
                          color: item.type == "income"
                              ? Colors.green
                              : item.type == "transfer"
                              ? Colors.blue
                              : const Color.fromARGB(255, 230, 88, 78),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        DateFormat("dd MMM yyyy").format(item.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
