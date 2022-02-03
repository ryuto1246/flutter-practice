import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  late final CommentsBloc bloc;

  CommentsProvider({Key? key, required Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static CommentsBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CommentsProvider>()!.bloc;
}
