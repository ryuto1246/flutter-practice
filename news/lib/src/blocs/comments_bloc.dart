import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resorces/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = StreamController<int>();
  final _commentsOutput = StreamController<Map<int, Future<ItemModel>>>.broadcast();

  CommentsBloc() {
    _commentsFetcher.stream.scan(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        cache[id]!.then((ItemModel item) {
          for (int kidId in item.kids) {
            fetchItemWithComments(kidId);
          }
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    ).pipe(_commentsOutput);
  }

  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;
}
