// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tasks _$TasksFromJson(Map<String, dynamic> json) {
  return Tasks(
    from: json['from'] as String,
    to: json['to'] as String,
    taskTitle: json['taskTitle'] as String,
    taskDescription: json['taskDescription'] as String,
  );
}

Map<String, dynamic> _$TasksToJson(Tasks instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'taskTitle': instance.taskTitle,
      'taskDescription': instance.taskDescription,
    };
