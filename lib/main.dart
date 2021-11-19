import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'my_new_game.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyNewGame? _game;

  @override
  Widget build(BuildContext context) {
    
    if (_game != null) {
      return Stack(
        children: [
          GameWidget(game: MyNewGame()),
        ],
      );
    }
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            IconButton(
              icon: (const Icon(Icons.play_arrow)),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _game = MyNewGame();
                });
              })
        ],
      ),
    );
  }
}

void main() {

  runApp(
    const MaterialApp(
      home: Scaffold(
        body: MyApp(),
      ),
    ),
  );
}