import 'package:bloc/bloc.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/bloc/ListState.dart';
import 'package:marvel_flutter/model/Character.dart';
import 'package:marvel_flutter/model/ComicBook.dart';
import 'package:marvel_flutter/protocol/Marvel.dart';
import 'package:marvel_flutter/protocol/Responses.dart';
import 'package:rxdart/transformers.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

///
class CharacterListBloc extends BaseListBloc<Character> {

  @override
  Future<BaseListResponse<Character>> loadData(ListEvent event) {
    return Marvel.api.getCharacters(event.query, event.perPage, (event.page - 1) * event.perPage);;
  }

  @override
  ListState<Character> get initialState => ListState.empty();

  String get prefix => this.runtimeType.toString();
}

///
class ComicBookListBloc extends BaseListBloc<ComicBook> {

  final int characterId;

  ComicBookListBloc(this.characterId);

  @override
  Future<BaseListResponse<ComicBook>> loadData(ListEvent event) {
    print('loading...');
    return Marvel.api.getComicBooks(characterId, event.perPage, (event.page - 1) * event.perPage);
  }

  @override
  ListState<ComicBook> get initialState => ListState.empty();

  String get prefix => this.runtimeType.toString();
}

///
abstract class BaseListBloc<D> extends Bloc<ListEvent, ListState<D>> {

  Future<BaseListResponse<D>> loadData(ListEvent event);

  ListState<D> get initialState;

  String get prefix;

  final _errorStream = BehaviorSubject<String>();

  int get nextPage => currentState.page + 1;

  bool get canLoad => currentState.size < currentState.total;

  bool get hasData => !currentState.isEmpty && currentState.size > 0;

  bool get isLoading => currentState.isLoading;

  @override
  Stream<ListState<D>> transform(Stream<ListEvent> events,
      Stream<ListState<D>> next(ListEvent event)) {

    var transformed = events.transform(DebounceStreamTransformer((event) {
      bool searchEvent = event.query != currentState.query;
      return TimerStream(event, Duration(milliseconds: searchEvent ? 500 : 0));
    }));

    return super.transform(transformed, next);
  }

  @override
  Stream<ListState<D>> mapEventToState(ListEvent event) async* {

    if(event == null) {
      return;
    }

    if(!currentState.contains(event)) {

      print("<$prefix> loading page=${event.page}");
      yield currentState.loading(event.query, event.page);

      try {
        BaseListResponse<D> response = await loadData(event);

        print("<$prefix> loaded page=${event.page} length=${response.results.length}");
        yield currentState.complete(response.results, response.total);

      } on Exception {
        _errorStream.add("Some error occured");

      }
    }
  }

  void addErrorListener(Function(String) listener) {
    _errorStream.listen(listener);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print('<$prefix> error');
    if(error is Exception) {
      Exception e = error;
      _errorStream.sink.add(e.toString());
    }
  }

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }
}