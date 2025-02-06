import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foldious/firebase_options.dart';
import 'package:intl/intl.dart';

///
///
Future<String> getToken() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    final authToken = await FirebaseMessaging.instance.getToken();
    print("authToken == ${authToken}");
    return authToken ?? "";
  } catch (e) {
    print("Error getting token: $e");
    return "";
  }
}

///
String formatFileSize({required String? size}) {
  double kilobytes = double.parse(size ?? "0");
  if (kilobytes < 1024) {
    return "${kilobytes.toStringAsFixed(1)} KB"; // Kilobytes
  } else if (kilobytes < 1024 * 1024) {
    double mb = kilobytes / 1024;
    return "${mb.toStringAsFixed(1)} MB"; // Megabytes
  } else {
    double gb = kilobytes / (1024 * 1024);
    return "${gb.toStringAsFixed(1)} GB"; // Gigabytes
  }
}

///
String formatDateFromTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final formatter = DateFormat('M-d-yyyy');
  final formattedDate = formatter.format(dateTime);
  return formattedDate;
}

///
///
///
DateTime convertTimeOfDayToDateTime({
  required TimeOfDay timeOfDay,
  required DateTime selectedDate,
}) {
  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}

///
///
///
TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
  return TimeOfDay(
    hour: dateTime.hour,
    minute: dateTime.minute,
  );
}

///
///

final monthNameDateYearFormat = DateFormat.yMMMd();
final timeWithoutAMPMFormat = DateFormat.Hm();
final timeWithAMPMFormat = DateFormat.jm();
final monthDateYearFormat = DateFormat.yMd();
final dayNameMonthNameDateYearFormat = DateFormat.yMMMMEEEEd();
final monthNameDayDateYearFormat = DateFormat.yMMMMd();
final weekDayNameFormat = DateFormat('EEEE');
final monthNameFormat = DateFormat.MMM();
final monthDateFormat = DateFormat('dd');
final dayNameMonthYear = DateFormat('EEEE MM/yy');
final dayDateMonth = DateFormat('EEE, d MMM');
final dateMonthYearFormat = DateFormat('dd/MM/yyyy');
final monthDayYearFormat = DateFormat('MM-dd-yyyy');
final yearMonthDayFormat = DateFormat('yyyy-MM-dd');
var yMDHMSFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
var yMDFromat = DateFormat("yyyy-MM-dd");
