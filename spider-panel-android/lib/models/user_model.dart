import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String username;
  
  @HiveField(2)
  String? email;
  
  @HiveField(3)
  String? name;
  
  @HiveField(4)
  String? avatarUrl;
  
  @HiveField(5)
  String theme;
  
  @HiveField(6)
  bool passwordLockEnabled;
  
  @HiveField(7)
  String createdAt;
  
  @HiveField(8)
  String updatedAt;

  User({
    required this.id,
    required this.username,
    this.email,
    this.name,
    this.avatarUrl,
    this.theme = 'blue',
    this.passwordLockEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? '',
    username: json['username'] ?? '',
    email: json['email'],
    name: json['name'],
    avatarUrl: json['avatar_url'],
    theme: json['theme'] ?? 'blue',
    passwordLockEnabled: json['password_lock_enabled'] ?? false,
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'name': name,
    'avatar_url': avatarUrl,
    'theme': theme,
    'password_lock_enabled': passwordLockEnabled,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

@HiveType(typeId: 1)
class Client extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String username;
  
  @HiveField(2)
  String inboundId;
  
  @HiveField(3)
  String uuid;
  
  @HiveField(4)
  int trafficLimit;
  
  @HiveField(5)
  int trafficUsed;
  
  @HiveField(6)
  String? expireAt;
  
  @HiveField(7)
  int ipLimit;
  
  @HiveField(8)
  String? description;
  
  @HiveField(9)
  bool isActive;
  
  @HiveField(10)
  String status;
  
  @HiveField(11)
  String createdAt;
  
  @HiveField(12)
  String updatedAt;

  Client({
    required this.id,
    required this.username,
    required this.inboundId,
    required this.uuid,
    this.trafficLimit = 0,
    this.trafficUsed = 0,
    this.expireAt,
    this.ipLimit = 0,
    this.description,
    this.isActive = true,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json['id'] ?? '',
    username: json['username'] ?? '',
    inboundId: json['inbound_id'] ?? '',
    uuid: json['uuid'] ?? '',
    trafficLimit: json['traffic_limit'] ?? 0,
    trafficUsed: json['traffic_used'] ?? 0,
    expireAt: json['expire_at'],
    ipLimit: json['ip_limit'] ?? 0,
    description: json['description'],
    isActive: json['is_active'] ?? true,
    status: json['status'] ?? 'active',
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'inbound_id': inboundId,
    'uuid': uuid,
    'traffic_limit': trafficLimit,
    'traffic_used': trafficUsed,
    'expire_at': expireAt,
    'ip_limit': ipLimit,
    'description': description,
    'is_active': isActive,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
