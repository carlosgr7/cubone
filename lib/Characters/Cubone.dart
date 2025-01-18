import 'dart:ui';

import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Cubone extends SpriteAnimationComponent with HasGameReference<CuboneGame>, KeyboardHandler{

  int horizontalDirection=0;

  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  final double gravity = 50;
  final double jumpSpeed = 600;
  //final double terminalVelocity = 150;

  bool hasJumped = false;
  bool isOnGround=false;
  bool isRightWall=false;
  bool isLeftWall=false;

  Cubone({required super.position,}) :
        super(size: Vector2(128,128 ), anchor: Anchor.center);

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
      //if (isOnGround) {
      velocidad.y = -jumpSpeed;
      //isOnGround=false;
      //}
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





  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection=0;

    if(keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection=-1;
    }

    if((keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight))){
      horizontalDirection=1;
    }

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }
}