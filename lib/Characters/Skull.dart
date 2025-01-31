import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../Games/CuboneGame.dart';
import 'Cubone.dart';
import 'Gastly.dart';

class Skull extends SpriteComponent with HasGameReference<CuboneGame>, CollisionCallbacks {
  Skull({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('skull.png'); // Asegúrate de tener el asset.
    add(RectangleHitbox()); // Para detectar colisiones.
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cubone || other is Gastly) {

      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
