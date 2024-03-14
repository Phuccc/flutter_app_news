import 'package:intl/intl.dart';
// Thời gian hiện tại
String getCurrentDate() {
  // Get the current date
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('E, d\'th\' MMMM yyyy').format(now);
  return formattedDate;
}

// Tính thời gian khi đăng
String formatTimeDifference(Duration difference) {
  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
  } else {
    return 'Just now';
  }
}

String getFormattedDifference(String publishedAt) {
  final publishedDate = DateTime.parse(publishedAt).toUtc();
  final now = DateTime.now().toUtc();
  final difference = now.difference(publishedDate);
  final formattedDifference = formatTimeDifference(difference);
  return formattedDifference;
}

// Thời gian ở trang chi tiết
String getOrdinalDay(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

String timeInDetail(String publishedAt) {
  final publishedDate = DateTime.parse(publishedAt);
  final day = publishedDate.day;
  final formattedDay = getOrdinalDay(day);
  final formattedDate = DateFormat('MMMM yyyy').format(publishedDate);
  return '$formattedDay $formattedDate';
}