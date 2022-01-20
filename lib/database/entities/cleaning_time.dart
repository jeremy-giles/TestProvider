import 'package:floor/floor.dart';

@entity
class CleaningTime {
  @primaryKey
  final int? id;
  final String? description;

  bool inProgress;
  bool finished;

  CleaningTime({
    required this.inProgress,
    required this.finished,
    this.id,
    this.description,
  });
}
