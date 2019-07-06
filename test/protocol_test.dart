import 'package:marvel_flutter/protocol/Marvel.dart';
import 'package:test/test.dart';

void main() {


  test('Characters list test', () async {

    var response = await Marvel.api.getCharacters("", 1, 0);
    
    expect(response == null, false);
    expect(response.count == null, false);
    expect(response.count, 1);

    expect(response.results[0] == null, false);

  });

  test('Comic book list test', () async {

    var response2 = await Marvel.api.getComicBooks(1010727, 10, 0);
    expect(response2 == null, false);
  });
}