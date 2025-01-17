import 'package:cubone/Games/CuboneGame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(
    const GameWidget<CuboneGame>.controlled(
      gameFactory: CuboneGame.new,
    ),
  );
}