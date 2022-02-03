import "package:flutter/material.dart";
import "../models/item_model.dart";
import 'package:html_unescape/html_unescape.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  const Comment({
    Key? key,
    required this.itemId,
    required this.itemMap,
    required this.depth,
  }) : super(key: key);

  @override
  Widget build(context) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return const LoadingContainer();
          }

          final item = snapshot.data!;
          final kids = item.kids.map(
            (kidId) => Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );

          return Column(
            children: [
              ListTile(
                title: buildText(item),
                subtitle: item.by == '' ? const Text('Deleted') : Text(item.by),
                contentPadding: EdgeInsets.only(
                  left: (depth + 1) * 16.0,
                  right: 16.0,
                ),
              ),
              const Divider(),
              ...kids,
            ],
          );
        });
  }

  Widget buildText(ItemModel item) {
    final text = HtmlUnescape().convert(item.text).replaceAll('<p>', '\n\n');

    return Text(text);
  }
}
