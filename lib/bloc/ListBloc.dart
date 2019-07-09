import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
import 'package:marvel_flutter/bloc/ListState.dart';
import 'package:marvel_flutter/model/Character.dart';
import 'package:marvel_flutter/model/ComicBook.dart';
import 'package:marvel_flutter/protocol/Marvel.dart';
import 'package:marvel_flutter/protocol/Responses.dart';
import 'package:connectivity/connectivity.dart';
import 'package:marvel_flutter/util/Pair.dart';
import 'package:rxdart/transformers.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

enum ErrorType {
  Data, Server, Connection
}

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

  /// abstractions
  Future<BaseListResponse<D>> loadData(ListEvent event);
  ListState<D> get initialState;
  String get prefix;

  final _exceptionStream = PublishSubject<Exception>();
  final _errorStream = PublishSubject<Pair<ErrorType, String>>();
  Pair<ErrorType, String> _currentError;

  bool _paused;

  int get nextPage => currentState.page + 1;

  bool get canLoad => currentState.size < currentState.total;

  bool get hasData => !currentState.isEmpty && currentState.size > 0;

  bool get isLoading => currentState.isLoading;

  ErrorType get currentError => _currentError?.left;
  String get currentErrorText => _currentError?.right;

  BaseListBloc() {

    //Connectivity().onConnectivityChanged.listen(onConnectionChanged);

    _exceptionStream.forEach((exception) {
      print('Exception: ${exception.runtimeType.toString()}');

      if(exception is http.ClientException) {
        _currentError = Pair(ErrorType.Server, 'Server error');

      } else if(exception is SocketException) {
        _currentError = Pair(ErrorType.Connection, 'Connection error');

      } else {
        _currentError = Pair(ErrorType.Data, 'Data error: ${exception.runtimeType.toString()}');
      }

      _errorStream.add(_currentError);
    });
  }

  @override
  Stream<ListState<D>> transform(Stream<ListEvent> events,
      Stream<ListState<D>> next(ListEvent event)) {

    var transformed = events.transform(DebounceStreamTransformer((event) {
      bool searchEvent = event.query != currentState.query;
      return TimerStream(event, Duration(milliseconds: searchEvent ? 500 : 0));
    })).distinct((prev, next) {
      return currentError == null && prev.page == next.page && prev.query == next.query;
    });

    return super.transform(transformed, next);
  }

  void onConnectionChanged(ConnectivityResult event) {
    if(_currentError?.left == ErrorType.Connection &&
          event != ConnectivityResult.none) {
      dispatch(ListEvent(page: currentState.page, query: currentState.query));
    }
  }

  void onPause() {
    _paused = true;
  }

  void onResume() {
    _paused = false;
  }

  @override
  Stream<ListState<D>> mapEventToState(ListEvent event) async* {

    if(event == null) {
      return;
    }

    if(!currentState.contains(event) || currentError != null) {
      _currentError = null;

      print('<$prefix> loading page=${event.page}');
      yield currentState.loading(event.query, event.page);

      try {
        BaseListResponse<D> response = await loadData(event);

        print('<$prefix> loaded page=${event.page} length=${response.results.length}');
        yield currentState.complete(data: response.results, total: response.total);

      } catch (exception) {
        onError(exception, null);
        yield currentState.complete();
      }
    }
  }

  void addErrorListener(Function(Pair<ErrorType, String>) listener) {
    _errorStream.listen(listener);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    if(error is Exception) {
      _exceptionStream.add(error);
    }
  }

  @override
  void dispose() {
    _exceptionStream.close();
    super.dispose();
  }
}