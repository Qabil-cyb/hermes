// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardStatsAdapter extends TypeAdapter<DashboardStats> {
  @override
  final int typeId = 3;

  @override
  DashboardStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardStats(
      cpuPercent: fields[0] as double,
      cpuCount: fields[1] as int,
      cpuFreq: fields[2] as double?,
      ramTotal: fields[3] as int,
      ramUsed: fields[4] as int,
      ramPercent: fields[5] as double,
      diskTotal: fields[6] as int,
      diskUsed: fields[7] as int,
      diskPercent: fields[8] as double,
      loadAverage1m: fields[9] as double,
      loadAverage5m: fields[10] as double,
      loadAverage15m: fields[11] as double,
      networkSentBytes: fields[12] as int,
      networkRecvBytes: fields[13] as int,
      uptimeSeconds: fields[14] as int,
      hostname: fields[15] as String,
      kernelVersion: fields[16] as String,
      pythonVersion: fields[17] as String,
      dockerContainers: fields[18] as int,
      temperature: fields[19] as double?,
      usersOnline: fields[20] as int,
      usersTotal: fields[21] as int,
      inboundsEnabled: fields[22] as int,
      inboundsDisabled: fields[23] as int,
      serverUptime: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardStats obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.cpuPercent)
      ..writeByte(1)
      ..write(obj.cpuCount)
      ..writeByte(2)
      ..write(obj.cpuFreq)
      ..writeByte(3)
      ..write(obj.ramTotal)
      ..writeByte(4)
      ..write(obj.ramUsed)
      ..writeByte(5)
      ..write(obj.ramPercent)
      ..writeByte(6)
      ..write(obj.diskTotal)
      ..writeByte(7)
      ..write(obj.diskUsed)
      ..writeByte(8)
      ..write(obj.diskPercent)
      ..writeByte(9)
      ..write(obj.loadAverage1m)
      ..writeByte(10)
      ..write(obj.loadAverage5m)
      ..writeByte(11)
      ..write(obj.loadAverage15m)
      ..writeByte(12)
      ..write(obj.networkSentBytes)
      ..writeByte(13)
      ..write(obj.networkRecvBytes)
      ..writeByte(14)
      ..write(obj.uptimeSeconds)
      ..writeByte(15)
      ..write(obj.hostname)
      ..writeByte(16)
      ..write(obj.kernelVersion)
      ..writeByte(17)
      ..write(obj.pythonVersion)
      ..writeByte(18)
      ..write(obj.dockerContainers)
      ..writeByte(19)
      ..write(obj.temperature)
      ..writeByte(20)
      ..write(obj.usersOnline)
      ..writeByte(21)
      ..write(obj.usersTotal)
      ..writeByte(22)
      ..write(obj.inboundsEnabled)
      ..writeByte(23)
      ..write(obj.inboundsDisabled)
      ..writeByte(24)
      ..write(obj.serverUptime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
