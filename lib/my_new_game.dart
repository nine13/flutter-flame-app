import 'dart:math';

import 'package:app/balloon.dart';
import 'package:app/cat.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class MyNewGame extends FlameGame with HasTappableComponents {
  SpriteComponent background = SpriteComponent();
  var balloons = <SpriteAnimationGroupComponent>{};
  bool noCat = true;

  MyNewGame() {
    camera.viewport = FixedResolutionViewport(Vector2(480, 320));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    background
      ..sprite = await loadSprite('realBackground.png')
      ..size = Vector2(480, 320);
      
    add(background);

    reset();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (balloons.isEmpty && noCat) {
      add(Cat(size.x/2, size.y));
      noCat = false;
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

    bool moving;

    if(rand.nextInt(2) == 0) {
      yPos = size.y;
      moving = true;
    } else {
      moving = false;
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

  void reset() {
    for (int i = 0; i < 5; i++) {
      generateBalloon();
    }

    noCat = true;
  }
}