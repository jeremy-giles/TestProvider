// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TimeDao? _timeDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CleaningTime` (`id` INTEGER, `description` TEXT, `inProgress` INTEGER NOT NULL, `finished` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserTime` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `cleaningTimeId` INTEGER NOT NULL, `userId` INTEGER NOT NULL, `startTime` INTEGER NOT NULL, `endTime` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TimeDao get timeDao {
    return _timeDaoInstance ??= _$TimeDao(database, changeListener);
  }
}

class _$TimeDao extends TimeDao {
  _$TimeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _cleaningTimeInsertionAdapter = InsertionAdapter(
            database,
            'CleaningTime',
            (CleaningTime item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'inProgress': item.inProgress ? 1 : 0,
                  'finished': item.finished ? 1 : 0
                }),
        _userTimeInsertionAdapter = InsertionAdapter(
            database,
            'UserTime',
            (UserTime item) => <String, Object?>{
                  'id': item.id,
                  'cleaningTimeId': item.cleaningTimeId,
                  'userId': item.userId,
                  'startTime': item.startTime,
                  'endTime': item.endTime
                },
            changeListener),
        _cleaningTimeUpdateAdapter = UpdateAdapter(
            database,
            'CleaningTime',
            ['id'],
            (CleaningTime item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'inProgress': item.inProgress ? 1 : 0,
                  'finished': item.finished ? 1 : 0
                }),
        _userTimeUpdateAdapter = UpdateAdapter(
            database,
            'UserTime',
            ['id'],
            (UserTime item) => <String, Object?>{
                  'id': item.id,
                  'cleaningTimeId': item.cleaningTimeId,
                  'userId': item.userId,
                  'startTime': item.startTime,
                  'endTime': item.endTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CleaningTime> _cleaningTimeInsertionAdapter;

  final InsertionAdapter<UserTime> _userTimeInsertionAdapter;

  final UpdateAdapter<CleaningTime> _cleaningTimeUpdateAdapter;

  final UpdateAdapter<UserTime> _userTimeUpdateAdapter;

  @override
  Future<CleaningTime?> getLastCleaningTime() async {
    return _queryAdapter.query(
        'SELECT * FROM CleaningTime ORDER BY ID DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => CleaningTime(
            inProgress: (row['inProgress'] as int) != 0,
            finished: (row['finished'] as int) != 0,
            id: row['id'] as int?,
            description: row['description'] as String?));
  }

  @override
  Stream<List<UserTime>> fetchByCleaningTime(int cleaningTimeId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM UserTime WHERE cleaningTimeId = ?1',
        mapper: (Map<String, Object?> row) => UserTime(
            id: row['id'] as int?,
            cleaningTimeId: row['cleaningTimeId'] as int,
            userId: row['userId'] as int,
            startTime: row['startTime'] as int,
            endTime: row['endTime'] as int?),
        arguments: [cleaningTimeId],
        queryableName: 'UserTime',
        isView: false);
  }

  @override
  Future<int> insertCleaningTime(CleaningTime cleaningTime) {
    return _cleaningTimeInsertionAdapter.insertAndReturnId(
        cleaningTime, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertUserTime(UserTime userTime) async {
    await _userTimeInsertionAdapter.insert(userTime, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCleaningTime(CleaningTime cleaningTime) async {
    await _cleaningTimeUpdateAdapter.update(
        cleaningTime, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUserTime(UserTime userTime) async {
    await _userTimeUpdateAdapter.update(userTime, OnConflictStrategy.abort);
  }
}
