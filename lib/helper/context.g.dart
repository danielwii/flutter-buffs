// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppEnv _$AppEnvFromJson(Map<String, dynamic> json) {
  return AppEnv(
    json['APP_KEY'] as String,
    json['HOSTNAME'] as String,
    json['PROTECTED_PROTOCOL'] as String,
    json['PROTECTED_IP'] as String,
    json['PROTECTED_PORT'] as int,
  );
}

Map<String, dynamic> _$AppEnvToJson(AppEnv instance) => <String, dynamic>{
      'APP_KEY': instance.APP_KEY,
      'HOSTNAME': instance.HOSTNAME,
      'PROTECTED_PROTOCOL': instance.PROTECTED_PROTOCOL,
      'PROTECTED_IP': instance.PROTECTED_IP,
      'PROTECTED_PORT': instance.PROTECTED_PORT,
    };
