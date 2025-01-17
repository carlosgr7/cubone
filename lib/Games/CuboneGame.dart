import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';

class CuboneGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    debugMode = false;
    await images.loadAll([
      'cubone.png',
      'back.png',
      'back-tileset.png',
      'middle.png',
      'bg-graveyard.png',
      'bg-moon.png',
      'bg-mountains.png',
      'back-tileset.png',
      'middle.png'

    ]);
    add(await bgParallax());

    TiledComponent mapa1=await TiledComponent.load("mapa1.tmx", Vector2(128, 128));
    mapa1.scale = Vector2(0.5, 0.4);
    add(mapa1);

    return super.onLoad();
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