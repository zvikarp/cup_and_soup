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
}

final CloudFunctionsService cloudFunctionsService = CloudFunctionsService();
