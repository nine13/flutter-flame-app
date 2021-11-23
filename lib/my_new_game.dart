import 'dart:math';

import 'package:app/balloon.dart';
import 'package:app/cat.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

enum GameState{
  startMessage,
  playing,
  winMessage,
  lostMessage
}

class MyNewGame extends FlameGame with HasTappableComponents {
  SpriteComponent background = SpriteComponent();
  var balloons = <SpriteAnimationGroupComponent>{};

  SpriteComponent startMessage = SpriteComponent(priority: 100);
  Timer startMessageTimer = Timer(1);

  SpriteComponent lostMessage = SpriteComponent(priority: 100);
  Timer lostMessageTimer = Timer(1);

  SpriteComponent winMessage = SpriteComponent(priority: 100);
  Timer winMessageTimer = Timer(4.5);

  GameState gameState = GameState.startMessage;

  MyNewGame() {
    camera.viewport = FixedResolutionViewport(Vector2(480, 320));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    startMessage
      ..sprite = await loadSprite('popMessage.png')
      ..size = Vector2(334, 24)
      ..position = Vector2(size.x/2, size.y/2)
      ..anchor = Anchor.center;

    lostMessage
      ..sprite = await loadSprite('uhohMessage.png')
      ..size = Vector2(299, 75)
      ..position = Vector2(size.x/2, size.y/2)
      ..anchor = Anchor.center;

    winMessage
      ..sprite = await loadSprite('winMessage.png')
      ..size = Vector2(192, 24)
      ..position = Vector2(size.x/2, size.y/2)
      ..anchor = Anchor.center;

    background
      ..sprite = await loadSprite('realBackground.png')
      ..size = Vector2(480, 320);
      
    add(background);

    reset();
  }

  @override
  void update(double dt) {

    super.update(dt);

    switch (gameState) {
      case GameState.startMessage:
        startMessageTimer.update(dt);
        if(startMessageTimer.finished) {
          remove(startMessage);
          enableBalloons();
          gameState = GameState.playing;
        }
        break;
      case GameState.playing:
        if(balloons.isEmpty) {
          add(Cat(size.x/2, size.y));
          add(winMessage);
          gameState = GameState.winMessage;
          winMessageTimer.start();
        }
        break;
      case GameState.winMessage:
        winMessageTimer.update(dt);
        if(winMessageTimer.finished) {
          remove(winMessage);
          reset();
        }
        break;
      case GameState.lostMessage:
        lostMessageTimer.update(dt);
        break;
      default: break;
    }
  }

  void generateBalloon() {

    Random rand = Random();

    var xPos = (rand.nextInt(4) + 1) * size.x/5;
    var yPos = (rand.nextInt(4) + 1) * size.y/5;

    var scale = rand.nextDouble();
    if (scale < 0.5) {
      scale = 1.0 - scale;
    }
    var type = rand.nextInt(3);

    double moving;

    if(rand.nextInt(2) == 0) {
      yPos = size.y;
      moving = 150.0;
    } else {
      moving = 0.0;
    }

    Balloon bal;

    if(type == 0) {
      bal = GreenBalloon(xPos, yPos, scale, moving);
    } else if(type == 1) {
      bal = YellowBalloon(xPos, yPos, scale, moving);
    } else {
      bal = BlueBalloon(xPos, yPos, scale, moving);
    }

    balloons.add(bal);
    add(bal);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);

    if (gameState == GameState.lostMessage && lostMessageTimer.finished) {
      killBalloons();
      remove(lostMessage);
      reset();
    }
  }

  void killBalloons() {
    for(var balloon in balloons) {
      remove(balloon);
    }
    balloons.clear();
  }

  void pauseBalloons() {
    for (var balloon in balloons) {
      (balloon as Balloon).pause();
    }
  }

  void disableBalloons() {
    for(var balloon in balloons) {
        (balloon as Balloon).disable();
    }
  }

  void enableBalloons() {
    for(var balloon in balloons) {
      (balloon as Balloon).enable();
    }
  }

  void lose() {
    if(gameState == GameState.playing) {
      disableBalloons();
      add(lostMessage);
      lostMessageTimer.start();
      gameState = GameState.lostMessage;
    }
  }

  void reset() {

    for (int i = 0; i < 5; i++) {
      generateBalloon();
    }
    pauseBalloons();

    add(startMessage);
    startMessageTimer.start();

    gameState = GameState.startMessage;
  }
}