// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRes _$AuthResFromJson(Map<String, dynamic> json) => AuthRes(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$AuthResToJson(AuthRes instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ValueWrapper<T> _$ValueWrapperFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ValueWrapper<T>(
      value: fromJsonT(json['value']),
    );

Map<String, dynamic> _$ValueWrapperToJson<T>(
  ValueWrapper<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'value': toJsonT(instance.value),
    };
