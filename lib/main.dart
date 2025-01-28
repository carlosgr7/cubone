import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
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
              game.reset();

            },
          );
        },
        // Overlay inicial para pedir interacción
        'Juega': (BuildContext context, CuboneGame game) {
          return GestureDetector(
            onTap: () {
              game.startGame(); // Llama al método para iniciar el juego y la música
            },
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: Text(
                  'Toca para comenzar',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          );
        },
      },
      initialActiveOverlays: const ['Juega'], // Muestra el overlay inicial
    ),
  );
}
