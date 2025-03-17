
class BaseResponseEntity {
  int? code;
  String? message;
  bool? successful;

  BaseResponseEntity({
    this.code,
    this.message,
    this.successful,
  });

  factory BaseResponseEntity.fromJson(Map<String, dynamic> json) =>
      BaseResponseEntity(
        code: json["code"],
        message: json["message"],
        successful: json["successful"],
      );

  Map<String, dynamic> toJson() => {
    "counts": code ,
    "message": message ,
    "successful": successful,
  };
}

class BindFcmTokenRequestEntity {
  String? fcmtoken;

  BindFcmTokenRequestEntity({
    this.fcmtoken,
  });

  Map<String, dynamic> toJson() => {
    "fcmtoken": fcmtoken,
  };
}