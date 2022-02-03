import 'package:flutter/material.dart';
import 'package:news/src/screens/news_detail.dart';
import 'screens/news_list.dart';
import './blocs/stories_provider.dart';
import './blocs/comments_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) {
          StoriesProvider.of(context).fetchTopIds();
          return const NewsList();
        });
      default:
        return MaterialPageRoute(builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name?.replaceFirst('/', '') ?? "0");

          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(itemId: itemId);
        });
    }
  }
}
