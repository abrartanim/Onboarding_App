class AlarmModel {
  final int id;
  final DateTime dateTime;
  bool isActive;

  AlarmModel({
    required this.id,
    required this.dateTime,
    this.isActive = true,
  });
}