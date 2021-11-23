import 'dart:math';

import 'package:app/game_manager.dart';
import 'package:app/mini_game_layer.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'balloon.dart';
import 'cat.dart';

class BalloonGameLayer extends MiniGameLayer {

  GameManager gm;

  BalloonGameLayer(this.gm);

  var balloons = <SpriteAnimationGroupComponent>{};

  SpriteComponent background = SpriteComponent();

  SpriteComponent startMessage = SpriteComponent(priority: 100);
  Timer startMessageTimer = Timer(1);

  SpriteComponent lostMessage = SpriteComponent(priority: 100);
  Timer lostMessageTimer = Timer(2);

  SpriteComponent winMessage = SpriteComponent(priority: 100);
  Timer winMessageTimer = Timer(4.5);

  @override
  void init() async {
    startMessage
      ..sprite = await gm.loadSprite('popMessage.png')
      ..size = Vector2(334, 24)
      ..position = Vector2(gm.size.x/2, gm.size.y/2)
      ..anchor = Anchor.center;

    lostMessage
      ..sprite = await gm.loadSprite('uhohMessage.png')
      ..size = Vector2(299, 75)
      ..position = Vector2(gm.size.x/2, gm.size.y/2)
      ..anchor = Anchor.center;

    winMessage
      ..sprite = await gm.loadSprite('winMessage.png')
      ..size = Vector2(192, 24)
      ..position = Vector2(gm.size.x/2, gm.size.y/2)
      ..anchor = Anchor.center;

    background
      ..sprite = await gm.loadSprite('realBackground.png')
      ..size = Vector2(480, 320);
      
    gm.add(background);

    reset();
  }

  @override
  void update(double dt) {
    switch (gameState) {
      case GameState.startMessage:
        startMessageTimer.update(dt);
        if(startMessageTimer.finished) {
          gm.remove(startMessage);
          enableBalloons();
          gameState = GameState.playing;
        }
        break;
      case GameState.playing:
        if(balloons.isEmpty) {
          gm.add(Cat(gm.size.x/2, gm.size.y));
          gm.add(winMessage);
          gameState = GameState.winMessage;
          winMessageTimer.start();
        }
        break;
      case GameState.winMessage:
        winMessageTimer.update(dt);
        if(winMessageTimer.finished) {
          gm.remove(winMessage);
          die();
        }
        break;
      case GameState.lostMessage:
        lostMessageTimer.update(dt);
        if(lostMessageTimer.finished) {
          killBalloons();
          gm.remove(lostMessage);
          die();
        }
        break;
      default: break;
    }
  }

  void generateBalloon() {

    Random rand = Random();

    var xPos = (rand.nextInt(4) + 1) * gm.size.x/5;
    var yPos = (rand.nextInt(4) + 1) * gm.size.y/5;

    var scale = rand.nextDouble();
    if (scale < 0.5) {
      scale = 1.0 - scale;
    }
    var type = rand.nextInt(3);

    double moving;

    if(rand.nextInt(2) == 0) {
      yPos = gm.size.y;
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
    gm.add(bal);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    // super.onTapDown(pointerId, info);

    if (gameState == GameState.lostMessage && lostMessageTimer.finished) {
      killBalloons();
      gm.remove(lostMessage);
      reset();
    }
  }

  @override
  void lose() {
    if(gameState == GameState.playing) {
      disableBalloons();
      gm.add(lostMessage);
      lostMessageTimer.start();
      gameState = GameState.lostMessage;
    }
  }

  @override
  void die() {
    gm.gameManagerState = GameManagerState.chooseMiniGame;
  }

  void killBalloons() {
    for(var balloon in balloons) {
      gm.remove(balloon);
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

  void reset() {

    for (int i = 0; i < 5; i++) {
      generateBalloon();
    }
    pauseBalloons();

    gm.add(startMessage);
    startMessageTimer.start();

    gameState = GameState.startMessage;
  }
}