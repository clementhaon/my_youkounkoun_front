import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myyoukounkoun/translations/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  static Future<void> launchMyUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    } else {
      throw 'cannot open $url';
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String formattingDate(DateTime date, String localeLanguage) {
    initializeDateFormatting();
    DateFormat format = localeLanguage == "fr"
        ? DateFormat.yMMMd("fr")
        : DateFormat.yMMMd("en");

    return format.format(date).toString();
  }

  static String dateFormat(String dateString) {
    String dateFormated = "";
    DateTime date;
    if (dateString.contains("00:00")) {
      date = DateFormat('yyyy-MM-dd hh:mm').parse(dateString);
    } else {
      date = DateFormat('yyyy-MM-dd').parse(dateString);
    }
    dateFormated = DateFormat('dd/MM/yyyy').format(date);
    return dateFormated;
  }

  static DateTime convertStringToDateTime(String dateString) {
    DateTime date;
    if (dateString.contains("00:00")) {
      date = DateFormat('yyyy-MM-dd hh:mm').parse(dateString);
    } else {
      date = DateFormat('yyyy-MM-dd').parse(dateString);
    }
    return date;
  }

  static String readTimeStamp(BuildContext context, int timestamp) {
    DateTime dateNow = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    Duration difference = dateNow.difference(date);

    String timestampString = "";

    // if (difference.inDays > 365) {
    //   return "${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? "an" : "ans"}";
    // }
    // if (difference.inDays > 30) return "${(difference.inDays / 30).floor()}mois";
    if (difference.inDays > 7) {
      timestampString =
          "${(difference.inDays / 7).floor()}${AppLocalization.of(context).translate("general", "weeks")}";
    } else if (difference.inDays > 0) {
      timestampString =
          "${difference.inDays}${AppLocalization.of(context).translate("general", "days")}";
    } else if (difference.inHours > 0) {
      timestampString =
          "${difference.inHours}${AppLocalization.of(context).translate("general", "hours")}";
    } else if (difference.inMinutes > 0) {
      timestampString =
          "${difference.inMinutes}${AppLocalization.of(context).translate("general", "minutes")}";
    } else {
      timestampString = AppLocalization.of(context).translate("general", "now");
    }

    return timestampString;
  }
}
