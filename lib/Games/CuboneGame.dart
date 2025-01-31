import 'dart:async';

import 'package:cubone/Characters/Gastly.dart';
import 'package:cubone/Characters/Missigno.dart';
import 'package:cubone/Characters/Skull.dart';
import 'package:cubone/Colisiones/WaterColision.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Characters/Cubone.dart';
import '../Characters/Coin.dart';
import '../Colisiones/RectangularColision.dart';
import '../Overlays/HudComponent.dart';

class CuboneGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{

  late Cubone _cubone;
  late HudComponent hud;
  late Missigno _missigno;
  late Gastly _gastly;

  String? dialogoTexto;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    // TODO: implement onLoad
    debugMode = false;
    await images.loadAll([
      'back.png',
      'back-tileset.png',
      'middle.png',
      'bg-graveyard.png',
      'bg-moon.png',
      'bg-mountains.png',
      'back-tileset.png',
      'player.png',
      'cubonesequence.png',
      'cubonesequence1.png',
      'coinspritesheet.png',
      'missignospritesheet.png',
      'cuboneataque.png',
      'skull.png',
      'heart.png',
      'coin.png',
      'middle.png',
      'gastly.png',
      'gastlyataque.png'

    ]);

    await FlameAudio.audioCache.load('coincollect.mp3');
    await FlameAudio.audioCache.load('gameover.mp3');
    await FlameAudio.audioCache.load('background.mp3');
    await FlameAudio.audioCache.load('loselife.mp3');

    add(await bgParallax());

    overlays.add('DialogOverlay'); // Registra el overlay
    overlays.remove('DialogOverlay'); // Inicialmente oculto

    TiledComponent mapa1 = await TiledComponent.load("mapa1.tmx", Vector2(128, 128));
    mapa1.scale = Vector2(0.25, 0.25);
    mapa1.position = Vector2(0, -275); // Ajusta el valor de Y para subir el mapa
    add(mapa1);



    add(mapa1);

    _cubone = Cubone(position: Vector2(100, 650));
    _gastly = Gastly(position: Vector2(1700, 650));


    hud = HudComponent();
    add(hud);

    //Para colocar el HUD siempre encima de todo
    hud.priority = 100;



    add(_cubone);
    add(_gastly);

    add(Skull(position: Vector2(1790, 100), size: Vector2(45,45)));

    spawnMissignos();

    //FlameAudio.loop('background.mp3', volume: .75);


    final colisiones_rectangulos = mapa1.tileMap.getLayer<ObjectGroup>('colisiones_rectangulos');
    for (final rectColision in colisiones_rectangulos!.objects) {
      add(RectangularColision(
        position: Vector2(rectColision.x, rectColision.y)+ mapa1.position,
        size: Vector2(rectColision.width, rectColision.height),
      ));
    }

    final colisiones_agua = mapa1.tileMap.getLayer<ObjectGroup>('colisiones_agua');
    for (final waterColision in colisiones_agua!.objects) {
      add(WaterColision(
        position: Vector2(waterColision.x, waterColision.y)+ mapa1.position,
        size: Vector2(waterColision.width, waterColision.height),
      ));
    }

    final objectGroupGems = mapa1.tileMap.getLayer<ObjectGroup>('gemas');
    for (final posGemaEnMapa in objectGroupGems!.objects) {
      add(Coin(position: Vector2(posGemaEnMapa.x, posGemaEnMapa.y)+ mapa1.position));
    }


  }

  Future<ParallaxComponent> bgParallax() async {
    ParallaxComponent parallaxComponent = await loadParallaxComponent([
      ParallaxImageData('back-tileset.png'),
      ParallaxImageData('back.png'),
      ParallaxImageData('middle.png'),

    ], baseVelocity: Vector2(10, 0),
    velocityMultiplierDelta: Vector2(1.5, 0));
    return parallaxComponent;
  }

  void loseLife() {
    hud.updateLives(hud.lives - 1);
    FlameAudio.play('loselife.mp3', volume: .75);
  }

  void collectCoin() {
    hud.updateCoins(_cubone.coins);
    hud.updateCoins(_gastly.coins);
    FlameAudio.play('coincollect.mp3', volume: .75);
  }

  void collectSkull() {
    hud.updateSkulls(_cubone.skulls);
    hud.updateSkulls(_gastly.skulls);

    //FlameAudio.play('coincollect.mp3', volume: .75);
  }

  void spawnMissignos() {
    final missigno1 = Missigno(
      position: Vector2(650, 690),
      movementPoints: [
        Vector2(700, 690), // Punto 1
        Vector2(750, 690), // Punto 2
        Vector2(800, 690), // Punto 3
      ],
    );

    final missigno2 = Missigno(
      position: Vector2(1000, 750),
      movementPoints: [
        Vector2(900, 640),
        Vector2(1000, 550),
        Vector2(1150, 640),
      ],
    );

    final missigno3 = Missigno(
      position: Vector2(1300, 690),
      movementPoints: [
        Vector2(1299, 640),
        Vector2(1400, 640),
        Vector2(1399, 690),
      ],
    );

    add(missigno1);
    add(missigno2);
    add(missigno3);
  }
  void mostrarDialogo(String text) {
    dialogoTexto = text;
    overlays.add('DialogOverlay');
  }

  void cerrarDialogo() {
    dialogoTexto = null;
    overlays.remove('DialogOverlay');
  }

  void showGameOverScreen() {
    pauseEngine();
    overlays.add('GameOverOverlay');
  }

  void hideGameOverScreen() {
    overlays.remove('GameOverOverlay'); //elimina el overlay
    resumeEngine();
  }

  @override
  void onMount() {
    super.onMount();
    // Escuchar el primer tap para iniciar la música.
    overlays.add('Juega'); // Muestra algo como "Toca para empezar".
  }

  void startGame() {
    FlameAudio.loop('background.mp3', volume: 0.75);
    overlays.remove('Juega'); // Oculta el mensaje inicial.
  }

  void mostrarControles(String texto) {
    dialogoTexto = texto;
    overlays.add('DialogOverlay'); // Muestra el diálogo con la información
  }

  void cerrarControles() {
    overlays.remove('DialogOverlay'); // Oculta el diálogo
  }


  @override
  void onDetach() {
    super.onDetach();

    FlameAudio.bgm.stop();
  }


  void reset() {
    // Elimina todos los componentes del juego
    final components = List.of(children);
    for (final component in components) {
      component.removeFromParent();
    }

    _cubone.iVidas = 3;
    _cubone.iSkulls = 0;
    _cubone.iCoins = 0;
    _cubone.position = Vector2(100, 100);
    _cubone.isOnGround = false;
    _cubone.isAttacking = false;
    _cubone.isDashing = false;

    onLoad();


    resumeEngine();
  }






}