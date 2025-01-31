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

class Gastly extends SpriteAnimationComponent
    with HasGameReference<CuboneGame>, KeyboardHandler, CollisionCallbacks {
  int horizontalDirection = 0;

  Vector2 velocidadGastly = Vector2.zero();
  final double aceleracionGastly = 200;

  final double gravityGastly = 280;
  double jumpSpeedGastly = 2000;

  bool hasJumpedGastly = false;
  bool isOnGroundGastly = false;
  bool isRightWallGastly = false;
  bool isLefWallGastly = false;

  int iCoins = 0;
  int get coins => iCoins;

  int iVidas = 3;

  int iSkulls = 0;
  int get skulls => iSkulls;

  bool isAttackingGastly = false;
  late Future<void> attackFutureGastly;

  // Variables del dash
  bool isDashingGastly = false;
  final double dashSpeedGastly = 1000; // velocidadGastly del dash (hacia la izquierda)
  final double dashDurationGastly = 0.2; // Duración del dash (en segundos)
  double dashTimrGastly = 0; // Temporizador para controlar el dash

  Gastly({required super.position})
      : super(size: Vector2(81, 64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('gastly.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(88, 64), // Tamaño correcto de cada frame
        stepTime: 0.20,
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isAttackingGastly) {
      //solo cambiar la animación de ataque si no esta activa
      if (animation?.frames == null || animation!.frames.length != 3) {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('gastlyataque.png'),
          SpriteAnimationData.sequenced(
            amount: 3,
            textureSize: Vector2(88, 64),
            stepTime: 0.30,
          ),
        );
      }
    } else {
      //si no está atacando, mostrar la animación normal de movimiento
      if (animation?.frames == null || animation!.frames.length != 4) {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('gastly.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2(88, 64), // Tamaño correcto de cada frame
            stepTime: 0.20,
          ),
        );
      }
    }
    // Dash en progreso
    if (isDashingGastly) {
      dashTimrGastly -= dt;
      if (dashTimrGastly <= 0) {
        isDashingGastly = false; // Finaliza el dash
        velocidadGastly.x = 0; // Detiene el movimiento horizontal
      }
    } else {
      // Movimiento estándar si no está en dash
      velocidadGastly.x = horizontalDirection * aceleracionGastly;
    }

    // Gravedad y salto
    double temp = gravityGastly;
    if (isOnGroundGastly) {
      temp = 0;
    }
    if (hasJumpedGastly) {
      if (isOnGroundGastly) {
        velocidadGastly.y = -jumpSpeedGastly;
        isOnGroundGastly = false;
      }
      hasJumpedGastly = false;
    }

    velocidadGastly.y += temp;
    velocidadGastly.y = velocidadGastly.y.clamp(-jumpSpeedGastly, temp);

    position += velocidadGastly * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (iCoins == 1) {
      //jumpSpeedGastly = 2300;
    } else if (iCoins == 2) {
      jumpSpeedGastly = 2300;
    } else if (iCoins == 3) {
      jumpSpeedGastly = 2700;
    } else if (iCoins == 4) {
      jumpSpeedGastly = 3000;
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
    if (keysPressed.contains(LogicalKeyboardKey.keyJ)) {
      horizontalDirection = -1;
    }

    // Movimiento hacia la derecha
    if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
      horizontalDirection = 1;
    }

    // Salto
    hasJumpedGastly = keysPressed.contains(LogicalKeyboardKey.keyV);

    // Ataque
    if (keysPressed.contains(LogicalKeyboardKey.keyK) && !isAttackingGastly) {
      isAttackingGastly = true;
      ataqueGastly();
    }

    // Dash
    if (keysPressed.contains(LogicalKeyboardKey.keyN) &&
        iSkulls == 1 &&
        !isDashingGastly) {
      isDashingGastly = true; // Activa el estado de dash
      dashTimrGastly = dashDurationGastly; // Reinicia el temporizador
      velocidadGastly.x = -dashSpeedGastly; // Asigna la velocidadGastly del dash
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyM) &&
        iSkulls == 1 &&
        !isDashingGastly) {
      isDashingGastly = true; // Activa el estado de dash
      dashTimrGastly = dashDurationGastly; // Reinicia el temporizador
      velocidadGastly.x = dashSpeedGastly; // Asigna la velocidadGastly del dash
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void ataqueGastly() {
    final missignos = game.children.query<Missigno>();
    for (final missigno in missignos) {
      if (this.position.distanceTo(missigno.position) < 100) {
        missigno.removeFromParent();
      }
    }
    attackFutureGastly = Future.delayed(Duration(milliseconds: 500), () {
      isAttackingGastly = false;
    });
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is RectangularColision) {
      if (other.y == intersectionPoints.first.y) {
        isOnGroundGastly = true;
      } else if (other.x == intersectionPoints.first.x) {
        isRightWallGastly = true;
      } else if (intersectionPoints.first.x == (other.x + other.width)) {
        isLefWallGastly = true;
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
      game.mostrarDialogo("¡Gastly no sabe nadar! Tocar el agua te hara perder salud");
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is RectangularColision) {
      isOnGroundGastly = false;
      isRightWallGastly = false;
      isLefWallGastly = false;
    }

    super.onCollisionEnd(other);
  }
}
