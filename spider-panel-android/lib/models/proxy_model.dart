import 'package:hive/hive.dart';

part 'proxy_model.g.dart';

@HiveType(typeId: 6)
class ProxyConfig extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String? country;
  
  @HiveField(2)
  String ip;
  
  @HiveField(3)
  int port;
  
  @HiveField(4)
  String type;
  
  @HiveField(5)
  String status;
  
  @HiveField(6)
  String? assignedUserId;
  
  @HiveField(7)
  String createdAt;

  ProxyConfig({
    required this.id,
    this.country,
    required this.ip,
    required this.port,
    required this.type,
    required this.status,
    this.assignedUserId,
    required this.createdAt,
  });

  factory ProxyConfig.fromJson(Map<String, dynamic> json) => ProxyConfig(
    id: json['id'] ?? '',
    country: json['country'],
    ip: json['ip'] ?? '',
    port: json['port'] ?? 0,
    type: json['type'] ?? 'HTTP',
    status: json['status'] ?? 'active',
    assignedUserId: json['assigned_user_id'],
    createdAt: json['created_at'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'country': country,
    'ip': ip,
    'port': port,
    'type': type,
    'status': status,
    'assigned_user_id': assignedUserId,
    'created_at': createdAt,
  };
}
