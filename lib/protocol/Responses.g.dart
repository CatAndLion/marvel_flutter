// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterListResponse _$CharacterListResponseFromJson(
    Map<String, dynamic> json) {
  return CharacterListResponse(
      json['total'] as int,
      json['count'] as int,
      (json['results'] as List)
          ?.map((e) =>
              e == null ? null : Character.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

ComicBookListResponse _$ComicBookListResponseFromJson(
    Map<String, dynamic> json) {
  return ComicBookListResponse(
      json['total'] as int,
      json['count'] as int,
      (json['results'] as List)
          ?.map((e) =>
              e == null ? null : ComicBook.fromJson(e as Map<String, dynamic>))
          ?.toList());
}
