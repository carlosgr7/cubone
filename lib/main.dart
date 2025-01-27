import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Overlays/DialogoOverlay.dart';
import 'Overlays/GameOverOverlay.dart';

void main() {
  runApp(
    GameWidget<CuboneGame>(
      game: CuboneGame(),
      overlayBuilderMap: {
        'DialogOverlay': (BuildContext context, CuboneGame game) {
          return DialogoOverlay(
            text: game.dialogoTexto ?? '',
            onClose: game.cerrarDialogo,
          );
        },
        'GameOverOverlay': (BuildContext context, CuboneGame game) {
          return GameOverOverlay(
            onRestart: () {
              game.hideGameOverScreen(); // Ocultar la pantalla de Game Over
              game.reset(); // Reiniciar el juego
            },
          );
        },
      },
      initialActiveOverlays: const [], // No muestra overlays al inicio
    ),
  );
}
