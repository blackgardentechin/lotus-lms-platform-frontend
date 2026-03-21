import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User Model
@JsonSerializable()
class UserModel {
  final String name;
  final String username;
  final String email;
  @JsonKey(name: 'tenant_id')
  final String tenantId;
  final String role;
  
  const UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.tenantId,
    required this.role,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  /// Convert to domain entity
  User toEntity() {
    return User(
      name: name,
      username: username,
      email: email,
      tenantId: tenantId,
      role: role,
    );
  }
  
  /// Create from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      name: user.name,
      username: user.username,
      email: user.email,
      tenantId: user.tenantId,
      role: user.role,
    );
  }
}
