import 'package:floor/floor.dart';

import 'entities/cleaning_time.dart';
import 'entities/user_time.dart';

@dao
abstract class TimeDao {
  // Cleaning
  @Query('SELECT * FROM CleaningTime ORDER BY ID DESC LIMIT 1')
  Future<CleaningTime?> getLastCleaningTime();

  @insert
  Future<int> insertCleaningTime(CleaningTime cleaningTime);

  @update
  Future<void> updateCleaningTime(CleaningTime cleaningTime);

  // UserTime
  @Query('SELECT * FROM UserTime WHERE cleaningTimeId = :cleaningTimeId')
  Stream<List<UserTime>> fetchByCleaningTime(int cleaningTimeId);

  @insert
  Future<void> insertUserTime(UserTime userTime);

  @update
  Future<void> updateUserTime(UserTime userTime);


}