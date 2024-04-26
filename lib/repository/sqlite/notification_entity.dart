import 'package:floor/floor.dart';

enum NotificationType {
  info,
  transaction,
}

@Entity(tableName: 'notification')
class NotificationEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  // final NotificationType? type;
  final String type;
  final String title;
  final String subtitle;
  final String image;
  final DateTime timestamp;
  final bool? isRead;
  final String status;
  final String data;

  NotificationEntity(
    this.id,
    this.type,
    this.title,
    this.subtitle,
    this.image,
    this.timestamp,
    this.isRead,
    this.status,
    this.data,
  );

  factory NotificationEntity.optional({
    int? id,
    // NotificationType? type,
    String? type,
    String? title,
    String? subtitle,
    String? image,
    DateTime? timestamp,
    bool? isRead,
    String? status,
    String? data,
  }) => NotificationEntity(
    id, type??'',
    title??'', subtitle??'', image??'',
    timestamp??DateTime.now(),
    isRead??false, status??'', data??''
  );

  @override
  String toString() {
    return 'NotificationEntity{id: $id, type: $type, title: $title, subtitle: $subtitle, timestamp: $timestamp, isRead: $isRead, status: $status, data: $data}';
  }
}
