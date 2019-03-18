import 'package:url_launcher/url_launcher.dart';

List<String> convertDynamicListToStringList(List<dynamic> dynamicList) {
  if (dynamicList == null) return [];

  List<String> stringList = [];
  for (dynamic dynamicItem in dynamicList) {
    stringList.add(dynamicItem.toString());
  }
  return stringList;
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Cloud not launch url';
  }
}
