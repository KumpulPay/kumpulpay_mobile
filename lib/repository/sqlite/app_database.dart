import 'dart:async';
import 'package:floor/floor.dart';
import 'package:kumpulpay/repository/sqlite/customer_number_dao.dart';
import 'package:kumpulpay/repository/sqlite/customer_number_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:kumpulpay/repository/model/model_conventer.dart';
import 'package:kumpulpay/repository/sqlite/notification_entity.dart';
import 'package:kumpulpay/repository/sqlite/notification_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [NotificationEntity, CustomerNumberEntity])
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
  NotificationDao get notificationDao;
  CustomerNumberDao get customerNumberDao;
}
