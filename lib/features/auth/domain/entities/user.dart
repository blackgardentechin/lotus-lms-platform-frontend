import 'package:equatable/equatable.dart';

/// User Entity
class User extends Equatable {
  final String name;
  final String username;
  final String email;
  final String tenantId;
  final String role;
  
  const User({
    required this.name,
    required this.username,
    required this.email,
    required this.tenantId,
    required this.role,
  });
  
  @override
  List<Object?> get props => [name, username, email, tenantId, role];
}
