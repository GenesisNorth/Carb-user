import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  Future<UserModel?> loginAPI(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.userLogin), headers: API.authheader, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      print("GETS HERE");
      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        Preferences.setString(Preferences.accesstoken, responseBody['data']['accesstoken'].toString());
        Preferences.setString(Preferences.admincommission, responseBody['data']['admin_commission'].toString());

        API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
        return UserModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        print("GETS HERE 2");
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        print("GETS HERE 3");
        ShowToastDialog.closeLoader();
        print(responseBody);
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      print("GETS HERE 5");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      print("GETS HERE 6");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      print("GETS HERE 7");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      print("GETS HERE 8");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
