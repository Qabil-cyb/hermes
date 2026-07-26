import 'package:hive/hive.dart';

part 'api_key_model.g.dart';

@HiveType(typeId: 4)
class ApiKey extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String? owner;
  
  @HiveField(2)
  String? description;
  
  @HiveField(3)
  String createdAt;
  
  @HiveField(4)
  String? expireAt;
  
  @HiveField(5)
  String? lastUsed;
  
  @HiveField(6)
  String? deviceId;
  
  @HiveField(7)
  bool enabled;
  
  @HiveField(8)
  Map<String, dynamic>? permissions;
  
  @HiveField(9)
  String? rawKey;

  ApiKey({
    required this.id,
    this.owner,
    this.description,
    required this.createdAt,
    this.expireAt,
    this.lastUsed,
    this.deviceId,
    this.enabled = true,
    this.permissions,
    this.rawKey,
  });

  factory ApiKey.fromJson(Map<String, dynamic> json) => ApiKey(
    id: json['id'] ?? '',
    owner: json['owner'],
    description: json['description'],
    createdAt: json['created_at'] ?? '',
    expireAt: json['expire_at'],
    lastUsed: json['last_used'],
    deviceId: json['device_id'],
    enabled: json['enabled'] ?? true,
    permissions: json['permissions'],
    rawKey: json['raw_key'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner': owner,
    'description': description,
    'created_at': createdAt,
    'expire_at': expireAt,
    'last_used': lastUsed,
    'device_id': deviceId,
    'enabled': enabled,
    'permissions': permissions,
    'raw_key': rawKey,
  };
}
