import 'package:floor/floor.dart';
import 'package:kumpulpay/repository/sqlite/notification_entity.dart';

@dao
abstract class NotificationDao {

  // list pagination
  @Query('SELECT * FROM notification ORDER BY id DESC LIMIT :limit OFFSET :offset')
  Future<List<NotificationEntity>> findAll(int limit, int offset);

  // show
  @Query('SELECT * FROM notification WHERE id = :id')
  Future<NotificationEntity?> find(int id);

  @insert
  Future<void> insertData(NotificationEntity model);

  @update
  Future<void> updateData(NotificationEntity model);

  @delete
  Future<void> deleteData(NotificationEntity model);
}