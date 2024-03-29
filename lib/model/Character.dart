
import 'package:json_annotation/json_annotation.dart';

//id (int, optional): The unique ID of the character resource.,
//name (string, optional): The name of the character.,
//description (string, optional): A short bio or description of the character.,
//modified (Date, optional): The date the resource was most recently modified.,
//resourceURI (string, optional): The canonical URL identifier for this resource.,
//urls (Array[Url], optional): A set of public web site URLs for the resource.,
//thumbnail (Image, optional): The representative image for this character.,
//comics (ComicList, optional): A resource list containing comics which feature this character.,
//stories (StoryList, optional): A resource list of stories in which this character appears.,
//events (EventList, optional): A resource list of events in which this character appears.,
//series (SeriesList, optional): A resource list of series in which this character appears.

part 'Character.g.dart';

@JsonSerializable(createToJson: false)
class Character {
  int id;
  String name;
  String description;
  Image thumbnail;

  Character(this.id, this.name, this.description, this.thumbnail);

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
}

@JsonSerializable(createToJson: false)
class Image {
  final String path;
  final String extension;

  static const String notAvailable = 'image_not_available';

  Image(this.path, this.extension);

  String get url => "$path.$extension";
  bool get available => path != null && !path.contains(notAvailable);

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}