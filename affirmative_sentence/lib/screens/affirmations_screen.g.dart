// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affirmations_screen.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AffirmationAdapter extends TypeAdapter<Affirmation> {
  @override
  final int typeId = 2;

  @override
  Affirmation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Affirmation(
      fields[0] as String,
      isEnabled: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Affirmation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffirmationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AffirmationGroupAdapter extends TypeAdapter<AffirmationGroup> {
  @override
  final int typeId = 3;

  @override
  AffirmationGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AffirmationGroup(
      fields[0] as String,
      affirmations: (fields[1] as List?)?.cast<Affirmation>(),
    );
  }

  @override
  void write(BinaryWriter writer, AffirmationGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.affirmations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffirmationGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
