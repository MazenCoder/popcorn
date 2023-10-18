
class ReminderNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReminderNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}
