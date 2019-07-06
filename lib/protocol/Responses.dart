import 'package:json_annotation/json_annotation.dart';
import 'package:marvel_flutter/model/Character.dart';
import 'package:marvel_flutter/model/ComicBook.dart';

part 'Responses.g.dart';

abstract class BaseListResponse<T> {
  final int total;
  final int count;

  BaseListResponse(this.total, this.count);

  List<T> get results;
}

@JsonSerializable(createToJson: false)
class CharacterListResponse extends BaseListResponse<Character> {

  final List<Character> results;

  CharacterListResponse(int total, int count, List<Character> results) :
      this.results = results,
      super(total, count);

  factory CharacterListResponse.fromJson(Map<String, dynamic> json) => _$CharacterListResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ComicBookListResponse extends BaseListResponse<ComicBook> {

  final List<ComicBook> results;

  ComicBookListResponse(int total, int count, List<ComicBook> results) :
      this.results = results,
      super(total, count);

  factory ComicBookListResponse.fromJson(Map<String, dynamic> json) => _$ComicBookListResponseFromJson(json);
}