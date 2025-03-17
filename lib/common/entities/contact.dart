import 'package:sglab_desk/common/entities/base.dart';

class ContactResponseEntity extends BaseResponseEntity {
  List<ContactItem>? data;

  ContactResponseEntity({
    super.code,
    super.message,
    super.successful,
    this.data,
  });
  factory ContactResponseEntity.fromJson(Map<String, dynamic> json) =>
      ContactResponseEntity(
        code: json["code"],
        message: json["message"],
        successful: json["successful"],
        data: json["data"] == null
            ? []
            : List<ContactItem>.from(
                json["data"].map((x) => ContactItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "counts": code,
        "message": message,
        "successful": successful,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

// login result
class ContactItem {
  String? baseUserId;
  String? contactUserId;
  String? name;
  String? description;
  String? avatar;
  bool? online;

  ContactItem({
    this.baseUserId,
    this.contactUserId,
    this.name,
    this.description,
    this.avatar,
    this.online,
  });

  factory ContactItem.fromJson(Map<String, dynamic> json) => ContactItem(
        baseUserId: json["baseUserId"],
        contactUserId: json["contactUserId"],
        name: json["name"],
        description: json["description"],
        avatar: json["avatar"],
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
        "baseUserId": baseUserId,
        "contactUserId": contactUserId,
        "name": name,
        "description": description,
        "avatar": avatar,
        "online": online,
      };
}
