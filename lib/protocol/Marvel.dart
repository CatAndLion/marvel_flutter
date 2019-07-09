
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Responses.dart';
import 'BaseRequest.dart';
import 'Requests.dart';
import 'package:crypto/crypto.dart';

typedef T JsonBuilder<T>(dynamic json);

class Marvel {

  static Marvel _api;
  static Marvel get api => Marvel();

  static const String apiKey = '50233aa55afbc791346dfffe4681175c';
  static const String url = 'https://gateway.marvel.com:443/v1/public/';
  
  String _hash;

  factory Marvel() {
    return _api ?? Marvel._internal();
  }

  Marvel._internal() {
    _api = this;
    var code = utf8.encode('1' + '670f0c074a84ed2969f3cda23bd4e809458ccf26' + apiKey);
    var digest = md5.convert(code);
    _hash = hex.encode(digest.bytes);
  }

  Future<http.Response> _getHttpResponse(BaseRequest request) {
    String s = '$url/${request.mode}?' + 'ts=1&hash=$_hash&apikey=$apiKey' + '${request.prefix}';
    return http.get(s);
  }

  Future<T> _getJsonResponse<T>(String json, {builder: JsonBuilder}) {
    return Future<T>(() {
      Map<String, dynamic> decoded = jsonDecode(json);
      if(decoded.containsKey('data')) {
        return builder(decoded['data']);
      }
    });
  }

  Future<ComicBookListResponse> getComicBooks(int characterId, int limit, int offset) async {

    http.Response response = await _getHttpResponse(ComicBooksRequest(characterId, limit, offset));

    if(response.statusCode == 200) {

      return _getJsonResponse(response.body, builder: (s) => ComicBookListResponse.fromJson(s));

    } else {

      throw http.ClientException('Request error');
    }
  }

  Future<CharacterListResponse> getCharacters(String nameQuery, int limit, int offset) async {

    http.Response response = await _getHttpResponse(CharacterRequest(nameQuery, limit, offset));
    if(response.statusCode == 200) {

      return _getJsonResponse(response.body, builder: (s) => CharacterListResponse.fromJson(s));

    } else {

      throw http.ClientException('Request error');
    }
  }
}