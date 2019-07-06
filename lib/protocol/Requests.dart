
import 'BaseRequest.dart';

class CharacterRequest extends BaseRequest {

  final String nameQuery;
  final int limit;
  final int offset;
  final String orderBy = 'name';

  CharacterRequest(this.nameQuery, this.limit, this.offset);

  @override
  get mode => 'characters';

  @override
  get prefix => '&orderBy=$orderBy&limit=${limit > 0 ? limit : 0}&offset=${offset >= 0 ? offset : 0}'
      '${nameQuery?.trim()?.isNotEmpty ?? false ? "&nameStartsWith=$nameQuery" : ""}';
}

class ComicBooksRequest extends BaseRequest {

  final int characterId;
  final int limit;
  final int offset;
  final String format = 'comic';
  final String orderBy = 'issueNumber';

  ComicBooksRequest(this.characterId, this.limit, this.offset);

  @override
  get mode => 'characters/$characterId/comics';

  @override
  get prefix => '&orderBy=$orderBy&limit=${limit > 0 ? limit : 0}&offset=${offset >= 0 ? offset : 0}'
      '&characterId=$characterId&format=$format';

}