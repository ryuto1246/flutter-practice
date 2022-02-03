import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  late final Widget child;

  // ignore: prefer_const_constructors_in_immutables
  Refresh({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
