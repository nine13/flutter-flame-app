import 'package:app/mini_game_layer.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/layers.dart';
import 'package:flutter/painting.dart';

import 'balloon_game_layer.dart';

enum GameManagerState {
  chooseMiniGame,
  waitingToStartMiniGame,
  playingMiniGame
}

class GameManager extends FlameGame with HasTappableComponents {

  GameManagerState gameManagerState = GameManagerState.chooseMiniGame;

  Timer startNewMiniGameTimer = Timer(2);

  late PreRenderedLayer backgroundLayer;
  late MiniGameLayer miniGameLayer;
  late DynamicLayer mainScreenLayer;

  GameManager() {
    camera.viewport = FixedResolutionViewport(Vector2(480, 320));
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);

    miniGameLayer.onTapDown(pointerId, info);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // miniGameLayer = BalloonGameLayer(this);    

    // miniGameLayer.init();
    // startNewMiniGameTimer.start();
  }

  void chooseMiniGame() {
    miniGameLayer = BalloonGameLayer(this);
    miniGameLayer.init();
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (gameManagerState) {
      case GameManagerState.chooseMiniGame:
        chooseMiniGame();
        gameManagerState = GameManagerState.waitingToStartMiniGame;
        startNewMiniGameTimer.start();
        break;
      case GameManagerState.waitingToStartMiniGame:
        startNewMiniGameTimer.update(dt);
        if(startNewMiniGameTimer.finished) {
          gameManagerState = GameManagerState.playingMiniGame;
        }
        break;
      case GameManagerState.playingMiniGame:
        miniGameLayer.update(dt);
        break;
      default: break;
    }
  }

  @override
  void render(Canvas canvas) {
    switch (gameManagerState) {
      case GameManagerState.chooseMiniGame: break;
      case GameManagerState.waitingToStartMiniGame: break;
      default: 
        super.render(canvas);
        break;
    }
  }
}