import 'package:dio/dio.dart';

class ApiModel {
  static Map<String, String> httpHeaders = {
    'Accept': 'application/json, text/plain, */*',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json',
    'Back-Token': '',
  };

  static Future postJson(Map<String, dynamic> params, String url) async {
    Response response;
    Dio dio = Dio();
    // httpHeaders['Back-Token'] = await StaffModel.getLocalToken();
    dio.options.headers = httpHeaders;
    try {
      print('trying to upload...');
      response = await dio.post(url, data: params);
      print(response);
      return response.data;
    } catch (e) {
      print(e.toString());
      return {"code": -999, "message": url + "|" + e.toString()};
      // return e.toString();
    }
  }

  // static Future getJson(String url) async {
  static Future<Map<String, dynamic>> getJson(String url) async {
    Response response;
    Dio dio = Dio();
    // dio.options.connectTimeout = 5000;
    dio.options.headers = httpHeaders;

    try {
      response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {"code": -999, "desc": "connection failed"};
      }
    } catch (e) {
      print(e.toString());
      return {"code": -999, "message": url + "|" + e.toString()};
      // return e.toString();
    }
  }

  /* 
  * Post FormData
  * In Sender from
  * In User Login
  */

  static Future postData(Map<String, dynamic> body, String url) async {
    var response;
    var dio = Dio();
    //dio.options.headers = httpHeaders;

    print('geeting url==> $url');
    print('getting body response===> $body');

    try {
      print('trying to upload...');
      var formData = new FormData.fromMap(body);

      response = await dio.post(url, data: formData);
      print(response);
      return response.data;
    } catch (e) {
      print(e.toString());

      return {"message": url + "|" + e.toString()};
    }
  }
}
