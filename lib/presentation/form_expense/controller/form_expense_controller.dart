import 'package:financial_recording/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class FormExpenseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxBool isEnable = true.obs;
  final RxString errorMessage = "".obs;
  // Hapus counter jika tidak dipakai

  var box = Hive.box<WalletModel>('walletBox');
  var boxCategories = Hive.box<CategoryModel>('categories');
  var boxTransactions = Hive.box<TransactionModel>('transactions');

  RxList<Map<String, String>> incomeList = <Map<String, String>>[].obs;
  final RxList<Map<String, dynamic>> wallets = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> categories = <Map<String, String>>[].obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxInt walletBalance = 0.obs; // Saldo untuk validasi
  final RxString selectedWalletKey = "".obs;
  final RxString selectedCategoryKey = "".obs;

  TransactionModel? transaction;
  int? transactionKey;

  FormExpenseController({this.transaction});

  @override
  void onInit() {
    super.onInit();
    initializeData().then((_) {
      if (transaction != null) {
        populateForEdit();
      } else {
        addItem();
      }
    });
  }

  void populateForEdit() {
    if (transaction == null) return;

    // A. Cari Key Wallet
    for (var i = 0; i < box.length; i++) {
      final key = box.keyAt(i);
      final WalletModel wallet = box.get(key)!;
      if (wallet.name == transaction!.walletName) {
        selectedWalletKey.value = key.toString();

        walletBalance.value = wallet.balance + transaction!.amount;
        break;
      }
    }

    // B. Cari Key Category
    for (var i = 0; i < boxCategories.length; i++) {
      final key = boxCategories.keyAt(i);
      final CategoryModel category = boxCategories.get(key)!;
      if (category.name == transaction!.categoryName) {
        selectedCategoryKey.value = key.toString();
        break;
      }
    }

    // C. Populate Items
    incomeList.clear();
    for (var item in transaction!.items) {
      incomeList.add({
        "name": item["name"],
        "nominal": item["nominal"].toString(),
      });
    }

    // D. Cari Key Transaksi untuk update nanti
    for (var i = 0; i < boxTransactions.length; i++) {
      final key = boxTransactions.keyAt(i);
      final TransactionModel t = boxTransactions.get(key)!;
      if (t == transaction) {
        transactionKey = key;
        break;
      }
    }

    checkEnableStatus();
  }

  Future<void> initializeData() async {
    wallets.clear();
    categories.clear();

    for (var i = 0; i < box.length; i++) {
      final key = box.keyAt(i);
      final WalletModel wallet = box.get(key)!;
      wallets.add({
        "label":
            "${wallet.name} - ${"Rp. ${NumberFormat.decimalPattern('id').format(wallet.balance)}"}",
        "value": key.toString(),
        "disabled": wallet.balance == 0,
      });
    }

    wallets.sort((a, b) {
      double balanceA = double.parse(
        a['label'].split('Rp. ')[1].replaceAll('.', '').replaceAll(',', ''),
      );
      double balanceB = double.parse(
        b['label'].split('Rp. ')[1].replaceAll('.', '').replaceAll(',', ''),
      );
      return balanceB.compareTo(balanceA);
    });

    for (var i = 0; i < boxCategories.length; i++) {
      final key = boxCategories.keyAt(i);
      final CategoryModel category = boxCategories.get(key)!;
      if (category.type == "income") {
        continue;
      }
      categories.add({"label": category.name, "value": key.toString()});
    }
  }

  void addItem() {
    incomeList.add({"name": "", "nominal": ""});
    checkEnableStatus();
  }

  void removeItem(Map<String, String> item) {
    incomeList.remove(item);
    checkEnableStatus();
  }

  int get totalIncome {
    return incomeList.fold<int>(0, (sum, item) {
      final nominalStr = item["nominal"] ?? "";
      final cleanedStr = nominalStr.replaceAll(".", "");
      final nominal = int.tryParse(cleanedStr) ?? 0;
      return sum + nominal;
    });
  }

  void checkEnableStatus() {
    if (walletBalance.value > 0 && totalIncome > 0) {
      isEnable.value = totalIncome <= walletBalance.value;
    } else {
      isEnable.value = false;
    }
  }

  Future<void> saveExpense() async {
    if (selectedWalletKey.value.isEmpty) {
      Get.snackbar("Error", "Pilih Wallet terlebih dahulu");
      return;
    }
    if (selectedCategoryKey.value.isEmpty) {
      Get.snackbar("Error", "Pilih Kategori terlebih dahulu");
      return;
    }

    isLoading.value = true;
    try {
      final walletKey = int.parse(selectedWalletKey.value);
      final categoryKey = int.parse(selectedCategoryKey.value);

      final WalletModel wallet = box.get(walletKey)!;
      final CategoryModel category = boxCategories.get(categoryKey)!;

      List<Map<String, dynamic>> items = incomeList.map((e) {
        final nominalStr = e["nominal"] ?? "0";
        final cleanedStr = nominalStr.replaceAll(".", "");
        return {"name": e["name"], "nominal": int.tryParse(cleanedStr) ?? 0};
      }).toList();

      if (transaction != null && transactionKey != null) {
        WalletModel? oldWallet;
        int? oldWalletKey;

        if (wallet.name == transaction!.walletName) {
          oldWallet = wallet;
          oldWalletKey = walletKey;
        } else {
          // Jika user mengganti wallet, kita harus cari wallet lama untuk dikembalikan saldonya
          for (var i = 0; i < box.length; i++) {
            var key = box.keyAt(i);
            var w = box.get(key);
            if (w?.name == transaction!.walletName) {
              oldWallet = w;
              oldWalletKey = key;
              break;
            }
          }
        }

        if (oldWallet != null && oldWalletKey != null) {
          oldWallet.balance += transaction!.amount;
          oldWallet.todayExpense =
              (oldWallet.todayExpense ?? 0) - transaction!.amount;
          await box.put(oldWalletKey, oldWallet);
        }

        final updatedTransaction = TransactionModel(
          walletName: wallet.name,
          categoryName: category.name,
          amount: totalIncome,
          items: items,
          createdAt: transaction!.createdAt,
          type: 'expense',
        );
        await boxTransactions.put(transactionKey!, updatedTransaction);

        final WalletModel targetWallet = box.get(walletKey)!;

        targetWallet.balance -= totalIncome;
        targetWallet.todayExpense =
            (targetWallet.todayExpense ?? 0) + totalIncome;
        await box.put(walletKey, targetWallet);
      } else {
        // --- LOGIKA BARU ---
        final newTransaction = TransactionModel(
          walletName: wallet.name,
          categoryName: category.name,
          amount: totalIncome,
          items: items,
          createdAt: DateTime.now(),
          type: 'expense',
        );

        await boxTransactions.add(newTransaction);

        wallet.balance -= totalIncome;
        wallet.todayExpense = (wallet.todayExpense ?? 0) + totalIncome;
        await box.put(walletKey, wallet);
      }

      final controllerWallet = Get.put<WalletController>(WalletController());

      final controllerDashboard = Get.put<DashboardController>(
        DashboardController(),
      );

      controllerDashboard.initializeData();
      controllerWallet.refresh();

      Get.back(); // Tutup form
      Get.snackbar(
        "Sukses",
        transaction != null
            ? "Pengeluaran berhasil diperbarui"
            : "Pengeluaran berhasil disimpan",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "Gagal menyimpan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
