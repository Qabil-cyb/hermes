import 'package:hive/hive.dart';

part 'inbound_model.g.dart';

@HiveType(typeId: 2)
class Inbound extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String? remark;
  
  @HiveField(2)
  int port;
  
  @HiveField(3)
  String protocol;
  
  @HiveField(4)
  String? security;
  
  @HiveField(5)
  String? network;
  
  @HiveField(6)
  Map<String, dynamic>? settings;
  
  @HiveField(7)
  Map<String, dynamic>? streamSettings;
  
  @HiveField(8)
  Map<String, dynamic>? sniffing;
  
  @HiveField(9)
  String? tag;
  
  @HiveField(10)
  bool isActive;
  
  @HiveField(11)
  bool enable;
  
  @HiveField(12)
  int trafficUsed;
  
  @HiveField(13)
  String createdAt;
  
  @HiveField(14)
  String updatedAt;

  Inbound({
    required this.id,
    this.remark,
    required this.port,
    required this.protocol,
    this.security,
    this.network,
    this.settings,
    this.streamSettings,
    this.sniffing,
    this.tag,
    this.isActive = true,
    this.enable = true,
    this.trafficUsed = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inbound.fromJson(Map<String, dynamic> json) => Inbound(
    id: json['id'] ?? '',
    remark: json['remark'],
    port: json['port'] ?? 0,
    protocol: json['protocol'] ?? '',
    security: json['security'],
    network: json['network'],
    settings: json['settings'],
    streamSettings: json['stream_settings'],
    sniffing: json['sniffing'],
    tag: json['tag'],
    isActive: json['is_active'] ?? true,
    enable: json['enable'] ?? true,
    trafficUsed: json['traffic_used'] ?? 0,
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'remark': remark,
    'port': port,
    'protocol': protocol,
    'security': security,
    'network': network,
    'settings': settings,
    'stream_settings': streamSettings,
    'sniffing': sniffing,
    'tag': tag,
    'is_active': isActive,
    'enable': enable,
    'traffic_used': trafficUsed,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
