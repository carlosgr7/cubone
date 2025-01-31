import 'package:cubone/Characters/Gastly.dart';
import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'Cubone.dart';

class Coin extends SpriteAnimationComponent with HasGameReference<CuboneGame>, CollisionCallbacks{




  Coin({required super.position,}):super(size: Vector2(50,50), anchor: Anchor.center);

  @override
  void onLoad() {

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('coinspritesheet.png'),
      SpriteAnimationData.sequenced(
        amount:3,
        textureSize: Vector2(120,240),
        stepTime: 0.50,
      ),
    );

    add(RectangleHitbox(collisionType: CollisionType.passive));
    //add(effect);


    //scale=Vector2(0.5, 0.5);
    //final groundImage = game.images.fromCache('misidra2.png');
    //sprite = Sprite(groundImage);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart

    if(other is Cubone || other is Gastly){
      //size*=2;

      //if(intersectionPoints.first.y==(other.y+other.height)){
      removeFromParent();
      //}

    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    if(other is Cubone){
      //size/=2;
      //if(intersectionPoints.first.y==(other.y+other.height)){
      //removeFromParent();
      //}

    }
    super.onCollisionEnd(other);
  }



}