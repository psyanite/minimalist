import 'dart:convert';

import 'package:http/http.dart' as http;

class CoffeeCat {

  static final alertsWebhook = "aHR0cHM6Ly9ob29rcy5zbGFjay5jb20vc2VydmljZXMvVDAyMlZLUEZGTjIvQjAyMk4wUUdQRjEvenRWUlhVc1hqc2hUTEQ5Y3VTMmJEdWE1";
  static final token = "eG94Yi0yMDk3NjY5NTI1NzUwLTIxMTcwODUwNzg1NjEtUHFoRmxQcXZFVFl4UjUwS1g1OXNJNG9s";


  static Future<bool> alert(CoffeeCatMsgType msgType, String msg) async {
    return await _doPost(alertsWebhook, msgType, msg);
  }

  static Future<bool> _doPost(String url, CoffeeCatMsgType msgType, String msg) async {
    var body = jsonEncode({ 'text': '${_getEmoji(msgType)} $msg' });
    var urlDecoded = String.fromCharCodes(base64.decode(url));
    var headers = { 'Content-type': 'application/json' };

    var response = await http.post(urlDecoded, body: body, headers: headers).timeout(Duration(seconds: 60));
    if (response.statusCode != 200) {
      print('[ERROR] CoffeeCat request failed: {\n$body\n}');
      print('[ERROR] ${response.statusCode} response: ${response.body}');
      return false;
    }
    return true;
  }

  static Future<bool> sendFile(String channels, CoffeeCatMsgType msgType, String msg, Exception ex, StackTrace stacktrace) async {
    var fileContent =
      """${ex.toString()}
         ${stacktrace.toString()}""";

    _doSendFile(channels, msgType, msg, "stacktrace.txt", fileContent);

    return false;
  }

  static Future<bool> _doSendFile(String channels, CoffeeCatMsgType msgType, String msg, String fileName, String fileContent) async {
    var body = {
      'content': fileContent,
      'filename': fileName,
      'channels': channels,
      'initial_comment': '${_getEmoji(msgType)} $msg' };

    var tokenDecoded = String.fromCharCodes(base64.decode(token));
    var url = Uri.parse('https://slack.com/api/files.upload');
    var headers = { 'Authorization': 'Bearer $tokenDecoded' };
    var request =
      new http.MultipartRequest("POST", url)
        ..headers.addAll(headers)
        ..fields.addAll(body);

    var response = await request.send().timeout(Duration(seconds: 60));
    var responseBodyStr = await response.stream.bytesToString();
    Map responseBody = jsonDecode(responseBodyStr);
    var ok = responseBody['ok'];
    if (response.statusCode != 200 || ok == null || !ok) {
      print('[ERROR] CoffeeCat sendFile failed: $body');
      print('[ERROR] ${response.statusCode} response: $responseBodyStr');
      return false;
    }
    return true;
  }

  static String _getEmoji(CoffeeCatMsgType msgType) {
    switch(msgType) {
      case CoffeeCatMsgType.Success: return ":tada:";
      case CoffeeCatMsgType.Info: return ":sparkles:";
      case CoffeeCatMsgType.Warn: return ":exclamation:";
      case CoffeeCatMsgType.Error: return ":rotating_light:";
      default: return ":tada:";
    }
  }

}

enum CoffeeCatMsgType { Success, Info, Warn, Error }
