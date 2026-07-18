class UserModel {
  final int? id;
  final String name;
  final String email;
  final String role; // 'مشرف' or 'مستخدم'
  final int roleId; // 0 for Admin (مشرف), 1 for User (مستخدم)
  final String? avatar;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.roleId,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int parsedRoleId = 1;
    if (json['role'] is int) {
      parsedRoleId = json['role'] as int;
    } else if (json['roleId'] is int) {
      parsedRoleId = json['roleId'] as int;
    } else {
      final roleStr = json['role']?.toString().toLowerCase() ?? '';
      if (roleStr == 'admin' || roleStr == '0' || roleStr == 'مشرف') {
        parsedRoleId = 0;
      } else {
        parsedRoleId = 1;
      }
    }

    final String roleName = parsedRoleId == 0 ? 'مشرف' : 'مستخدم';

    int? parsedId;
    if (json['id'] is int) {
      parsedId = json['id'] as int;
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString());
    }

    return UserModel(
      id: parsedId,
      name: json['name']?.toString() ??
          json['fullName']?.toString() ??
          json['userName']?.toString() ??
          'مستخدم',
      email: json['email']?.toString() ?? '',
      role: roleName,
      roleId: parsedRoleId,
      avatar: json['avatar']?.toString() ??
          json['image']?.toString() ??
          json['photo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'role': roleId,
    };
  }
}
