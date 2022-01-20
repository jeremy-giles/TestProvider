import 'package:test_provider/database/database.dart';
import 'package:test_provider/database/entities/cleaning_time.dart';
import 'package:test_provider/database/entities/user_time.dart';

abstract class TimeRepository {
  // Cleaning
  Future<CleaningTime?> getLastCleaningTime();

  Future<int> insertCleaningTime(CleaningTime cleaningTime);

  Future<void> updateCleaningTime(CleaningTime cleaningTime);

  // User
  Stream<List<UserTime>> fetchUserTime(int cleaningTimeId);

  Future<void> insertUserTime(UserTime userTime);

  Future<void> updateUserTime(UserTime userTime);
}

class TimeRepositoryImpl extends TimeRepository {

  TimeRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<int> insertCleaningTime(CleaningTime cleaningTime) async {
    return database.timeDao.insertCleaningTime(cleaningTime);
  }

  @override
  Future<void> updateCleaningTime(CleaningTime cleaningTime) async {
    return database.timeDao.updateCleaningTime(cleaningTime);
  }

  @override
  Future<CleaningTime?> getLastCleaningTime() {
    return database.timeDao.getLastCleaningTime();
  }

  @override
  Future<void> insertUserTime(UserTime userTime) async {
    database.timeDao.insertUserTime(userTime);
  }

  @override
  Future<void> updateUserTime(UserTime userTime) async {
    database.timeDao.updateUserTime(userTime);
  }

  @override
  Stream<List<UserTime>> fetchUserTime(int cleaningTimeId) {
    return database.timeDao.fetchByCleaningTime(cleaningTimeId);
  }

}