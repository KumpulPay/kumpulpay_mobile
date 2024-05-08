// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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

  NotificationDao? _notificationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `notification` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `type` TEXT NOT NULL, `title` TEXT NOT NULL, `subtitle` TEXT NOT NULL, `image` TEXT NOT NULL, `timestamp` INTEGER NOT NULL, `isRead` INTEGER, `status` TEXT NOT NULL, `data` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notificationEntityInsertionAdapter = InsertionAdapter(
            database,
            'notification',
            (NotificationEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'title': item.title,
                  'subtitle': item.subtitle,
                  'image': item.image,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                  'isRead': item.isRead == null ? null : (item.isRead! ? 1 : 0),
                  'status': item.status,
                  'data': item.data
                }),
        _notificationEntityUpdateAdapter = UpdateAdapter(
            database,
            'notification',
            ['id'],
            (NotificationEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'title': item.title,
                  'subtitle': item.subtitle,
                  'image': item.image,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                  'isRead': item.isRead == null ? null : (item.isRead! ? 1 : 0),
                  'status': item.status,
                  'data': item.data
                }),
        _notificationEntityDeletionAdapter = DeletionAdapter(
            database,
            'notification',
            ['id'],
            (NotificationEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'title': item.title,
                  'subtitle': item.subtitle,
                  'image': item.image,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                  'isRead': item.isRead == null ? null : (item.isRead! ? 1 : 0),
                  'status': item.status,
                  'data': item.data
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotificationEntity>
      _notificationEntityInsertionAdapter;

  final UpdateAdapter<NotificationEntity> _notificationEntityUpdateAdapter;

  final DeletionAdapter<NotificationEntity> _notificationEntityDeletionAdapter;

  @override
  Future<List<NotificationEntity>> findAll(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notification ORDER BY id DESC LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => NotificationEntity(
            row['id'] as int?,
            row['type'] as String,
            row['title'] as String,
            row['subtitle'] as String,
            row['image'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int),
            row['isRead'] == null ? null : (row['isRead'] as int) != 0,
            row['status'] as String,
            row['data'] as String),
        arguments: [limit, offset]);
  }

  @override
  Future<NotificationEntity?> find(int id) async {
    return _queryAdapter.query('SELECT * FROM notification WHERE id = ?1',
        mapper: (Map<String, Object?> row) => NotificationEntity(
            row['id'] as int?,
            row['type'] as String,
            row['title'] as String,
            row['subtitle'] as String,
            row['image'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int),
            row['isRead'] == null ? null : (row['isRead'] as int) != 0,
            row['status'] as String,
            row['data'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertData(NotificationEntity model) async {
    await _notificationEntityInsertionAdapter.insert(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateData(NotificationEntity model) async {
    await _notificationEntityUpdateAdapter.update(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteData(NotificationEntity model) async {
    await _notificationEntityDeletionAdapter.delete(model);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
