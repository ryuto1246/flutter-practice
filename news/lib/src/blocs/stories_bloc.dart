import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resorces/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIdsController = StreamController<List<int>>();
  final _itemsFetcher = StreamController<int>();
  final _itemsOutput =
      StreamController<Map<int, Future<ItemModel>>>.broadcast();

  StoriesBloc() {
    _itemsFetcher.stream.scan(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    ).pipe(_itemsOutput);
  }

  Stream<List<int>> get topIds => _topIdsController.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  Function(int) get fetchItem => _itemsFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIdsController.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  dispose() {
    _topIdsController.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
