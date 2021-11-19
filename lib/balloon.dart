import 'package:app/my_new_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class BlueBalloon extends Balloon {
  BlueBalloon(double x, double y, double scale, bool moving) : super(x, y, scale, moving);

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

    anchor = Anchor.center;
    current = "alive";
  }
}

class YellowBalloon extends Balloon {
  YellowBalloon(double x, double y, double scale, bool moving) : super(x, y, scale, moving);

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

    anchor = Anchor.center;
    current = "alive";
  }
}


class GreenBalloon extends Balloon {
  GreenBalloon(double x, double y, double scale, bool moving) : super(x, y, scale, moving);

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

    anchor = Anchor.center;
    current = "alive";
  }
}

class Balloon extends SpriteAnimationGroupComponent with HasGameRef<MyNewGame>, Tappable {
  var dy = 150.0;
  bool isMoving = false;

  Balloon(double x, double y, double scale, bool moving) : super(animations: <dynamic, SpriteAnimation>{}) {
    width = 137 * scale;
    height = 162 * scale;
    this.x = x;
    this.y = y;
    isMoving = moving;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (y - height/2 > gameRef.size.y) {
      die();
      dy = 250.0;
    }

    if (isMoving && current == "alive") {
      y -= dy*dt;
    }

    if (current == "popping") {
      if (animation!.done()) {
        y += dy*dt;
        dy += 40;
      }
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    pop();
    return true;
  }

  void die() {
    gameRef.balloons.remove(this);
    shouldRemove = true;
  }

  void pop() {
    width = 137;
    height = 162;
    current = "popping";
  }
}