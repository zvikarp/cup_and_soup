import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  Future<bool> changeName(String uid, String name) async {
    await CloudFunctions.instance
        .call(functionName: "changeName", parameters: {
      "uid": uid,
      "name": name,
    }).catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> changeUserStatus(String uid, bool status) async {
    await CloudFunctions.instance
        .call(functionName: "changeUserStatus", parameters: {
      "uid": uid,
      "status": status,
    }).catchError((err) {
      return false;
    });
    return true;
  }
  
  Future<bool> sendMessage(String title, String msg, DateTime dateTime, String sendTo) async {
    await CloudFunctions.instance
        .call(functionName: "sendMessage", parameters: {
      "title": title,
      "msg": msg,
      "dateTime": dateTime,
      "sendTo": sendTo
    }).catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> updateItemStock(String iid, int stock) async {
    await CloudFunctions.instance
        .call(functionName: "updateItemStock", parameters: {
      "iid": iid,
      "stock": stock
    }).catchError((err) {
      return false;
    });
    return true;
  }

}

final CloudFunctionsService cloudFunctionsService = CloudFunctionsService();
