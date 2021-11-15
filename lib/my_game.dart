import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class MyGame extends FlameGame with PanDetector {
  late final Player player;
  bool moving = false;
  late Vector2 screenSize;
  Vector2 get gameSize => Vector2(1080, 1080);
  late double aspectRatio = canvasSize.y / gameSize.y;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player(gameSize.x / 2, gameSize.y / 2);

    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // print(screenSize);
    player.isMoving(false);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Rect bgRect = Rect.fromLTWH(
      0, 
      0, 
      gameSize.x * aspectRatio, 
      gameSize.y * aspectRatio
    );
    Paint bgPaint = Paint();
    bgPaint.color = const Color(0xff576574);
    canvas.drawRect(bgRect, bgPaint);


    player.render(canvas);

  }

  @override
  void onPanStart(DragStartInfo info) {
    moving = player.collide(info.raw.globalPosition.dx, info.raw.globalPosition.dy);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    screenSize = canvasSize;

    aspectRatio = screenSize.y / gameSize.y;

    // print(aspectRatio);

  }

  @override
  void onPanUpdate(DragUpdateInfo info) {

    if (moving && info.delta.game.x.abs() > 0.35) {
      player.move(Vector2(info.delta.game.x, 0));
      player.isMoving(true);
    } else {
      player.isMoving(false);
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    moving = false;
    player.isMoving(false);
  }
}