import 'package:flame/components.dart';
import 'package:flame/layers.dart';

import 'game_manager.dart';

enum MainScreenState {
  enteringGame,
  inGame,
  exitingGame,
  mainScreen
}

class MainScreenLayer extends DynamicLayer {

  MainScreenState mainScreenState = MainScreenState.mainScreen;

  GameManager gm;

  MainScreenLayer(this.gm);

  var mainScreenSprite = SpriteComponent(priority: 200);
  Timer enterGameTimer = Timer(1);
  Timer exitGameTimer = Timer(1);

  void init() async { 
    mainScreenSprite
      ..sprite = await gm.loadSprite('test.png')
      ..size = Vector2(480, 320);

    gm.add(mainScreenSprite);
  }

  void update(double dt) { }

  @override
  void drawLayer() { }
}