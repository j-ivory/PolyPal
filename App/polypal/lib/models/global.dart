//texts and fonts and colors
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

Color redColor = const Color(0xFFFF7C7C);

TextStyle splashScreenTitle = TextStyle(
    fontFamily: 'Avenir',
    fontWeight: FontWeight.bold,
    color: redColor,
    fontSize: 30);

class Sounds {
  AudioCache launchSFX = AudioCache();
  AudioCache clave1SFX = AudioCache();
  AudioCache clave2SFX = AudioCache();
  AudioCache woodSFX = AudioCache();

  void playLaunchSFX() {
    launchSFX.play('launch_sound.mp3');
  }

  void playClave1SFX() {
    clave1SFX.play('clave1.mp3');
  }

  void playClave2SFX() {
    clave2SFX.play('clave2.mp3');
  }

  void playWoodSFX() {
    clave2SFX.play('wood.mp3');
  }

  void cacheSounds() {
    launchSFX.load('launch_sound.mp3');
    clave1SFX.load('clave1.mp3');
    clave2SFX.load('clave2.mp3');
    woodSFX.load('wood.mp3');
  }
}
