// return a formatted data as a String

import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // Timestamp is the object  we retrieve from firebase
  // so to display it, lets convert it to a String
  DateTime dataTime = timestamp.toDate();
  // get year
  String year = dataTime.year.toString();
  // get month
  String month = dataTime.month.toString();
  // get day
  String day = dataTime.day.toString();
  // get hour
  //String hour = dataTime.hour.toString();
  // get mins
  //String minute = dataTime.minute.toString();
  //final formatted date
  String formattedData = '$day/$month/$year';
  return formattedData;
}
