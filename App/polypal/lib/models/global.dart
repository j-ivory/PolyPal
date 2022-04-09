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
  void playLaunchSFX() {
    launchSFX.play('launch_sound.mp3');
  }

  void cacheSounds() {
    launchSFX.load('launch_sound.mp3');
  }
}
