import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';

void handlePulse1() {
  //FlutterBeep.playSysSound(iOSSoundIDs.AudioTonePathAcknowledge);
  FlutterBeep.playSysSound(iOSSoundIDs.TouchTone1);
}

void handlePulse2() {
  FlutterBeep.playSysSound(iOSSoundIDs.TouchTone2);
}

class PolyTimer {
  Timer? myTimer;
  int tCounter = 0;

  void createPolyTimer(
      int bpm, subD1, subD2, Function firePulse1, Function firePulse2,
      [Function? onCreate]) {
    int ticks = subD1 * subD2;
    double x = 60000 / bpm * 4 / ticks;
    int tickDurMil = x.round();

    myTimer = Timer.periodic(Duration(milliseconds: tickDurMil), (timer) {
      if (tCounter == 0) {
        onCreate!();
      }
      if (tCounter % subD2 == 0) {
        firePulse1();
      }
      if (tCounter % subD1 == 0) {
        firePulse2();
      }
      tCounter++;
    });
  }

  void disposePolyTimer() {
    myTimer!.cancel();
    tCounter = 0;
  }
}
