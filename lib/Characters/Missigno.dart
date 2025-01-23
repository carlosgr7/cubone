import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:cubone/Games/CuboneGame.dart';

import 'Cubone.dart';

class Missigno extends SpriteAnimationComponent with HasGameReference<CuboneGame>, CollisionCallbacks {
  Missigno({
    required super.position,
    required this.movementPoints, // Puntos de movimiento
  }) : super(size: Vector2(80, 80), anchor: Anchor.center);

  late Vector2 _lastPosition; // Para rastrear la posición previa del personaje
  late List<Vector2> movementPoints;
  @override
  void onLoad() {
    // Configurar animación
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('missignospritesheet.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2(60, 60),
        stepTime: 0.30,
      ),
    );

    add(
      CircleHitbox(
        collisionType: CollisionType.passive,
        radius: 26,
        position: Vector2(size.x / 2 - 26, size.y / 2 - 26), // Centrar el círculo
      ),
    );

    _lastPosition = position.clone();

    final startPoint = movementPoints.first;
    if (position != startPoint) {
      movementPoints.insert(0, position);
    }

    // Crear efectos de movimiento
    final effects = <MoveToEffect>[];
    for (int i = 1; i < movementPoints.length; i++) {
      effects.add(
        MoveToEffect(
          movementPoints[i],
          EffectController(duration: 2.0),
        ),
      );
    }

    effects.add(
      MoveToEffect(
        movementPoints.first,
        EffectController(duration: 2.0),
      ),
    );

    add(
      SequenceEffect(
        effects,
        infinite: true,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if ((position.x > _lastPosition.x && scale.x.isNegative)) {
      flipHorizontally();
    }

    if (!(position.x < _lastPosition.x && !scale.x.isNegative)) {
      flipHorizontally();
    }


    _lastPosition = position.clone();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cubone) {
      // removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
