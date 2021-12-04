import 'package:app/mini_game_layer.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'balloon_game_layer.dart';

enum GameManagerState {
  chooseMiniGame,
  countingDown,
  enteringMiniGame,
  playingMiniGame,
  exitingMiniGame,
  gameOverMessage,
  exitGame
}

class GameManager extends FlameGame with HasTappableComponents {

  late GameManagerState gameManagerState;

  late MiniGameLayer miniGameLayer;

  SpriteComponent background = SpriteComponent();

  SpriteComponent mainScreenOverlay = SpriteComponent(priority: 200);
  var minMainScreenOverlayScale = 1.0;
  var maxMainScreenOverlayScale = 1.35;

  var mainScreenOverlayScale = 1.0;

  SpriteComponent livesLeft = SpriteComponent(priority: 50);
  SpriteComponent numLives = SpriteComponent(priority: 50);
  SpriteComponent nextVideo = SpriteComponent(priority: 50);
  SpriteComponent countDown = SpriteComponent(priority: 50);
  SpriteComponent playIcon = SpriteComponent(priority: 50);
  SpriteComponent gameOverMessage = SpriteComponent(priority: 50);

  Timer enterMiniGameTimer = Timer(.5);
  Timer exitMiniGameTimer = Timer(.5);

  Timer countDownTimer = Timer(3);
  var currentCountDownDigit = 3;

  int numPlayerLives = 4;

  var sprites = <String, Sprite>{};
  
  void Function() gameOver;
  Timer gameOverMessageTimer = Timer(3);

  GameManager(this.gameOver) {
    camera.viewport = FixedResolutionViewport(Vector2(480, 320));
  }

  void gameOverCallBack() { gameOver(); }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);

    miniGameLayer.onTapDown(pointerId, info);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprites['1'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(0, 0), srcSize: Vector2(20, 23));
    sprites['2'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(20, 0), srcSize: Vector2(20, 23));
    sprites['3'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(40, 0), srcSize: Vector2(20, 23));
    sprites['4'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(60, 0), srcSize: Vector2(20, 23));
    sprites['5'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(80, 0), srcSize: Vector2(20, 23));
    sprites['livesLeft'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(0, 23), srcSize: Vector2(188, 23));
    sprites['nextVideo'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(0, 46), srcSize: Vector2(292, 23));
    sprites['playIcon'] = await loadSprite('mainScreenOverlayText.png', srcPosition: Vector2(188, 0), srcSize: Vector2(50, 46));

    gameOverMessage
      ..sprite = await loadSprite('gameOverMessage.png')
      ..size = Vector2(189, 23)
      ..anchor = Anchor.topLeft
      ..position = Vector2(84, 109);

    background
      ..sprite = await loadSprite('mainScreenBackground.png')
      ..size = Vector2(480, 320);

  add(background);

  livesLeft
    ..sprite = sprites['livesLeft']
    ..size = Vector2(188, 23)
    ..anchor = Anchor.topLeft
    ..position = Vector2(69, 15);

  numLives
    ..sprite = sprites['4']
    ..size = Vector2(20, 23)
    ..anchor = Anchor.topLeft
    ..position = Vector2(272, 15);

  nextVideo
    ..sprite = sprites['nextVideo']
    ..size = Vector2(292, 23)
    ..anchor = Anchor.topLeft
    ..position = Vector2(12, 199);

  countDown
    ..sprite = sprites['3']
    ..size = Vector2(20, 23)
    ..anchor = Anchor.topLeft
    ..position = Vector2(320, 199);

  playIcon
    ..sprite = sprites['playIcon']
    ..size = Vector2(50, 46)
    ..anchor = Anchor.topLeft
    ..position = Vector2(155, 98);

  addOverlayText();

    mainScreenOverlay
      ..sprite = await loadSprite('mainScreenOverlay.png')
      ..size = Vector2(480, 320)
      ..anchor = Anchor.topLeft
      ..scale = Vector2.all(mainScreenOverlayScale);

  add(mainScreenOverlay);

  chooseMiniGame();
  gameManagerState = GameManagerState.countingDown;
  countDownTimer.start();
  }

  void addOverlayText() {
    add(livesLeft);
    add(numLives);
    add(nextVideo);
    add(countDown);
    add(playIcon);
  }

  void removeOverlayText() {
    remove(livesLeft);
    remove(numLives);
    remove(nextVideo);
    remove(countDown);
    remove(playIcon);
  }

  void chooseMiniGame() {
    miniGameLayer = BalloonGameLayer(this);
    miniGameLayer.init();
  }

  void updateCurrentCountDownDigit(int newDigit) {
    countDown.sprite = sprites[newDigit.toString()];
    currentCountDownDigit = newDigit;
  }

  void updatePlayerLives(int newNumber) {
    numLives.sprite = sprites[newNumber.toString()];
    numPlayerLives = newNumber;
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (gameManagerState) {
      case GameManagerState.chooseMiniGame:

        if(numPlayerLives <= 0) {
          add(gameOverMessage);
          gameManagerState = GameManagerState.gameOverMessage;
          gameOverMessageTimer.start();
          break;
        }

        miniGameLayer.die();
        chooseMiniGame();

        currentCountDownDigit = 3;
        countDown.sprite = sprites['3'];

        addOverlayText();

        gameManagerState = GameManagerState.countingDown;
        countDownTimer.start();
        break;
      case GameManagerState.countingDown:
        countDownTimer.update(dt);

        var countDownDigit = 3 - countDownTimer.current.toInt();
        
        if (countDownDigit > 0 && countDownDigit < currentCountDownDigit) {
          updateCurrentCountDownDigit(countDownDigit);
        }
        
        if(countDownTimer.finished) {
          removeOverlayText();
          gameManagerState = GameManagerState.enteringMiniGame;
          enterMiniGameTimer.start();
        }
        break;
      case GameManagerState.enteringMiniGame:

        mainScreenOverlayScale += (.35 / .5) * dt;

        if(mainScreenOverlayScale >= maxMainScreenOverlayScale) {
          mainScreenOverlayScale = maxMainScreenOverlayScale;
        }

        mainScreenOverlay.scale = Vector2.all(mainScreenOverlayScale);

        enterMiniGameTimer.update(dt);
        if(enterMiniGameTimer.finished) {

          remove(mainScreenOverlay);

          gameManagerState = GameManagerState.playingMiniGame;
          miniGameLayer.start();
        }
        break;
      case GameManagerState.playingMiniGame:
        miniGameLayer.update(dt);
        break;
      case GameManagerState.exitingMiniGame:

        mainScreenOverlayScale -= (.35 / .5) * dt;
        
        if(mainScreenOverlayScale <= minMainScreenOverlayScale) {
          mainScreenOverlayScale = minMainScreenOverlayScale;
        }

        mainScreenOverlay.scale = Vector2.all(mainScreenOverlayScale);

        exitMiniGameTimer.update(dt);
        if(exitMiniGameTimer.finished) {
          gameManagerState = GameManagerState.chooseMiniGame;
        }
        break;
      case GameManagerState.gameOverMessage:

        gameOverMessageTimer.update(dt);
        if(gameOverMessageTimer.finished) {
          gameManagerState = GameManagerState.exitGame;
        }
        break;
      case GameManagerState.exitGame:
        gameOverCallBack();
        break;
      default: break;
    }
  }

  @override
  void onRemove() {
    removeOverlayText();
    remove(gameOverMessage);
    remove(mainScreenOverlay);
    remove(background);

    super.onRemove();
  }
}