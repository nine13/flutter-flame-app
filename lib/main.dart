import 'package:app/game_manager.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void gameOver() { 
    setState(() {
      _gm = null;
    });
  }

  GameManager? _gm;

  @override
  Widget build(BuildContext context) {
    
  if (_gm != null) {
      return Stack(
        children: [
          GameWidget(
            game: GameManager(gameOver),
          ),
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
                  _gm = GameManager(gameOver);
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