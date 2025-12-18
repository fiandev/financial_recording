import 'package:hive/hive.dart';

part 'receivable_model.g.dart';

@HiveType(typeId: 5) // Pastikan typeId unik
class ReceivableModel extends HiveObject {
  @HiveField(0)
  String debtorName; // Nama orang yang minjem uang ke lo

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String? description;

  @HiveField(5)
  bool isSettled; // Status apakah sudah dikembalikan

  @HiveField(6)
  DateTime? settledAt; // Tanggal kapan piutang diterima

  ReceivableModel({
    required this.debtorName,
    required this.amount,
    required this.date,
    this.dueDate,
    this.description,
    this.isSettled = false,
    this.settledAt,
  });

  @override
  String toString() {
    return 'ReceivableModel(debtorName: $debtorName, amount: $amount, date: $date, dueDate: $dueDate, description: $description, isSettled: $isSettled)';
  }
}