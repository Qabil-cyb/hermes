import 'package:hive/hive.dart';

part 'dashboard_model.g.dart';

@HiveType(typeId: 3)
class DashboardStats extends HiveObject {
  @HiveField(0)
  double cpuPercent;
  
  @HiveField(1)
  int cpuCount;
  
  @HiveField(2)
  double? cpuFreq;
  
  @HiveField(3)
  int ramTotal;
  
  @HiveField(4)
  int ramUsed;
  
  @HiveField(5)
  double ramPercent;
  
  @HiveField(6)
  int diskTotal;
  
  @HiveField(7)
  int diskUsed;
  
  @HiveField(8)
  double diskPercent;
  
  @HiveField(9)
  double loadAverage1m;
  
  @HiveField(10)
  double loadAverage5m;
  
  @HiveField(11)
  double loadAverage15m;
  
  @HiveField(12)
  int networkSentBytes;
  
  @HiveField(13)
  int networkRecvBytes;
  
  @HiveField(14)
  int uptimeSeconds;
  
  @HiveField(15)
  String hostname;
  
  @HiveField(16)
  String kernelVersion;
  
  @HiveField(17)
  String pythonVersion;
  
  @HiveField(18)
  int dockerContainers;
  
  @HiveField(19)
  double? temperature;
  
  @HiveField(20)
  int usersOnline;
  
  @HiveField(21)
  int usersTotal;
  
  @HiveField(22)
  int inboundsEnabled;
  
  @HiveField(23)
  int inboundsDisabled;
  
  @HiveField(24)
  String serverUptime;

  DashboardStats({
    required this.cpuPercent,
    required this.cpuCount,
    this.cpuFreq,
    required this.ramTotal,
    required this.ramUsed,
    required this.ramPercent,
    required this.diskTotal,
    required this.diskUsed,
    required this.diskPercent,
    required this.loadAverage1m,
    required this.loadAverage5m,
    required this.loadAverage15m,
    required this.networkSentBytes,
    required this.networkRecvBytes,
    required this.uptimeSeconds,
    required this.hostname,
    required this.kernelVersion,
    required this.pythonVersion,
    required this.dockerContainers,
    this.temperature,
    required this.usersOnline,
    required this.usersTotal,
    required this.inboundsEnabled,
    required this.inboundsDisabled,
    required this.serverUptime,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    cpuPercent: (json['cpu_percent'] ?? 0).toDouble(),
    cpuCount: json['cpu_count'] ?? 0,
    cpuFreq: (json['cpu_freq'] ?? 0).toDouble(),
    ramTotal: json['ram_total'] ?? 0,
    ramUsed: json['ram_used'] ?? 0,
    ramPercent: (json['ram_percent'] ?? 0).toDouble(),
    diskTotal: json['disk_total'] ?? 0,
    diskUsed: json['disk_used'] ?? 0,
    diskPercent: (json['disk_percent'] ?? 0).toDouble(),
    loadAverage1m: (json['load_average_1m'] ?? 0).toDouble(),
    loadAverage5m: (json['load_average_5m'] ?? 0).toDouble(),
    loadAverage15m: (json['load_average_15m'] ?? 0).toDouble(),
    networkSentBytes: json['network_sent_bytes'] ?? 0,
    networkRecvBytes: json['network_recv_bytes'] ?? 0,
    uptimeSeconds: json['uptime_seconds'] ?? 0,
    hostname: json['hostname'] ?? '',
    kernelVersion: json['kernel_version'] ?? '',
    pythonVersion: json['python_version'] ?? '',
    dockerContainers: json['docker_containers'] ?? 0,
    temperature: (json['temperature'] ?? 0).toDouble(),
    usersOnline: json['users_online'] ?? 0,
    usersTotal: json['users_total'] ?? 0,
    inboundsEnabled: json['inbounds_enabled'] ?? 0,
    inboundsDisabled: json['inbounds_disabled'] ?? 0,
    serverUptime: json['server_uptime'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'cpu_percent': cpuPercent,
    'cpu_count': cpuCount,
    'cpu_freq': cpuFreq,
    'ram_total': ramTotal,
    'ram_used': ramUsed,
    'ram_percent': ramPercent,
    'disk_total': diskTotal,
    'disk_used': diskUsed,
    'disk_percent': diskPercent,
    'load_average_1m': loadAverage1m,
    'load_average_5m': loadAverage5m,
    'load_average_15m': loadAverage15m,
    'network_sent_bytes': networkSentBytes,
    'network_recv_bytes': networkRecvBytes,
    'uptime_seconds': uptimeSeconds,
    'hostname': hostname,
    'kernel_version': kernelVersion,
    'python_version': pythonVersion,
    'docker_containers': dockerContainers,
    'temperature': temperature,
    'users_online': usersOnline,
    'users_total': usersTotal,
    'inbounds_enabled': inboundsEnabled,
    'inbounds_disabled': inboundsDisabled,
    'server_uptime': serverUptime,
  };
}
