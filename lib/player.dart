import 'my_game.dart';
import 'package:flame/components.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef {

  double spriteH = 320;
  double spriteW = 210;
  late double gamePosX;
  late double gamePosY;
  var facingRight = true;
  var moving = false;

  Player(double x, double y) : super(animations: <dynamic, SpriteAnimation>{}) {
    gamePosX = x;
    gamePosY = y;
    height = spriteH;
    width = spriteW;
  }

    @override
    Future<void> onLoad() async {
      await super.onLoad();

      var aniData = SpriteAnimationData.sequenced (
        amount: 4, stepTime: 0.15, textureSize: Vector2(210, 320) );
      var sprAnimation = await gameRef.loadSpriteAnimation('apple.png', aniData);

      animations["idle"] = sprAnimation;

      aniData = SpriteAnimationData.sequenced(
        amount: 1, stepTime: 1, textureSize: Vector2(210, 320));
      sprAnimation = await gameRef.loadSpriteAnimation('apple.png', aniData);
      
      animations["moving"] = sprAnimation;

      // height = 320;
      // width = 210;
      // position = gameRef.size / 2;
      anchor = Anchor.center;

      current = "idle";
    }

    @override
    void update(double dt) {
      super.update(dt);

      if (moving) {
        current = "moving";
      } else {
        current = "idle";
      }
    }

    @override
    void onGameResize(Vector2 canvasSize) {
      super.onGameResize(canvasSize);

      var aspectRatio = canvasSize.x > canvasSize.y ? 
        canvasSize.x / MyGame().gameSize.x :
        canvasSize.y / MyGame().gameSize.y;

      width = spriteW * aspectRatio;
      height = spriteH * aspectRatio;
      position.x = gamePosX * aspectRatio;
      position.y = gamePosY * aspectRatio;
    }

    void isMoving(bool _moving) {
      moving = _moving;
    }

    void move(Vector2 delta) {

      var movingRight = delta.x == 0 ? facingRight : delta.x > 0 ? true : false;

      if ( (movingRight && !facingRight) || (!movingRight && facingRight) ){
        flipHorizontally();
        facingRight = !facingRight;
      }

      position.add(delta);
    }

    void moveTo(Vector2 pos) {
      position = pos;
    }

    bool collide(double x, double y) {

      double leftBound = position.x - width / 2;
      double rightBound = position.x + width / 2;
      double topBound = position.y - height / 2;
      double bottomBound = position.y + height / 2;

      if ( ( x > leftBound && x < rightBound ) && ( y > topBound && y < bottomBound )) {
        return true;
      }

      return false;
    }
}