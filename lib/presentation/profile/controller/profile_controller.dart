import 'dart:convert';
import 'dart:io';
import 'package:financial_recording/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileController extends GetxController {
  final RxString userName = "User".obs;
  final RxString userEmail = "user@example.com".obs;
  final RxString appVersion = "1.0.0".obs;
  final RxString buildNumber = "1".obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    // --- FIX UTAMA DISINI ---
    // Membungkus proses load data agar dijalankan SETELAH frame UI selesai dirender.
    // Ini solusi untuk error "setState() called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPackageInfo();
      _loadDarkModePreference();
    });
  }

  void _loadDarkModePreference() {
    // Pastikan DBService sudah diinit di main.dart
    bool savedDarkMode = DBService.get("dark_mode") == "true";

    if (savedDarkMode) {
      isDarkMode.value = savedDarkMode;
      _updateAppTheme();
    }
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;

    DBService.set("dark_mode", isDarkMode.value.toString());
    _updateAppTheme();
  }

  void _updateAppTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _loadPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      print("Error loading package info: $e");
    }
  }

  void updatePrimaryColor(Color color) {
    // Pastikan variable global primaryColor di core.dart bukan final
    primaryColor = color;
    DBService.set("primary_color", color.value.toString());

    // Memaksa update tema
    Get.changeTheme(getDefaultTheme());
    // Force App Update kadang tidak perlu jika state management sudah reaktif,
    // tapi jika diperlukan biarkan saja:
    Get.forceAppUpdate();

    Get.snackbar(
      "Berhasil",
      "Warna tema berhasil diubah!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }

  Future<void> openBuyMeCoffee() async {
    final Uri url = Uri.parse(
      'https://saweria.co/fiandev',
    ); // Ganti URL sesuai kebutuhan
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        "Error",
        "Could not launch URL",
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    }
  }

  Future<void> backupData() async {
    try {
      final walletBox = Hive.box<WalletModel>('walletBox');
      final categoryBox = Hive.box<CategoryModel>('categories');
      final transactionBox = Hive.box<TransactionModel>('transactions');

      final Map<String, dynamic> backupMap = {
        "wallets": walletBox.values
            .map(
              (w) => {
                // "id": w.key.toString(), // Key di-generate ulang saat restore
                "name": w.name,
                "balance": w.balance,
                "todayExpense": w.todayExpense,
                "gradient": w.gradient,
                "iconPath": w.iconPath,
              },
            )
            .toList(),
        "categories": categoryBox.values
            .map(
              (c) => {
                "name": c.name,
                "iconPath": c.iconPath,
                "type": c.type,
                "color": c.color,
              },
            )
            .toList(),
        "transactions": transactionBox.values
            .map(
              (t) => {
                "walletName": t.walletName,
                "categoryName": t.categoryName,
                "amount": t.amount,
                "items": t
                    .items, // Pastikan items adalah List<Map> yang serializable
                "createdAt": t.createdAt.millisecondsSinceEpoch,
                "type": t.type,
              },
            )
            .toList(),
      };

      String jsonString = jsonEncode(backupMap);

      // Save file
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Simpan File Backup',
        fileName:
            'financial_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final File file = File(outputFile);
        await file.writeAsString(jsonString);
        Get.snackbar(
          "Backup Berhasil",
          "Data tersimpan di $outputFile",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () => Get.back(),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Backup Gagal",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    }
  }

  Future<void> restoreData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String jsonString = await file.readAsString();
        Map<String, dynamic> data = jsonDecode(jsonString);

        // Restore Wallets
        var walletBox = Hive.box<WalletModel>('walletBox');
        await walletBox.clear();
        if (data["wallets"] != null) {
          for (var item in data["wallets"]) {
            List<int> gradient = (item["gradient"] as List)
                .map((e) => e as int)
                .toList();

            var w = WalletModel(
              name: item["name"],
              balance: (item["balance"] as num).toInt(), // Safety cast
              iconPath: item["iconPath"],
              gradient: gradient,
              todayExpense: (item["todayExpense"] as num?)?.toInt(),
            );
            await walletBox.add(w);
          }
        }

        // Restore Categories
        var categoryBox = Hive.box<CategoryModel>('categories');
        await categoryBox.clear();
        if (data["categories"] != null) {
          for (var item in data["categories"]) {
            var c = CategoryModel(
              name: item["name"],
              iconPath: item["iconPath"],
              type: item["type"],
              color: item["color"],
            );
            await categoryBox.add(c);
          }
        }

        // Restore Transactions
        var transactionBox = Hive.box<TransactionModel>('transactions');
        await transactionBox.clear();
        if (data["transactions"] != null) {
          for (var item in data["transactions"]) {
            var t = TransactionModel(
              walletName: item["walletName"],
              categoryName: item["categoryName"],
              amount: (item["amount"] as num).toInt(),
              items: List<Map<String, dynamic>>.from(item["items"] ?? []),
              createdAt: DateTime.fromMillisecondsSinceEpoch(item["createdAt"]),
              type: item["type"],
            );
            await transactionBox.add(t);
          }
        }

        Get.snackbar(
          "Restore Berhasil",
          "Data telah dipulihkan. Restart aplikasi direkomendasikan.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () => Get.back(),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Restore Gagal",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    }
  }

  void logout() async {
    // exit(0) tidak disarankan oleh Apple/Google Play, tapi jika kamu mau force close:
    exit(0);
  }
}
