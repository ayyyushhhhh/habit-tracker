// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      title: fields[0] as String,
      icon: fields[1] as String,
      isDone: fields[2] as bool,
      completedDates: (fields[4] as List?)?.cast<DateTime>(),
      skipDates: (fields[5] as List?)?.cast<DateTime>(),
      index: fields[6] as int?,
      lastIndex: fields[7] as int?,
      streaks: fields[8] as int?,
      dateCreated: fields[9] as DateTime?,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.isDone)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.completedDates)
      ..writeByte(5)
      ..write(obj.skipDates)
      ..writeByte(6)
      ..write(obj.index)
      ..writeByte(7)
      ..write(obj.lastIndex)
      ..writeByte(8)
      ..write(obj.streaks)
      ..writeByte(9)
      ..write(obj.dateCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
