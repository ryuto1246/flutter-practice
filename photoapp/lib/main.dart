import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/providers.dart';
import 'package:photoapp/screens/sign_in.dart';
import 'package:photoapp/screens/photo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer(
        builder: (context, ref, _) {
          final asyncUser = ref.watch(userProvider);

          return asyncUser.when(
            data: (User? data) {
              return data == null
                  ? const SignInScreen()
                  : const PhotoListScreen();
            },
            loading: () {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            error: (e, stackTrace) {
              return Scaffold(
                body: Center(
                  child: Text(e.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
