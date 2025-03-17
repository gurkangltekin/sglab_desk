import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sglab_desk/common/entities/base.dart';
import 'package:uuid/uuid.dart';

class LoginRequestEntity {
  int? type;
  String? name;
  String? description;
  String? email;
  String? phone;
  String? avatar;
  String? open_id;
  int? online;

  LoginRequestEntity({
    this.type,
    this.name,
    this.description,
    this.email,
    this.phone,
    this.avatar,
    this.open_id,
    this.online,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "description": description,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "open_id": open_id,
        "online": online,
      };
}

//api post response msg
class UserLoginResponseEntity extends BaseResponseEntity {
  String? token;
  UserEntity? user;

  UserLoginResponseEntity({
    super.code,
    super.message,
    super.successful,
    this.token,
    this.user,
  });

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        code: json["code"],
        message: json["message"],
        successful: json["successful"],
        user: json["user"] != null ? UserEntity.fromJson(json["user"]) : null,
      );
}

// login result
class UserEntity {
  String? id;
  bool? isDeleted;
  DateTime? version;
  DateTime? createDate;
  String? username;
  String? email;
  String? password;
  String? name;
  bool? isEnabled;
  DateTime? emailVerifiedDate;
  String? rememberToken;
  String? accessToken;
  String? description;
  String? avatar;
  DateTime? expireDate;
  bool? online;
  String? fcmToken;
  String? openId;
  String? token;
  String? role;
  int? type;

  UserEntity(
      {this.id,
      this.isDeleted,
      this.version,
      this.username,
      this.email,
      this.password,
      this.createDate,
      this.emailVerifiedDate,
      this.rememberToken,
      this.expireDate,
      this.fcmToken,
      this.isEnabled,
      this.role,
      this.accessToken,
      this.token,
      this.name,
      this.description,
      this.avatar,
      this.online,
      this.type,
      this.openId});

  /// **JSON'dan UserItem nesnesi oluşturur.**
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json["id"] as String,
      isDeleted: json["is_deleted"] as bool? ?? false,
      version: json["version"] != null ? DateTime.parse(json["version"]) : null,
      username: json["username"] as String,
      email: json["email"] as String,
      password: json["password"],
      createDate: json["create_date"] != null
          ? DateTime.parse(json["create_date"])
          : null,
      emailVerifiedDate: json["email_verified_date"] != null
          ? DateTime.parse(json["email_verified_date"])
          : null,
      rememberToken: json["remember_token"],
      expireDate: json["expire_date"] != null
          ? DateTime.parse(json["expire_date"])
          : null,
      fcmToken: json["fcmtoken"],
      isEnabled: json["is_enabled"] as bool?,
      role: json["role"],
      accessToken: json["accessToken"],
      token: json["token"],
      name: json["name"],
      description: json["description"],
      avatar: json["avatar"],
      online: json["online"] as bool?,
      type: json["type"] as int?,
      openId: json["openId"] as String?,
    );
  }

  /// **UserItem nesnesini JSON'a çevirir.**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "is_deleted": isDeleted,
      "version": version?.toIso8601String(),
      "username": username,
      "email": email,
      "password": password,
      "create_date": createDate?.toIso8601String(),
      "email_verified_date": emailVerifiedDate?.toIso8601String(),
      "remember_token": rememberToken,
      "expire_date": expireDate?.toIso8601String(),
      "fcmtoken": fcmToken,
      "is_enabled": isEnabled,
      "role": role,
      "accessToken": accessToken,
      "token": token,
      "name": name,
      "description": description,
      "avatar": avatar,
      "online": online,
      "type": type,
      "openId": openId,
    };
  }

  /// **Bir UserItem nesnesinin güncellenmiş bir kopyasını oluşturur.**
  UserEntity copyWith(
      {String? id,
      bool? isDeleted,
      DateTime? version,
      String? username,
      String? email,
      String? password,
      DateTime? createDate,
      DateTime? emailVerifiedDate,
      String? rememberToken,
      DateTime? expireDate,
      String? fcmToken,
      bool? isEnabled,
      String? role,
      String? accessToken,
      String? token,
      String? name,
      String? description,
      String? avatar,
      bool? online,
      int? type,
      String? openId}) {
    return UserEntity(
      id: id ?? this.id,
      isDeleted: isDeleted ?? this.isDeleted,
      version: version ?? this.version,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      createDate: createDate ?? this.createDate,
      emailVerifiedDate: emailVerifiedDate ?? this.emailVerifiedDate,
      rememberToken: rememberToken ?? this.rememberToken,
      expireDate: expireDate ?? this.expireDate,
      fcmToken: fcmToken ?? this.fcmToken,
      isEnabled: isEnabled ?? this.isEnabled,
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      token: token ?? this.token,
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      online: online ?? this.online,
      type: type ?? this.type,
      openId: openId ?? this.openId,
    );
  }

  /// **Debugging için nesneyi yazdırırken daha okunabilir hale getirir.**
  @override
  String toString() {
    return 'UserItem(id: $id, username: $username, email: $email, isDeleted: $isDeleted, role: $role, online: $online)';
  }
}

class UserData {
  final String? token;
  final String? name;
  final String? avatar;
  final String? description;
  final int? online;

  UserData({
    this.token,
    this.name,
    this.avatar,
    this.description,
    this.online,
  });

  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
      token: data?['token'],
      name: data?['name'],
      avatar: data?['avatar'],
      description: data?['description'],
      online: data?['online'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (token != null) "token": token,
      if (name != null) "name": name,
      if (avatar != null) "avatar": avatar,
      if (description != null) "description": description,
      if (online != null) "online": online,
    };
  }
}
