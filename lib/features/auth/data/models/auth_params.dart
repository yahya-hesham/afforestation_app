class AuthParams {
  String? token;
  String? role;
  int? id;
  String? email;

  AuthParams({this.token, this.role, this.id, this.email});

  factory AuthParams.fromJson(Map<String, dynamic> json) => AuthParams(
    token: (json['token'] ?? json['Token']) as String?,
    role: (json['role'] ?? json['Role']) as String?,
    id: (json['id'] ?? json['Id']) as int?,
    email: (json['email'] ?? json['Email']) as String?,
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'role': role,
    'id': id,
    'email': email,
  };
}
