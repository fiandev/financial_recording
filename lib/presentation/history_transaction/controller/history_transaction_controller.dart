import 'dart:async'; // Penting untuk StreamSubscription
import 'package:financial_recording/core.dart'; // Sesuaikan dengan import core/model projectmu
import 'package:financial_recording/models/transaction_model/transaction_model.dart';
import 'package:financial_recording/models/wallet_model/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HistoryTransactionController extends GetxController {
  // --- STATE VARIABLES ---
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;

  // Hive Boxes
  var box = Hive.box<TransactionModel>('transactions');
  var walletBox = Hive.box<WalletModel>('walletBox');

  // Data Lists
  final RxList<TransactionModel> histories = <TransactionModel>[].obs;
  final RxList<int> historyKeys = <int>[].obs;
  final RxList<TransactionModel> filteredHistories = <TransactionModel>[].obs;

  // Filter States
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxString selectedWallet = "".obs;
  final RxString selectedCategory = "".obs;
  final RxString selectedType = "Semua".obs;

  // Options for Dropdowns
  final RxList<String> walletOptions = <String>[].obs;
  final RxList<String> categoryOptions = <String>[].obs;

  // Totals
  final RxInt totalIncome = 0.obs;
  final RxInt totalExpense = 0.obs;

  // Listener Variable
  late StreamSubscription _subscription;

  @override
  void onInit() {
    super.onInit();

    // 1. Set Default Date (Bulan Sekarang)
    final now = DateTime.now();
    selectedDateRange.value = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );

    // 2. Load Data Awal
    initializeData();

    // 3. PASANG LISTENER (AUTO REFRESH)
    // Ini mendengarkan segala perubahan di database 'transactions'
    _subscription = box.watch().listen((event) {
      // Jika ada data tambah/hapus/edit, fungsi ini jalan otomatis
      initializeData();
    });
  }

  @override
  void onClose() {
    // 4. Matikan listener saat controller dibuang
    _subscription.cancel();
    super.onClose();
  }

  Future<void> initializeData() async {
    // Kita hapus isLoading = true di sini agar tidak flickering (kedip)
    // saat ada update kecil. Kecuali list masih kosong.
    if (histories.isEmpty) isLoading.value = true;

    try {
      // Clear list lokal sebelum isi ulang
      // Note: Kita tidak clear histories/historyKeys langsung disini agar
      // transisi UI lebih halus, kita assignAll nanti.

      final allKeys = box.keys.toList();
      final allTransactions = box.values.toList();

      // Mapping Key & Value
      List<MapEntry<int, TransactionModel>> pairs = [];
      for (int i = 0; i < allKeys.length; i++) {
        pairs.add(MapEntry(allKeys[i], allTransactions[i]));
      }

      // Sort by Date Descending (Terbaru di atas)
      pairs.sort((a, b) => b.value.createdAt.compareTo(a.value.createdAt));

      // Update Observable Lists
      histories.assignAll(pairs.map((e) => e.value).toList());
      historyKeys.assignAll(pairs.map((e) => e.key).toList());

      // --- Populate Filter Options ---
      final wallets = <String>{};
      final categories = <String>{};

      // Dari transaksi yang ada
      for (var t in allTransactions) {
        if (t.type != 'transfer') {
          wallets.add(t.walletName);
        }
        categories.add(t.categoryName);
      }

      // Dari Master Wallet (untuk memastikan wallet yg belum ada transaksi tetap muncul)
      for (var w in walletBox.values) {
        wallets.add(w.name);
      }

      walletOptions.assignAll(wallets.toList());
      categoryOptions.assignAll(categories.toList());

      // Apply Filters & Calculate Totals
      applyFilters();

      isLoading.value = false;
      hasError.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void applyFilters() {
    List<TransactionModel> temp = List.from(histories);

    // 1. Filter Date Range
    if (selectedDateRange.value != null) {
      temp = temp.where((t) {
        return t.createdAt.isAfter(
              selectedDateRange.value!.start.subtract(const Duration(days: 1)),
            ) &&
            t.createdAt.isBefore(
              selectedDateRange.value!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    // 2. Filter Wallet
    if (selectedWallet.value.isNotEmpty) {
      temp = temp.where((t) {
        if (t.type == 'transfer') {
          return t.walletName.contains(selectedWallet.value);
        }
        return t.walletName == selectedWallet.value;
      }).toList();
    }

    // 3. Filter Category
    if (selectedCategory.value.isNotEmpty) {
      temp = temp
          .where((t) => t.categoryName == selectedCategory.value)
          .toList();
    }

    // 4. Filter Type
    if (selectedType.value != "Semua") {
      String typeKey = "";
      if (selectedType.value == "Pemasukan") typeKey = "income";
      if (selectedType.value == "Pengeluaran") typeKey = "expense";
      if (selectedType.value == "Transfer") typeKey = "transfer";

      if (typeKey.isNotEmpty) {
        temp = temp.where((t) => t.type == typeKey).toList();
      }
    }

    filteredHistories.assignAll(temp);
    calculateTotals();
  }

  void calculateTotals() {
    int income = 0;
    int expense = 0;
    for (var item in filteredHistories) {
      if (item.type == 'income') {
        income += item.amount;
      } else if (item.type == 'expense') {
        expense += item.amount;
      }
      // Transfer biasanya tidak dihitung sebagai income/expense di dashboard total
    }
    totalIncome.value = income;
    totalExpense.value = expense;
  }

  void resetDateRange() {
    selectedDateRange.value = null;
    applyFilters();
  }

  void resetFilters() {
    final now = DateTime.now();
    selectedDateRange.value = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
    selectedWallet.value = "";
    selectedCategory.value = "";
    selectedType.value = "Semua";
    applyFilters();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    // 1. Cari Key transaksi yang akan dihapus
    int? keyToDelete;
    // Menggunakan loop manual karena histories mungkin sudah terfilter/sort beda dengan box asli
    // Kita cari berdasarkan equality object
    for (int i = 0; i < histories.length; i++) {
      if (histories[i] == transaction) {
        keyToDelete = historyKeys[i];
        break;
      }
    }

    if (keyToDelete == null) {
      Get.snackbar("Error", "Transaksi tidak ditemukan");
      return;
    }

    // 2. Reverse Saldo Wallet (Kembalikan Saldo)
    try {
      if (transaction.type == 'income') {
        // Hapus Income -> Kurangi Saldo Wallet
        await _updateWalletBalance(transaction.walletName, -transaction.amount);
      } else if (transaction.type == 'expense') {
        // Hapus Expense -> Tambah Saldo Wallet (Refund)
        await _updateWalletBalance(transaction.walletName, transaction.amount);
      } else if (transaction.type == 'transfer') {
        // Hapus Transfer -> Kembalikan Source (+), Kurangi Dest (-)
        var parts = transaction.walletName.split(' -> ');
        if (parts.length == 2) {
          var sourceName = parts[0];
          var destName = parts[1];
          await _updateWalletBalance(
            sourceName,
            transaction.amount,
          ); // Source balik
          await _updateWalletBalance(
            destName,
            -transaction.amount,
          ); // Dest ditarik
        }
      }

      // 3. Hapus Data dari Hive
      await box.delete(keyToDelete);

      // Note: Tidak perlu panggil initializeData() manual
      // Karena _subscription di onInit akan menangkap event delete ini

      // 4. Update Controller Lain (Opsional tapi disarankan)
      if (Get.isRegistered<WalletController>()) {
        Get.find<WalletController>().initializeData();
      }
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().initializeData();
      }

      Get.snackbar("Sukses", "Transaksi berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus transaksi: $e");
    }
  }

  // Helper function untuk update saldo wallet lebih rapi
  Future<void> _updateWalletBalance(String walletName, int amountChange) async {
    for (var i = 0; i < walletBox.length; i++) {
      var key = walletBox.keyAt(i);
      var wallet = walletBox.get(key);

      if (wallet != null && wallet.name == walletName) {
        wallet.balance += amountChange;

        // Update todayExpense jika perlu (opsional, tergantung logic apps)
        // Kalau menghapus expense, todayExpense juga harus dikurangi
        if (amountChange > 0) {
          // Ini logic simplifikasi, idealnya cek tanggal transaksi == hari ini
        }

        await walletBox.put(key, wallet);
        break;
      }
    }
  }
}
