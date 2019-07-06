// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ComicList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicList _$ComicListFromJson(Map<String, dynamic> json) {
  return ComicList(
      json['available'] as int,
      json['returned'] as int,
      (json['items'] as List)
          ?.map((e) => e == null
              ? null
              : ComicSummary.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..collectionURI = json['collectionURI'] as String;
}

ComicSummary _$ComicSummaryFromJson(Map<String, dynamic> json) {
  return ComicSummary(json['resourceURI'] as String, json['name'] as String);
}
