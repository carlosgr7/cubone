import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class WaterColision extends PositionComponent with CollisionCallbacks{

  WaterColision({required super.position,required super.size});

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad


    add(RectangleHitbox(collisionType: CollisionType.passive));

    return super.onLoad();
  }

}