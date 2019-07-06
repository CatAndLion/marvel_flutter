//available (int, optional): The number of total available issues in this list. Will always be greater than or equal to the "returned" value.,
//returned (int, optional): The number of issues returned in this collection (up to 20).,
//collectionURI (string, optional): The path to the full list of issues in this collection.,
//items (Array[ComicSummary], optional): The list of returned issues in this collection.

//resourceURI (string, optional): The path to the individual comic resource.,
//name (string, optional): The canonical name of the comic.
import 'package:json_annotation/json_annotation.dart';

part 'ComicList.g.dart';

@JsonSerializable(createToJson: false)
class ComicList {
  int available;
  int returned;
  String collectionURI;
  var items = <ComicSummary>[];

  ComicList(this.available, this.returned, this.items);

  factory ComicList.fromJson(Map<String, dynamic> map) => _$ComicListFromJson(map);
}

@JsonSerializable(createToJson: false)
class ComicSummary {
  String resourceURI;
  String name;

  ComicSummary(this.resourceURI, this.name);

  factory ComicSummary.fromJson(Map<String, dynamic> map) => _$ComicSummaryFromJson(map);
}