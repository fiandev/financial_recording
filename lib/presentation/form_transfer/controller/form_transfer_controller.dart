import 'package:financial_recording/models/transaction_model/transaction_model.dart';
import 'package:financial_recording/models/wallet_model/wallet_model.dart';
import 'package:financial_recording/presentation/dashboard/controller/dashboard_controller.dart';
import 'package:financial_recording/presentation/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class FormTransferController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;
  final RxInt counter = 1.obs;

  var box = Hive.box<WalletModel>('walletBox');
  final RxList<Map<String, dynamic>> sourceWallets =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> destWallets = <Map<String, dynamic>>[].obs;

  final RxString selectedSourceWalletKey = "".obs;
  final RxString selectedDestWalletKey = "".obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList<Map<String, String>> incomeList = <Map<String, String>>[].obs;

  TransactionModel? transaction;
  int? transactionKey;

  FormTransferController({this.transaction});

  @override
  void onInit() {
    super.onInit();
    addItem();
    initializeData();
    if (transaction != null) {
      populateForEdit();
    }
  }

  void populateForEdit() {
    if (transaction == null) return;

    // Parse wallet names: "Source -> Dest"
    var parts = transaction!.walletName.split(' -> ');
    if (parts.length == 2) {
      var sourceName = parts[0];
      var destName = parts[1];

      // Find source wallet key
      for (var i = 0; i < box.length; i++) {
        final key = box.keyAt(i);
        final WalletModel wallet = box.get(key)!;
        if (wallet.name == sourceName) {
          selectedSourceWalletKey.value = key.toString();
          break;
        }
      }

      // Find dest wallet key
      for (var i = 0; i < box.length; i++) {
        final key = box.keyAt(i);
        final WalletModel wallet = box.get(key)!;
        if (wallet.name == destName) {
          selectedDestWalletKey.value = key.toString();
          break;
        }
      }
    }

    // Populate items
    incomeList.clear();
    for (var item in transaction!.items) {
      incomeList.add({
        "name": item["name"],
        "nominal": item["nominal"].toString(),
      });
    }

    // Find transaction key
    var boxTransactions = Hive.box<TransactionModel>('transactions');
    for (var i = 0; i < boxTransactions.length; i++) {
      final key = boxTransactions.keyAt(i);
      final TransactionModel t = boxTransactions.get(key)!;
      if (t == transaction) {
        transactionKey = key;
        break;
      }
    }
  }

  Future<void> initializeData() async {
    isLoading.value = true;
    try {
      sourceWallets.clear();
      destWallets.clear();

      for (var i = 0; i < box.length; i++) {
        final key = box.keyAt(i);
        final WalletModel wallet = box.get(key)!;

        // Add to source wallets
        sourceWallets.add({
          "label":
              "${wallet.name} - Rp. ${NumberFormat.decimalPattern('id').format(wallet.balance)}",
          "value": key.toString(),
          "disabled": wallet.balance == 0,
        });

        // Add to dest wallets (can transfer to any wallet)
        destWallets.add({"label": wallet.name, "value": key.toString()});
      }

      isLoading.value = false;
      hasError.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Filter destination wallets to exclude selected source
  List<Map<String, dynamic>> get filteredDestWallets {
    if (selectedSourceWalletKey.value.isEmpty) return destWallets;
    return destWallets
        .where((w) => w['value'] != selectedSourceWalletKey.value)
        .toList();
  }

  void addItem() {
    incomeList.add({"name": "", "nominal": ""});
  }

  void removeItem(Map<String, String> item) {
    incomeList.remove(item);
  }

  // Calculate total transfer amount
  int get totalIncome {
    return incomeList.fold<int>(0, (sum, item) {
      final nominalStr = item["nominal"] ?? "";
      final cleanedStr = nominalStr.replaceAll(".", "");
      final nominal = int.tryParse(cleanedStr) ?? 0;
      return sum + nominal;
    });
  }

  Future<void> saveTransfer() async {
    if (selectedSourceWalletKey.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Pilih Wallet Sumber",
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
      return;
    }
    if (selectedDestWalletKey.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Pilih Wallet Tujuan",
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
      return;
    }
    if (totalIncome <= 0) {
      Get.snackbar(
        "Error",
        "Nominal transfer harus lebih dari 0",
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
      return;
    }

    isLoading.value = true;
    try {
      final sourceKey = int.parse(selectedSourceWalletKey.value);
      final destKey = int.parse(selectedDestWalletKey.value);

      final WalletModel sourceWallet = box.get(sourceKey)!;
      final WalletModel destWallet = box.get(destKey)!;

      if (sourceWallet.balance < totalIncome) {
        Get.snackbar(
          "Error",
          "Saldo wallet sumber tidak mencukupi",
          mainButton: TextButton(
            onPressed: () => Get.back(),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
        isLoading.value = false;
        return;
      }

      final items = incomeList.map((e) {
        final nominalStr = e["nominal"] ?? "0";
        final cleanedStr = nominalStr.replaceAll(".", "");
        return {"name": e["name"], "nominal": int.tryParse(cleanedStr) ?? 0};
      }).toList();

      var transactionBox = Hive.box<TransactionModel>('transactions');

      if (transaction != null && transactionKey != null) {
        // Editing: reverse old transfer
        var oldParts = transaction!.walletName.split(' -> ');
        if (oldParts.length == 2) {
          var oldSourceName = oldParts[0];
          var oldDestName = oldParts[1];
          var oldAmount = transaction!.amount;
          for (var w in box.values) {
            if (w.name == oldSourceName) {
              w.balance += oldAmount; // reverse: add back to source
              await box.put(box.keyAt(box.values.toList().indexOf(w)), w);
            } else if (w.name == oldDestName) {
              w.balance -= oldAmount; // reverse: subtract from dest
              await box.put(box.keyAt(box.values.toList().indexOf(w)), w);
            }
          }
        }

        // Update transaction
        final updatedTransaction = TransactionModel(
          walletName: "${sourceWallet.name} -> ${destWallet.name}",
          categoryName: "Transfer",
          amount: totalIncome,
          items: items,
          createdAt: transaction!.createdAt,
          type: 'transfer',
        );
        await transactionBox.put(transactionKey!, updatedTransaction);

        // Apply new balances
        sourceWallet.balance -= totalIncome;
        await box.put(sourceKey, sourceWallet);
        destWallet.balance += totalIncome;
        await box.put(destKey, destWallet);
      } else {
        // New transfer
        // 1. Update Source Wallet (Decrease Balance)
        sourceWallet.balance -= totalIncome;
        await box.put(sourceKey, sourceWallet);

        // 2. Update Destination Wallet (Increase Balance)
        destWallet.balance += totalIncome;
        await box.put(destKey, destWallet);

        // 3. Create Transaction Record
        final newTransaction = TransactionModel(
          walletName: "${sourceWallet.name} -> ${destWallet.name}",
          categoryName: "Transfer",
          amount: totalIncome,
          items: items,
          createdAt: DateTime.now(),
          type: 'transfer',
        );

        await transactionBox.add(newTransaction);
      }

      // 4. Refresh Controllers
      if (Get.isRegistered<WalletController>()) {
        Get.find<WalletController>().refresh();
      }
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().initializeData();
      }

      Get.back();
      Get.snackbar(
        "Sukses",
        transaction != null
            ? "Transfer berhasil diperbarui"
            : "Transfer berhasil",
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal transfer: $e",
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
