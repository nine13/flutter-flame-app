import 'package:app/game_manager.dart';
import 'package:flame/components.dart';

class Cat extends SpriteAnimationGroupComponent with HasGameRef<GameManager> {
  var dy = -150.0;

  Cat(double x, double y) : super(animations: <dynamic, SpriteAnimation>{}) {
    width = 186;
    height = 269;
    this.x = x;
    this.y = y;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var catAniData = SpriteAnimationData.sequenced(
      amount: 4, stepTime: 0.2, textureSize: Vector2(186, 269));
    var catAnimation = await gameRef.loadSpriteAnimation('cat.png', catAniData);

    animations["cat"] = catAnimation;

    anchor = Anchor.topCenter;
    current = "cat";
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (y + height < 0) {
      die();
    }

    y += dy*dt;
  }

  void die() {
    gameRef.remove(this);
  }
}