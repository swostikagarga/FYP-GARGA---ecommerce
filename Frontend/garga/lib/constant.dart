import 'dart:convert';

const String ipAddress = "192.168.1.101";

var getImageUrl = (imageUrl) {
  return 'http://$ipAddress/garga-api/$imageUrl';
};

List<T> getDecodedList<T>(String? data) {
  try {
    if (data == null) return [];
    return jsonDecode(data).cast<T>();
  } catch (e) {
    return [];
  }
}
