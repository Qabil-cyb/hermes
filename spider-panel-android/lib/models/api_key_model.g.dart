// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiKeyAdapter extends TypeAdapter<ApiKey> {
  @override
  final int typeId = 4;

  @override
  ApiKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiKey(
      id: fields[0] as String,
      owner: fields[1] as String?,
      description: fields[2] as String?,
      createdAt: fields[3] as String,
      expireAt: fields[4] as String?,
      lastUsed: fields[5] as String?,
      deviceId: fields[6] as String?,
      enabled: fields[7] as bool,
      permissions: (fields[8] as Map?)?.cast<String, dynamic>(),
      rawKey: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ApiKey obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.owner)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.expireAt)
      ..writeByte(5)
      ..write(obj.lastUsed)
      ..writeByte(6)
      ..write(obj.deviceId)
      ..writeByte(7)
      ..write(obj.enabled)
      ..writeByte(8)
      ..write(obj.permissions)
      ..writeByte(9)
      ..write(obj.rawKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
