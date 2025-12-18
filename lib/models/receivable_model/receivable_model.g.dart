// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receivable_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceivableModelAdapter extends TypeAdapter<ReceivableModel> {
  @override
  final int typeId = 5;

  @override
  ReceivableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceivableModel(
      debtorName: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
      dueDate: fields[3] as DateTime?,
      description: fields[4] as String?,
      isSettled: fields[5] as bool,
      settledAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReceivableModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.debtorName)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isSettled)
      ..writeByte(6)
      ..write(obj.settledAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceivableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
