class ParseCommon {
  static Map<String, dynamic> clone(Map<String, dynamic> source) {
    var destination = <String, dynamic>{};
    source.forEach((property, value) {
      destination[property] = value;
    });
    return destination;
  }

  static List<dynamic> cloneArray(List<dynamic> source) {
    var destination = <dynamic>[];
    for (var i = 0; i < source.length; i++) {
      destination.add(clone(source[i]));
    }
    return destination;
  }

  static Map<String, dynamic> cloneHashOfHash(Map<String, dynamic> source) {
    var destination = <String, dynamic>{};
    source.forEach((property, value) {
      destination[property] = clone(value);
    });
    return destination;
  }

  static Map<String, List<dynamic>> cloneHashOfArrayOfHash(Map<String, dynamic> source) {
    var destination = <String, List<dynamic>>{};
    source.forEach((property, value) {
      destination[property] = cloneArray(value);
    });
    return destination;
  }

  static String strip(String str) {
    return str.replaceAll(RegExp(r'^\s+'), '').replaceAll(RegExp(r'\s+$'), '');
  }

  static bool startsWith(String str, String pattern) {
    return str.indexOf(pattern) == 0;
  }

  static bool endsWith(String str, String pattern) {
    var d = str.length - pattern.length;
    return d >= 0 && str.lastIndexOf(pattern) == d;
  }

  static dynamic last(List<dynamic> arr) {
    if (arr.isEmpty) return null;
    return arr[arr.length - 1];
  }
}
