import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class AuthRes {
  bool status;
  String? message;
  dynamic data;
  AuthRes({this.status=false, this.message, this.data});
  factory AuthRes.fromJson(Map<String, dynamic> json) =>
      _$AuthResFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class ValueWrapper<T> {
  const ValueWrapper({required this.value});

  factory ValueWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ValueWrapperFromJson(json, fromJsonT);

  final T value;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ValueWrapperToJson(this, toJsonT);
}