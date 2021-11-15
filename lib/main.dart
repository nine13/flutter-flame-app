import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'my_game.dart';

void main() {

  GameWidget gameWidget = GameWidget(game: MyGame());

  runApp(gameWidget);
}