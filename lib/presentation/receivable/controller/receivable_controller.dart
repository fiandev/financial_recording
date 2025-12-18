import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../../core.dart';

class ReceivableController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;
  
  final List<ReceivableModel> receivables = <ReceivableModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshReceivables();
  }

  Future<void> refreshReceivables() async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      receivables.assignAll(receivableBox.values.toList());
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> addReceivable(ReceivableModel receivable) async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      await receivableBox.add(receivable);
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateReceivable(int index, ReceivableModel receivable) async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      await receivableBox.putAt(index, receivable);
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteReceivable(int index) async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      await receivableBox.deleteAt(index);
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> settleReceivable(int index, bool settled) async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      ReceivableModel receivable = receivableBox.getAt(index)!;
      receivable.isSettled = settled;
      if (settled) {
        receivable.settledAt = DateTime.now();
      } else {
        receivable.settledAt = null;
      }
      await receivable.save();
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteReceivableByModel(ReceivableModel receivable) async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      await receivableBox.delete(receivable.key);
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> toggleSettledByModel(ReceivableModel receivable) async {
    try {
      isLoading.value = true;
      receivable.isSettled = !receivable.isSettled;
      if (receivable.isSettled) {
        receivable.settledAt = DateTime.now();
      } else {
        receivable.settledAt = null;
      }
      await receivable.save();
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> toggleSettled(int index) async {
    try {
      isLoading.value = true;
      Box<ReceivableModel> receivableBox = Hive.box<ReceivableModel>('receivables');
      ReceivableModel receivable = receivableBox.getAt(index)!;
      receivable.isSettled = !receivable.isSettled;
      if (receivable.isSettled) {
        receivable.settledAt = DateTime.now();
      } else {
        receivable.settledAt = null;
      }
      await receivable.save();
      await refreshReceivables(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }
}