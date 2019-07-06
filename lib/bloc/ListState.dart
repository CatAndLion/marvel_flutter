import 'package:collection/collection.dart';
import 'package:marvel_flutter/bloc/ListEvent.dart';
class ListState<T> {

  final bool isLoading;
  final int page;
  int _total;
  String _query;
  UnmodifiableListView<T> data;

  ListState._internal(Iterable<T> data, this.isLoading, this._query,  this.page, this._total) :
      this.data = data != null ? UnmodifiableListView(data) : null;

  ListState.empty() : this._internal(null, false, "", 0, 0);

  ListState<T> loading(String query, int page) {
    final first = page == 1;
    return ListState._internal(!first ? data : null, true, query, page, !first ? total : 0);
  }

  ListState<T> complete(Iterable<T> data, int total) {
    var list = this.data != null ? List.of(this.data) : null;
    if(list == null) {
      list = List.of(data);
    } else {
      list.addAll(data);
    }
    return ListState._internal(list, false, query, page, total);
  }

  bool contains(ListEvent event) {
    return event == null || (event.page == page && event.page > 0 &&
        event.query == _query);
  }

  bool get isEmpty => data == null && total == 0;
  int get size => data?.length ?? 0;
  String get query => _query;
  int get total => _total;
}