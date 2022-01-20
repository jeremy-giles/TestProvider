import 'package:floor/floor.dart';

@entity
class UserTime {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int cleaningTimeId;
  final int userId;
  int startTime;
  int? endTime;

  UserTime({
    this.id,
    required this.cleaningTimeId,
    required this.userId,
    required this.startTime,
    this.endTime,
  });
}
