class DateTimeUtil {
  Future<DateTime> now() async {
    return DateTime.now().add(Duration(hours: 9));
  }
}