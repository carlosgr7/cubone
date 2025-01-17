import 'dart:ui';

import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/components.dart';

class Cubone extends SpriteAnimationComponent with HasGameReference<CuboneGame>, KeyboardHandler{


  Cubone({required super.position,}) :
        super(size: Vector2(128,128), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('cubone.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );

  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

  }
}