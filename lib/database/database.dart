import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:test_provider/database/time_dao.dart';

import 'entities/cleaning_time.dart';
import 'entities/user_time.dart';

part 'database.g.dart';

const String database_name = 'app_database.db';

@Database(version: 1, entities: [CleaningTime, UserTime])
abstract class AppDatabase extends FloorDatabase {
  TimeDao get timeDao;
}