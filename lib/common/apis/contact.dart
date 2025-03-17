import 'package:sglab_desk/common/entities/entities.dart';
import 'package:sglab_desk/common/utils/utils.dart';

class ContactAPI {
  static Future<ContactResponseEntity> post_contact(String userId) async {
    var response = await HttpUtil().post('api/v1/contact/getContacts',
        queryParameters: {"userId": userId});
    return ContactResponseEntity.fromJson(response);
  }
}
