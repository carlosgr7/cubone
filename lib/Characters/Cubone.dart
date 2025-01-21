import 'dart:ui';

import 'package:cubone/Characters/Coin.dart';
import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../Colisiones/RectangularColision.dart';

class Cubone extends SpriteAnimationComponent with HasGameReference<CuboneGame>, KeyboardHandler, CollisionCallbacks{

  int horizontalDirection=0;

  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  final double gravity = 50;
  double jumpSpeed = 800;
  //final double terminalVelocity = 150;

  bool hasJumped = false;
  bool isOnGround=false;
  bool isRightWall=false;
  bool isLeftWall=false;

  int iCoins = 0;

  Cubone({required super.position,}) :
        super(size: Vector2(60,60), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('cubonesequence1.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: Vector2(32.5,42),
        stepTime: 0.20,
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.active));

  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocidad.x = horizontalDirection * aceleracion ;
    double temp=gravity;
    if (isOnGround) {
      temp=0;
    }

    // Determine if ember has jumped
    if (hasJumped) {
      if (isOnGround) {
      velocidad.y = -jumpSpeed;
      isOnGround=false;
      }
      hasJumped = false;
    }



    // Prevent ember from jumping to crazy fast as well as descending too fast and
    // crashing through the ground or a platform.
    velocidad.y += temp;
    velocidad.y = velocidad.y.clamp(-jumpSpeed, temp);

    position += velocidad * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if(iCoins>=3){
      jumpSpeed=1200;
    }



  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection=0;

    if(keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection=-1;
    }

    if((keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) && !isRightWall){
      horizontalDirection=1;
    }

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is RectangularColision) {
      // Verifica si está tocando el suelo
      if (other.y == intersectionPoints.first.y) {
        isOnGround = true;
      }
      // Verifica si está tocando la pared derecha
      else if (other.x == intersectionPoints.first.x) {
        isRightWall = true;
      }
      // Verifica si está tocando la pared izquierda
      else if (intersectionPoints.first.x == (other.x + other.width)) {
        isLeftWall = true;
      }
    }

    if(other is Coin){
      iCoins++;
    }


    super.onCollisionStart(intersectionPoints, other);
  }


  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    if(other is RectangularColision){
      isOnGround=false;
      isRightWall=false;
      isLeftWall=false;
    }

    super.onCollisionEnd(other);
  }

}