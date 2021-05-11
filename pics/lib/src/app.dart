import "package:flutter/material.dart";

class App extends StatefulWidget {
  createState() => AppState();
}

class AppState extends State<App> {
  int counter = 0;

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Let's See images!"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              counter += 1;
            });
          },
        ),
        body: Center(child: Text("$counter images")),
      ),
    );
  }
}
