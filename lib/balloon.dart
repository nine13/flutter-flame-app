import 'package:app/balloon_game_layer.dart';
import 'package:app/game_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class BlueBalloon extends Balloon {
  BlueBalloon(double x, double y, double scale, double moving, int _priority) : super(x, y, scale, moving, _priority);

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

    var sadAniData = SpriteAnimationData.sequenced(
      amount: 2, stepTime: 0.2, textureSize: Vector2(137, 162), texturePosition: Vector2(411, 0));
    var sadAnimation = await gameRef.loadSpriteAnimation('balloons.png', sadAniData);

    animations["sad"] = sadAnimation;

    anchor = Anchor.topCenter;
    current = "alive";
  }
}

class YellowBalloon extends Balloon {
  YellowBalloon(double x, double y, double scale, double moving, int _priority) : super(x, y, scale, moving, _priority);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var aliveAniData = SpriteAnimationData.sequenced(
      amount: 1, stepTime: 0.15, textureSize: Vector2(137, 162), texturePosition: Vector2(0, 162));
    var aliveAnimation = await gameRef.loadSpriteAnimation('balloons.png', aliveAniData);

    animations["alive"] = aliveAnimation;

    var poppingAniData = SpriteAnimationData.sequenced(
      amount: 3, stepTime: 0.1, textureSize: Vector2(137, 162), texturePosition: Vector2(0, 162), loop: false);
    var poppingAnimation = await gameRef.loadSpriteAnimation('balloons.png', poppingAniData);

    animations["popping"] = poppingAnimation;

    var sadAniData = SpriteAnimationData.sequenced(
      amount: 2, stepTime: 0.2, textureSize: Vector2(137, 162), texturePosition: Vector2(411, 162));
    var sadAnimation = await gameRef.loadSpriteAnimation('balloons.png', sadAniData);

    animations["sad"] = sadAnimation;

    anchor = Anchor.topCenter;
    current = "alive";
  }
}


class GreenBalloon extends Balloon {
  GreenBalloon(double x, double y, double scale, double moving, int _priority) : super(x, y, scale, moving, _priority);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var aliveAniData = SpriteAnimationData.sequenced(
      amount: 1, stepTime: 0.15, textureSize: Vector2(137, 162), texturePosition: Vector2(0, 324));
    var aliveAnimation = await gameRef.loadSpriteAnimation('balloons.png', aliveAniData);

    animations["alive"] = aliveAnimation;

    var poppingAniData = SpriteAnimationData.sequenced(
      amount: 3, stepTime: 0.1, textureSize: Vector2(137, 162), texturePosition: Vector2(0, 324), loop: false);
    var poppingAnimation = await gameRef.loadSpriteAnimation('balloons.png', poppingAniData);

    animations["popping"] = poppingAnimation;

    var sadAniData = SpriteAnimationData.sequenced(
      amount: 2, stepTime: 0.2, textureSize: Vector2(137, 162), texturePosition: Vector2(411, 324));
    var sadAnimation = await gameRef.loadSpriteAnimation('balloons.png', sadAniData);

    animations["sad"] = sadAnimation;

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

  Balloon(double x, double y, double scale, double dy, int _priority) : super(animations: <dynamic, SpriteAnimation>{}, priority: _priority) {
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
        /*if(y + height < 0) {
          gameRef.miniGameLayer.lose();
          die();
        }*/

        y -= dy*dt;
        break;
    }
  }

  void cry() {
    if(balloonState != BalloonState.dying) {
      current = "sad";
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
      
      var balloonGame = (gameRef.miniGameLayer as BalloonGameLayer);
      if (!balloonGame.popCandidates.contains(this)) {
      
        balloonGame.popCandidates.add(this);
      }
      // pop();
    }
    return true;
  }

  void die() {
    (gameRef.miniGameLayer as BalloonGameLayer).dyingBalloons.remove(this);
    gameRef.remove(this);
  }

  void pop() {
    scale = Vector2(1.0, 1.0);
    current = "popping";
    balloonState = BalloonState.dying;
  }
}