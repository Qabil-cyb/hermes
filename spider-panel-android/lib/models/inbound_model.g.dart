// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InboundAdapter extends TypeAdapter<Inbound> {
  @override
  final int typeId = 2;

  @override
  Inbound read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Inbound(
      id: fields[0] as String,
      remark: fields[1] as String?,
      port: fields[2] as int,
      protocol: fields[3] as String,
      security: fields[4] as String?,
      network: fields[5] as String?,
      settings: (fields[6] as Map?)?.cast<String, dynamic>(),
      streamSettings: (fields[7] as Map?)?.cast<String, dynamic>(),
      sniffing: (fields[8] as Map?)?.cast<String, dynamic>(),
      tag: fields[9] as String?,
      isActive: fields[10] as bool,
      enable: fields[11] as bool,
      trafficUsed: fields[12] as int,
      createdAt: fields[13] as String,
      updatedAt: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Inbound obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.remark)
      ..writeByte(2)
      ..write(obj.port)
      ..writeByte(3)
      ..write(obj.protocol)
      ..writeByte(4)
      ..write(obj.security)
      ..writeByte(5)
      ..write(obj.network)
      ..writeByte(6)
      ..write(obj.settings)
      ..writeByte(7)
      ..write(obj.streamSettings)
      ..writeByte(8)
      ..write(obj.sniffing)
      ..writeByte(9)
      ..write(obj.tag)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.enable)
      ..writeByte(12)
      ..write(obj.trafficUsed)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InboundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
