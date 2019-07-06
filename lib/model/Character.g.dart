// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return Character(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['thumbnail'] == null
          ? null
          : Image.fromJson(json['thumbnail'] as Map<String, dynamic>));
}

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(json['path'] as String, json['extension'] as String);
}
