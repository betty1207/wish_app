// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentInfoAdapter extends TypeAdapter<StudentInfo> {
  @override
  final int typeId = 1;

  @override
  StudentInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentInfo(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.studentName)
      ..writeByte(1)
      ..write(obj.wishes)
      ..writeByte(2)
      ..write(obj.profile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
