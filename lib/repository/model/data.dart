import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class AuthRes {
  bool? status;
  String? message;
  dynamic data;
  AuthRes({this.status, this.message, this.data});
  factory AuthRes.fromJson(Map<String, dynamic> json) =>
      _$AuthResFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResToJson(this);
}