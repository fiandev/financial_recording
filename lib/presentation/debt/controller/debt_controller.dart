import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../../core.dart';

class DebtController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;
  
  final List<DebtModel> debts = <DebtModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshDebts();
  }

  Future<void> refreshDebts() async {
    try {
      isLoading.value = true;
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      debts.assignAll(debtBox.values.toList());
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> addDebt(DebtModel debt) async {
    try {
      isLoading.value = true;
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      await debtBox.add(debt);
      await refreshDebts(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateDebt(int index, DebtModel debt) async {
    try {
      isLoading.value = true;
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      await debtBox.putAt(index, debt);
      await refreshDebts(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteDebt(int index) async {
    try {
      isLoading.value = true;
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      await debtBox.deleteAt(index);
      await refreshDebts(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> settleDebt(int index, bool settled) async {
    try {
      isLoading.value = true;
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      DebtModel debt = debtBox.getAt(index)!;
      debt.isSettled = settled;
      if (settled) {
        debt.settledAt = DateTime.now();
      } else {
        debt.settledAt = null;
      }
      await debt.save();
      await refreshDebts(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteDebtByModel(DebtModel debt) async {
    try {
      isLoading.value = true;
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      await debtBox.delete(debt.key);
      await refreshDebts(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> toggleSettledByModel(DebtModel debt) async {
    try {
      isLoading.value = true;
      debt.isSettled = !debt.isSettled;
      if (debt.isSettled) {
        debt.settledAt = DateTime.now();
      } else {
        debt.settledAt = null;
      }
      await debt.save();
      await refreshDebts(); // Refresh the list
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
      Box<DebtModel> debtBox = Hive.box<DebtModel>('debts');
      DebtModel debt = debtBox.getAt(index)!;
      debt.isSettled = !debt.isSettled;
      if (debt.isSettled) {
        debt.settledAt = DateTime.now();
      } else {
        debt.settledAt = null;
      }
      await debt.save();
      await refreshDebts(); // Refresh the list
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }
}