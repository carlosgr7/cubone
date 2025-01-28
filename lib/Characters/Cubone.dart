import 'dart:ui';

import 'package:cubone/Characters/Coin.dart';
import 'package:cubone/Characters/Missigno.dart';
import 'package:cubone/Colisiones/WaterColision.dart';
import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

import '../Colisiones/RectangularColision.dart';
import 'Skull.dart';

class Cubone extends SpriteAnimationComponent
    with HasGameReference<CuboneGame>, KeyboardHandler, CollisionCallbacks {
  int horizontalDirection = 0;

  Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  final double gravity = 280;
  double jumpSpeed = 2000;

  bool hasJumped = false;
  bool isOnGround = false;
  bool isRightWall = false;
  bool isLeftWall = false;

  int iCoins = 0;
  int get coins => iCoins;

  int iVidas = 3;

  int iSkulls = 0;
  int get skulls => iSkulls;

  bool isAttacking = false;
  late Future<void> attackFuture;

  // Variables del dash
  bool isDashing = false;
  final double dashSpeed = 1000; // Velocidad del dash (hacia la izquierda)
  final double dashDuration = 0.2; // Duración del dash (en segundos)
  double dashTimer = 0; // Temporizador para controlar el dash

  Cubone({required super.position})
      : super(size: Vector2(60, 60), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('cubonesequence1.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: Vector2(32.5, 42),
        stepTime: 0.20,
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isAttacking) {
      //solo cambiar la animación de ataque si no esta activa
      if (animation?.frames == null || animation!.frames.length != 3) {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('cuboneataque.png'),
          SpriteAnimationData.sequenced(
            amount: 3,
            textureSize: Vector2(50, 50),
            stepTime: 0.30,
          ),
        );
      }
    } else {
      //si no está atacando, mostrar la animación normal de movimiento
      if (animation?.frames == null || animation!.frames.length != 5) {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('cubonesequence1.png'), // Animación de movimiento
          SpriteAnimationData.sequenced(
            amount: 5,
            textureSize: Vector2(32.5, 42),
            stepTime: 0.20,
          ),
        );
      }
    }
    // Dash en progreso
    if (isDashing) {
      dashTimer -= dt;
      if (dashTimer <= 0) {
        isDashing = false; // Finaliza el dash
        velocidad.x = 0; // Detiene el movimiento horizontal
      }
    } else {
      // Movimiento estándar si no está en dash
      velocidad.x = horizontalDirection * aceleracion;
    }

    // Gravedad y salto
    double temp = gravity;
    if (isOnGround) {
      temp = 0;
    }
    if (hasJumped) {
      if (isOnGround) {
        velocidad.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }

    velocidad.y += temp;
    velocidad.y = velocidad.y.clamp(-jumpSpeed, temp);

    position += velocidad * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (iCoins == 1) {
      //jumpSpeed = 2300;
    } else if (iCoins == 2) {
      jumpSpeed = 2300;
    } else if (iCoins == 3) {
      jumpSpeed = 2700;
    } else if (iCoins == 4) {
      jumpSpeed = 3000;
    }

    if (iVidas <= 0) {
      FlameAudio.play('gameover.mp3', volume: .75);
      game.showGameOverScreen(); //gameOver
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;

    // Movimiento hacia la izquierda
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection = -1;
    }

    // Movimiento hacia la derecha
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection = 1;
    }

    // Salto
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    // Ataque
    if (keysPressed.contains(LogicalKeyboardKey.keyS) && !isAttacking) {
      isAttacking = true;
      ataqueCubone();
    }

    // Dash
    if (keysPressed.contains(LogicalKeyboardKey.keyX) &&
        iSkulls == 1 &&
        !isDashing) {
      isDashing = true; // Activa el estado de dash
      dashTimer = dashDuration; // Reinicia el temporizador
      velocidad.x = -dashSpeed; // Asigna la velocidad del dash
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyC) &&
        iSkulls == 1 &&
        !isDashing) {
      isDashing = true; // Activa el estado de dash
      dashTimer = dashDuration; // Reinicia el temporizador
      velocidad.x = dashSpeed; // Asigna la velocidad del dash
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void ataqueCubone() {
    final missignos = game.children.query<Missigno>();
    for (final missigno in missignos) {
      if (this.position.distanceTo(missigno.position) < 100) {
        missigno.removeFromParent();
      }
    }
    attackFuture = Future.delayed(Duration(milliseconds: 500), () {
      isAttacking = false;
    });
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is RectangularColision) {
      if (other.y == intersectionPoints.first.y) {
        isOnGround = true;
      } else if (other.x == intersectionPoints.first.x) {
        isRightWall = true;
      } else if (intersectionPoints.first.x == (other.x + other.width)) {
        isLeftWall = true;
      }
    }

    if (other is Coin) {
      iCoins++;
      game.collectCoin();
    }

    if (other is Missigno) {
      iVidas--;
      game.loseLife();
    }
    if (other is Skull) {
      iSkulls++;
      game.collectSkull();
    }
    if(other is Skull && iSkulls == 1){
      game.mostrarDialogo("Has desbloqueado el poder de dashear. Pulsa X para desplazarte a la izquierda y C para desplazarte a la derecha");
    }
    if(other is WaterColision){
      iVidas--;
      game.loseLife();
    }
    if(other is WaterColision && (iVidas == 2 || iVidas == 1)){
      game.mostrarDialogo("¡Cubone no sabe nadar! Tocar el agua te hara perder salud");
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is RectangularColision) {
      isOnGround = false;
      isRightWall = false;
      isLeftWall = false;
    }

    super.onCollisionEnd(other);
  }
}
