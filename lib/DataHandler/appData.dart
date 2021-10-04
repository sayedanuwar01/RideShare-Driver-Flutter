
import 'package:driverapp/components/toast.dart';
import 'package:driverapp/models/api_model/api_model.dart';
import 'package:driverapp/models/history.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {

  static String baseUrl = 'http://campusride.rbfgroupbd.com/';

  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter) {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }

  /* APIs */


  Future contactUS({
    String name,
    String phone,
    String message,
    BuildContext context,
  }) async {
    Map<String, dynamic> params = Map<String, dynamic>();

    params['name'] = name;
    params['phone'] = phone;
    params['message'] = message;

    var apiResponse = baseUrl + '/contact_us_form';
    var postResponse = await ApiModel.postJson(params, apiResponse);
    print('getting registration response ===> $postResponse');

    if (postResponse['code'] == '000') {
      displayMessage(postResponse['status'].toString(), context);

      notifyListeners();
    } else {
      displayMessage(postResponse['status'].toString(), context);
      notifyListeners();
    }
    notifyListeners();
  }

  Future feedbackForm({
    String name,
    String phone,
    String message,
    BuildContext context,
  }) async {
    Map<String, dynamic> params = Map<String, dynamic>();

    params['name'] = name;
    params['phone'] = phone;
    params['feedback'] = message;

    var apiResponse = baseUrl + '/feedback';
    var postResponse = await ApiModel.postJson(params, apiResponse);
    print('getting registration response ===> $postResponse');

    if (postResponse['code'] == '000') {
      displayMessage(postResponse['status'].toString(), context);

      notifyListeners();
    } else {
      displayMessage(postResponse['status'].toString(), context);
      notifyListeners();
    }
    notifyListeners();
  }
}
