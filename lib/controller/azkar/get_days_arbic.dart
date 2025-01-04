import 'package:intl/intl.dart';
import 'package:jhijri/_src/_jHijri.dart';
final jHijri = JHijri(fDate: DateTime.now());
String getDayWithArbic() {
  var day = DateFormat.EEEE().format(DateTime.now());
  String dayArbic = "";

  switch (day) {
    case "Saturday":
      dayArbic = "السبت";
      break;

    case "Sunday":
      dayArbic = "الاحد";
      break;

    case "Monday":
      dayArbic = "الاثنين";
      break;

    case "Tuesday":
      dayArbic = "الثلاثاء";
      break;

    case "Wednesday":
      dayArbic = "الاربعاء";
      break;

    case "Thursday":
      dayArbic = "الخميس";
      break;

    case "Friday":
      dayArbic = "الجمعة";
      break;
  }
  return dayArbic;
}
