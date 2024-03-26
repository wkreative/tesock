import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CoinbaseRequest {
  final String type;
  final List<Map<String, dynamic>> channels;

  CoinbaseRequest(this.type, this.channels);

  factory CoinbaseRequest.fromJson(Map<String, dynamic> json) =>
      _$CoinbaseRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CoinbaseRequestToJson(this);
}
CoinbaseRequest _$CoinbaseRequestFromJson(Map<String, dynamic> json) =>
    CoinbaseRequest(
      json['type'] as String,
      (json['channels'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CoinbaseRequestToJson(CoinbaseRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'channels': instance.channels,
    };
