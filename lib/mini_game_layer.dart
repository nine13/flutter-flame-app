import 'package:app/game_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layers.dart';

enum GameState{
  startMessage,
  playing,
  winMessage,
  lostMessage
}

class MiniGameLayer extends DynamicLayer {

  GameState gameState = GameState.startMessage;
  
  void init() async { /* should be overridden */ }

  void update(double dt) { /* should be overridden */ }

  @override
  void drawLayer() { }

  void onTapDown(int pointerId, TapDownInfo info) { }

  void lose() { /* should be overridden */}

  void die() { /* should be overridden */ }
}