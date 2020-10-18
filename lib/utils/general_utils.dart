import 'dart:collection';

class Utils {
  static int strToInt(String str) {
    return str != null ? int.parse(str) : null;
  }

  static String buildEmail(String subject, String body) {
    var encodedSubject = Uri.encodeComponent(subject);
    var encodedBody = Uri.encodeComponent('Hi there,<br><br>$body');
    return 'mailto:psyanite@gmail.com?subject=$encodedSubject&body=$encodedBody';
  }

  static List<dynamic> subset(Iterable<int> ids, LinkedHashMap<int, dynamic> map) {
    return ids == null || map == null ? null : ids.map((i) => map[i]).toList();
  }

}
