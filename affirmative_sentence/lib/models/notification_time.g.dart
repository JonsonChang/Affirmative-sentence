// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationTimeAdapter extends TypeAdapter<NotificationTime> {
  @override
  final int typeId = 1;

  @override
  NotificationTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationTime(
      id: fields[0] as String,
      hour: fields[1] as int,
      minute: fields[2] as int,
      enabled: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationTime obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.minute)
      ..writeByte(3)
      ..write(obj.enabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
