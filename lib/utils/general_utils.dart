import 'dart:collection';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class Utils {
  static int strToInt(String str) {
    return str != null ? int.parse(str) : null;
  }

  static String buildEmail(String subject, String body) {
    var encodedSubject = Uri.encodeComponent(subject);
    var encodedBody = Uri.encodeComponent('Hi there,\n\n$body');
    return 'mailto:psyanite@gmail.com?subject=$encodedSubject&body=$encodedBody';
  }

  static List<dynamic> subset(Iterable<int> ids, LinkedHashMap<int, dynamic> map) {
    return ids == null || map == null ? null : ids.map((i) => map[i]).toList();
  }

  static Future<String> getDeviceInfo() async {
    var info;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var data = await deviceInfo.androidInfo;
        info = """
          platform: android
          type: ${data.isPhysicalDevice ? 'physical' : 'non-physical'}
          brand: ${data.brand}
          manufacturer: ${data.manufacturer}
          hardware: ${data.hardware}
          model: ${data.model}
          device: ${data.device}
          version: ${data.version.baseOS}-${data.version.release}-${data.version.sdkInt}-${data.version.securityPatch}
        """;
      } else if (Platform.isIOS) {
        var data = await deviceInfo.iosInfo;
        info = """
          platform: android
          type: ${data.isPhysicalDevice ? 'physical' : 'non-physical'}
          name: ${data.name}
          systemName: ${data.systemName}
          systemVersion: ${data.systemVersion}
          model: ${data.model}
        """;
      } else {
        info = 'error-could-not-determine-platform';
      }
    } on PlatformException {
      info = 'platform-exception-could-not-get-device-info';
    }
    return info;
  }

}
