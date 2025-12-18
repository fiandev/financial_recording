import 'package:hive/hive.dart';

part 'debt_model.g.dart'; // wajib

@HiveType(typeId: 4)
class DebtModel extends HiveObject {
  @HiveField(0)
  String creditorName; // Nama orang yang lo minjem uang

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String? description;

  @HiveField(5)
  bool isSettled; // Status apakah sudah dibayar

  @HiveField(6)
  DateTime? settledAt; // Tanggal kapan hutang dilunasi

  DebtModel({
    required this.creditorName,
    required this.amount,
    required this.date,
    this.dueDate,
    this.description,
    this.isSettled = false,
    this.settledAt,
  });

  @override
  String toString() {
    return 'DebtModel(creditorName: $creditorName, amount: $amount, date: $date, dueDate: $dueDate, description: $description, isSettled: $isSettled)';
  }
}