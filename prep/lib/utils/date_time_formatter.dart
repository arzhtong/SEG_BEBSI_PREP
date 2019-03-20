class DateTimeFormatter {
  static final DateTimeFormatter _singleton = DateTimeFormatter._internal();
  factory DateTimeFormatter() => _singleton;
  const DateTimeFormatter._internal();

  static String dateFormatter(DateTime datetime) {
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

  static String timeFormatter(DateTime datetime) {
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
}