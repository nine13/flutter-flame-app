import 'dart:math';

import 'package:app/game_manager.dart';
import 'package:app/mini_game_layer.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'balloon.dart';
import 'cat.dart';

class BalloonGameLayer extends MiniGameLayer {

  GameManager gm;

  BalloonGameLayer(this.gm);

  var balloons = <SpriteAnimationGroupComponent>{};
  var dyingBalloons = <SpriteAnimationGroupComponent>{};
  var popCandidates = <SpriteAnimationGroupComponent>{};

  SpriteComponent background = SpriteComponent();

  SpriteComponent startMessage = SpriteComponent(priority: 100);
  Timer startMessageTimer = Timer(1);

  SpriteComponent lostMessage = SpriteComponent(priority: 100);
  Timer lostMessageTimer = Timer(4.5);

  SpriteComponent winMessage = SpriteComponent(priority: 100);
  Timer winMessageTimer = Timer(4.5);

  SpriteComponent countDown = SpriteComponent(priority: 100);
  Timer countDownTimer = Timer(3);
  var currentCountDownDigit = 3;

  @override
  void init() async {
    startMessage
      ..sprite = await gm.loadSprite('popMessage.png')
      ..size = Vector2(334, 24)
      ..position = Vector2(gm.size.x/2, gm.size.y/2)
      ..anchor = Anchor.center;

    lostMessage
      ..sprite = await gm.loadSprite('youLostMessage.png')
      ..size = Vector2(172, 23)
      ..position = Vector2(gm.size.x/2, gm.size.y/2)
      ..anchor = Anchor.center;

    winMessage
      ..sprite = await gm.loadSprite('winMessage.png')
      ..size = Vector2(192, 24)
      ..position = Vector2(gm.size.x/2, gm.size.y/2)
      ..anchor = Anchor.center;

    countDown
      ..sprite = gm.sprites['3']
      ..size = Vector2(20, 23)
      ..anchor = Anchor.topLeft
      ..position = Vector2(440, 277);

    background
      ..sprite = await gm.loadSprite('realBackground.png')
      ..size = Vector2(480, 320);
      
    gm.add(background);
  }

  void updateCurrentCountDownDigit(int newDigit) {
    countDown.sprite = gm.sprites[newDigit.toString()];
    currentCountDownDigit = newDigit;
  }

  @override
  void update(double dt) {

    switch (gameState) {
      case GameState.startMessage:
        startMessageTimer.update(dt);
        if(startMessageTimer.finished) {
          gm.remove(startMessage);

          gm.add(countDown);
          countDownTimer.start();

          enableBalloons();
          gameState = GameState.playing;
        }
        break;
      case GameState.playing:

        countDownTimer.update(dt);

        var countDownDigit = 3 - countDownTimer.current.toInt();

        if (countDownDigit > 0 && countDownDigit < currentCountDownDigit) {
          updateCurrentCountDownDigit(countDownDigit);
        }

        

        if(popCandidates.isNotEmpty) {
          Balloon bal = (popCandidates.elementAt(0) as Balloon);

          for(var popCandidate in popCandidates) {
            if (popCandidate.priority > bal.priority) {
              bal = (popCandidate as Balloon);
            }
          }

          popCandidates.clear();

          balloons.remove(bal);
          dyingBalloons.add(bal);
          bal.pop();

        }
        if(balloons.isEmpty) {
          gm.remove(countDown);
          gm.add(Cat(gm.size.x/2, gm.size.y));
          gm.add(winMessage);
          gameState = GameState.winMessage;
          winMessageTimer.start();
        }

        if(countDownTimer.finished) {
          if (balloons.isNotEmpty) {
            gm.remove(countDown);
            disableBalloons();
            makeBalloonsCry();
            gm.add(lostMessage);
            lostMessageTimer.start();
            gameState = GameState.lostMessage;
          }
        }

        break;
      case GameState.winMessage:
        winMessageTimer.update(dt);
        if(winMessageTimer.finished) {
          gm.remove(winMessage);
          // die();

          // UPDATE SCORE IN GAME MANAGER

          gm.add(gm.mainScreenOverlay);

          gm.gameManagerState = GameManagerState.exitingMiniGame;
          gm.exitMiniGameTimer.start();
        }
        break;
      case GameState.lostMessage:
        lostMessageTimer.update(dt);
        if(lostMessageTimer.finished) {
          killBalloons();
          gm.remove(lostMessage);

          // UPDATE LIVES IN GAME MANAGER
          gm.updatePlayerLives(gm.numPlayerLives - 1);

          gm.add(gm.mainScreenOverlay);

          gm.gameManagerState = GameManagerState.exitingMiniGame;
          gm.exitMiniGameTimer.start();
        }
        break;
      default: break;
    }
  }

  void generateBalloon(int priority) {

    Random rand = Random();

    var safeWidth = gm.size.x - 50;
    var safeHeight = gm.size.y - 75;

    var xPos = (rand.nextInt(8) * safeWidth/9) + 65;
    var yPos = rand.nextInt(8) * safeHeight/9;

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
      bal = GreenBalloon(xPos, yPos, scale, moving, priority);
    } else if(type == 1) {
      bal = YellowBalloon(xPos, yPos, scale, moving, priority);
    } else {
      bal = BlueBalloon(xPos, yPos, scale, moving, priority);
    }

    balloons.add(bal);
    gm.add(bal);
  }

  // @override
  // void onTapDown(int pointerId, TapDownInfo info) {
  //   // super.onTapDown(pointerId, info);

  //   if (gameState == GameState.lostMessage && lostMessageTimer.finished) {
  //     killBalloons();
  //     gm.remove(lostMessage);
  //     reset();
  //   }
  // }

  /*@override
  void lose() {
    if(gameState == GameState.playing) {
      disableBalloons();
      makeBalloonsCry();
      gm.add(lostMessage);
      lostMessageTimer.start();
      gameState = GameState.lostMessage;
    }
  }*/

  @override
  void die() {
    gm.remove(background);
  }

  void makeBalloonsCry() {
    for (var balloon in balloons) {
      (balloon as Balloon).cry();
    }
  }

  void killBalloons() {
    for(var balloon in balloons) {
      gm.remove(balloon);
    }
    balloons.clear();

    for(var balloon in dyingBalloons) {
      gm.remove(balloon);
    }
    dyingBalloons.clear();
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

  @override
  void start() {

    Random rand = Random();

    var numBalloons = rand.nextInt(3) + 5;

    for (int i = 0; i < numBalloons; i++) {
      generateBalloon(i);
    }
    pauseBalloons();

    gm.add(startMessage);
    startMessageTimer.start();

    gameState = GameState.startMessage;
  }
}