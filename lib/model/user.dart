class User {
  final String ? id;
  final String ? username;
  final String ? password;
  final String ? confirm_password;
  final String ? names;
  final String ? phone_number;
  final String ? email;
  final String ? role;
  final String ? code;
  final String ? account_id;
  final String ? created_at;
  final String ? updated_at;
  final String ? enabled;
  final String ? token;

  User({
     this.id,
     this.username,
     this.password,
     this.confirm_password,
     this.names,
     this.phone_number,
     this.email,
     this.role,
     this.enabled,
     this.code,
     this.account_id,
     this.created_at,
     this.updated_at,
     this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'] as String,
        username:json['username'] as String,
        names:json['names'] as String,
        phone_number: json['phone_number'] as String,
        enabled: json['enabled'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        code: json['code'] as String,
        account_id: json['account_id'] as String,
        created_at: json['created_at'] as String,
        updated_at: json['updated_at'] as String,
        token:  json['token'] as String, password: '', confirm_password: ''
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username,  names: $names,phone_number: $phone_number,enabled:$enabled, code:$code,email:$email,role:$role,account_id:$account_id,created_at:$created_at,updated_at:$updated_at,token:$token}';
  }
}