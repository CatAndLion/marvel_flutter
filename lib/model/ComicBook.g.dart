// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ComicBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicBook _$ComicBookFromJson(Map<String, dynamic> json) {
  return ComicBook(
      json['id'] as int,
      json['thumbnail'] == null
          ? null
          : Image.fromJson(json['thumbnail'] as Map<String, dynamic>),
      json['title'] as String,
      (json['issueNumber'] as num)?.toDouble(),
      json['description'] as String,
      json['format'] as String,
      json['pageCount'] as int);
}
