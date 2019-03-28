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
    throw 'Could not launch url';
  }
}

String dateFormatter(DateTime datetime) {
  if (datetime == null) {
    return "N/A";
  }

  const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String day = datetime.day.toString();
  String month = months[datetime.month - 1];
  String year = datetime.year.toString();

  return day + " " + month + " " + year;
}

String timeFormatter(DateTime datetime) {
  if (datetime == null) {
    return "N/A";
  }

  String hour = (datetime.hour < 10)
      ? "0" + datetime.hour.toString()
      : datetime.hour.toString();
  String minute = (datetime.minute < 10)
      ? "0" + datetime.minute.toString()
      : datetime.minute.toString();

  return hour + " : " + minute;
}

String monthAbbreviation(DateTime datetime) {
  if (datetime == null) {
    return "N/A";
  }

  const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  return months[datetime.month - 1].substring(0, 3);
}

String stringValidator(String string) {
  if (string == null) {
    return "N/A";
  } else {
    return string;
  }
}