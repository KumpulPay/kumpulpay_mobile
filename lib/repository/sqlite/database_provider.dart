import 'package:get_it/get_it.dart';
import 'package:kumpulpay/repository/sqlite/app_database.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;



class DatabaseProvider {

  static final GetIt getIt = GetIt.instance;

  static Future<void> initialize() async {
    final database = await _initDatabase();
    getIt.registerLazySingleton<AppDatabase>(() => database);
    getIt.registerLazySingleton(() => database.notificationDao);
  }

  static Future<AppDatabase> _initDatabase() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_kumpulpay.db').build();
      
    return database;
  }
}