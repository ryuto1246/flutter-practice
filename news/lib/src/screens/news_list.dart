import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final StoriesBloc bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: Center(
        child: buildList(bloc),
      ),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return Refresh(
      child: StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data![index]);

              return NewsListTile(itemId: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
