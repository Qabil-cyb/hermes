// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProxyConfigAdapter extends TypeAdapter<ProxyConfig> {
  @override
  final int typeId = 6;

  @override
  ProxyConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProxyConfig(
      id: fields[0] as String,
      country: fields[1] as String?,
      ip: fields[2] as String,
      port: fields[3] as int,
      type: fields[4] as String,
      status: fields[5] as String,
      assignedUserId: fields[6] as String?,
      createdAt: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProxyConfig obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.ip)
      ..writeByte(3)
      ..write(obj.port)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.assignedUserId)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProxyConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
