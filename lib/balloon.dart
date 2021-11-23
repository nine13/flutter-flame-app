import 'package:app/balloon_game_layer.dart';
import 'package:app/game_manager.dart';
import 'package:app/my_new_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class BlueBalloon extends Balloon {
  BlueBalloon(double x, double y, double scale, double moving) : super(x, y, scale, moving);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var aliveAniData = SpriteAnimationData.sequenced(
      amount: 1, stepTime: 0.15, textureSize: Vector2(137, 162), texturePosition: Vector2(0, 0));
    var aliveAnimation = await gameRef.loadSpriteAnimation('balloons.png', aliveAniData);

    animations["alive"] = aliveAnimation;

    var poppingAniData = SpriteAnimationData.sequenced(
      amount: 3, stepTime: 0.1, textureSize: Vector2(137, 162), texturePosition: Vector2(0, 0), loop: false);
    var poppingAnimation = await gameRef.loadSpriteAnimation('balloons.png', poppingAniData);

    animations["popping"] = poppingAnimation;

    anchor = Anchor.topCenter;
    current = "alive";
  }
}

class YellowBalloon extends Balloon {
  YellowBalloon(double x, double y, double scale, double moving) : super(x, y, scale, moving);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var aliveAniData = SpriteAnimationData.sequenced(
      amount: 1, stepTime: 0.15, textureSize: Vector2(137, 162), texturePosition: Vector2(411, 0));
    var aliveAnimation = await gameRef.loadSpriteAnimation('balloons.png', aliveAniData);

    animations["alive"] = aliveAnimation;

    var poppingAniData = SpriteAnimationData.sequenced(
      amount: 3, stepTime: 0.1, textureSize: Vector2(137, 162), texturePosition: Vector2(411, 0), loop: false);
    var poppingAnimation = await gameRef.loadSpriteAnimation('balloons.png', poppingAniData);

    animations["popping"] = poppingAnimation;

    anchor = Anchor.topCenter;
    current = "alive";
  }
}


class GreenBalloon extends Balloon {
  GreenBalloon(double x, double y, double scale, double moving) : super(x, y, scale, moving);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var aliveAniData = SpriteAnimationData.sequenced(
      amount: 1, stepTime: 0.15, textureSize: Vector2(137, 162), texturePosition: Vector2(822, 0));
    var aliveAnimation = await gameRef.loadSpriteAnimation('balloons.png', aliveAniData);

    animations["alive"] = aliveAnimation;

    var poppingAniData = SpriteAnimationData.sequenced(
      amount: 3, stepTime: 0.1, textureSize: Vector2(137, 162), texturePosition: Vector2(822, 0), loop: false);
    var poppingAnimation = await gameRef.loadSpriteAnimation('balloons.png', poppingAniData);

    animations["popping"] = poppingAnimation;

    anchor = Anchor.topCenter;
    current = "alive";
  }
}

enum BalloonState {
  paused,   // not moving and not tappable
  enabled,  // moving and tappable
  disabled, // moving and not tappable
  dying     // RIP
}

class Balloon extends SpriteAnimationGroupComponent with HasGameRef<GameManager>, Tappable {
  var spriteScale = 1.0;
  var dy = 0.0;

  BalloonState balloonState = BalloonState.disabled;

  Balloon(double x, double y, double scale, double dy) : super(animations: <dynamic, SpriteAnimation>{}) {
    width = 137;
    height = 162;
    spriteScale = scale;
    this.scale = Vector2(spriteScale, spriteScale);
    this.x = x;
    this.y = y;
    this.dy = dy;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (balloonState) {
      case BalloonState.paused: break; // no movement
      case BalloonState.dying:
        if(y > gameRef.size.y) {
          die();
        }
        if (animation!.done()) {
          scale = Vector2(spriteScale, spriteScale);
          y += dy*dt;
          dy += 40;
        }
        break;
      default: 
        if(y + height/2 < 0) {
          gameRef.miniGameLayer.lose();
          die();
        }

        y -= dy*dt;
        break;
    }
  }

  void pause() {
    if(balloonState != BalloonState.dying) {
      balloonState = BalloonState.paused;
    }
  }

  void enable() {
    if(balloonState != BalloonState.dying) {
      balloonState = BalloonState.enabled;
    }
  }

  void disable() {
    if(balloonState != BalloonState.dying) {
      balloonState = BalloonState.disabled;
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if(balloonState == BalloonState.enabled) {
      pop();
    }
    return true;
  }

  void die() {
    (gameRef.miniGameLayer as BalloonGameLayer).balloons.remove(this);
    gameRef.remove(this);
  }

  void pop() {
    scale = Vector2(1.0, 1.0);
    current = "popping";
    balloonState = BalloonState.dying;
  }
}