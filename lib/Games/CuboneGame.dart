import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Characters/Cubone.dart';
import '../Characters/Coin.dart';
import '../Colisiones/RectangularColision.dart';

class CuboneGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{

  late Cubone _cubone;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    // TODO: implement onLoad
    debugMode = true;
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
      'middle.png'

    ]);
    add(await bgParallax());

    TiledComponent mapa1 = await TiledComponent.load("mapa1.tmx", Vector2(128, 128));
    mapa1.scale = Vector2(0.25, 0.25);
    mapa1.position = Vector2(0, -275); // Ajusta el valor de Y para subir el mapa
    add(mapa1);



    add(mapa1);

    _cubone = Cubone(position: Vector2(100, 650));



    add(_cubone);


    final colisiones_rectangulos = mapa1.tileMap.getLayer<ObjectGroup>('colisiones_rectangulos');
    for (final rectColision in colisiones_rectangulos!.objects) {
      add(RectangularColision(
        position: Vector2(rectColision.x, rectColision.y)+ mapa1.position,
        size: Vector2(rectColision.width, rectColision.height),
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

}