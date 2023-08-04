String visualTime(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final hour = date.hour.toString().padLeft(2, "0");
  final minute = date.minute.toString().padLeft(2, "0");
  return "$hour:$minute";
}

String visualDuration(int duration) {
  final minutes = duration ~/ 1000 ~/ 60;
  final hours = minutes ~/ 60;
  final minutesLeft = minutes % 60;
  return "$hours hours $minutesLeft minutes";
}
