// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_block_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeBlockModelAdapter extends TypeAdapter<TimeBlockModel> {
  @override
  final int typeId = 1;

  @override
  TimeBlockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeBlockModel(
      from: fields[0] as TimeOfDay,
      to: fields[1] as TimeOfDay,
      taskTitle: fields[2] as String,
      taskDescription: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimeBlockModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.from)
      ..writeByte(1)
      ..write(obj.to)
      ..writeByte(2)
      ..write(obj.taskTitle)
      ..writeByte(3)
      ..write(obj.taskDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeBlockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
