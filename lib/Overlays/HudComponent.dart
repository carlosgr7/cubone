import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/text.dart';

class HudComponent extends PositionComponent {
  late TextComponent livesText;
  late TextComponent coinsText;
  late TextComponent skullsText;
  late SpriteComponent livesIcon;
  late SpriteComponent coinsIcon;
  late SpriteComponent skullsIcon;

  int lives = 3;
  int coins = 0;
  int skulls = 0;

  HudComponent();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    livesIcon = SpriteComponent()
      ..sprite = await Sprite.load('heart.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(10, 10);

    livesText = TextComponent(
      text: 'Vidas: $lives',
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'Roboto',
          color: const Color(0xFFFF0000),
          fontSize: 50,
          fontWeight: FontWeight.bold, //
          shadows: [
            Shadow(
              offset: Offset(2, 2), ////sombras
              blurRadius: 4,
              color: const Color(0xFF000000), //sombra negra
            ),
          ],
        ),
      ),
    )..position = Vector2(80, 10);


    coinsIcon = SpriteComponent()
      ..sprite = await Sprite.load('coin.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(10, 90);

    coinsText = TextComponent(
      text: 'Monedas: $coins',
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'Roboto',
          color: const Color(0xFFFF0000),
          fontSize: 50,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: const Color(0xFF000000),
            ),
          ],
        ),
      ),
    )..position = Vector2(80, 90);

    skullsIcon = SpriteComponent()
      ..sprite = await Sprite.load('skull.png')
      ..size = Vector2(65,65)
      ..position = Vector2(1650, 20);

    skullsText = TextComponent(
      text: 'Skulls: $coins',
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'Roboto',
          color: const Color(0xFFFF0000),
          fontSize: 50,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: const Color(0xFF000000),
            ),
          ],
        ),
      ),
    )..position = Vector2(1720, 10);

    add(livesIcon);
    add(livesText);
    add(coinsIcon);
    add(coinsText);
    add(skullsIcon);
    add(skullsText);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void updateLives(int value) {
    lives = value;
    livesText.text = 'Vidas: $lives';
  }

  void updateCoins(int value) {
    coins = value;
    coinsText.text = 'Monedas: $coins';
  }

  void updateSkulls(int value) {
    skulls = value;
    skullsText.text = 'Skulls: $skulls';
  }
}
