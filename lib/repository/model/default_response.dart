import 'package:json_annotation/json_annotation.dart';

part 'default_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DefaultResponse<T> {
  final bool success;
  final String message;
  final T? data;

  DefaultResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DefaultResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$DefaultResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T? value) toJsonT) =>
      _$DefaultResponseToJson(this, toJsonT);
}
