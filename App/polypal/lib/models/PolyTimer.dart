import 'dart:async';
import 'package:flutter_beep/flutter_beep.dart';

class PolyTimer {
  Timer myTimer = Timer(const Duration(seconds: 0), () {});
  int tCounter = 0;
  Stopwatch reactionSW = Stopwatch();
  int time1 = 0;
  int time2 = 0;
  List<int> reactions1 = [];
  int bpmSet = 0;
  int sd1 = 0;
  int sd2 = 0;

  void createPolyTimer(
      int bpm, subD1, subD2, Function firePulse1, Function firePulse2,
      [Function? onCreate]) {
    bpmSet = bpm;
    sd1 = subD1;
    sd2 = subD2;
    int ticks = subD1 * subD2;
    double x = 60000 / bpm * 4 / ticks;
    int tickDurMil = x.round();
    reactionSW.start();

    myTimer = Timer.periodic(Duration(milliseconds: tickDurMil), (timer) {
      if (tCounter == 0) {
        onCreate!();
      }
      if (tCounter % subD2 == 0) {
        time1 = getTimestamp();
        firePulse1();
      }
      if (tCounter % subD1 == 0) {
        time2 = getTimestamp();
        firePulse2();
      }
      tCounter++;
    });
  }

  void resetTimer(int bpm, int sd1, int sd2, Function fireP1, Function fireP2) {
    disposePolyTimer();
    createPolyTimer(bpmSet, sd1, sd2, fireP1, fireP2);
  }

  void disposePolyTimer() {
    myTimer.cancel();
    tCounter = 0;
    reactionSW.stop();
    reactionSW.reset();
  }

  int getTimestamp() {
    return reactionSW.elapsedMilliseconds;
  }

  int getMil(int bpm, int subdivision) {
    double x = 60000 / bpm * 4 / subdivision;
    return x.round();
  }

  // int compareTime1(int durMil1) {
  //   int cmp = getTimestamp() - time1;
  //   if (cmp > durMil1 / 2) {
  //     reactions1.add(cmp - durMil1);
  //     return cmp - durMil1;
  //   }
  //   return cmp;
  // }

  int compareTime1() {
    if (myTimer.isActive) {
      int cmp = getTimestamp() - time1;
      int mil = getMil(bpmSet, sd1);
      if (cmp > mil / 2) {
        reactions1.add(cmp - mil);
        return cmp - mil;
      }
      reactions1.add(cmp);
      return cmp;
    } else {
      return 0;
    }
  }

  // int compareTime2(int durMil2) {
  //   int cmp = getTimestamp() - time2;
  //   if (cmp > durMil2 / 2) {
  //     return cmp - durMil2;
  //   }
  //   return cmp;
  // }

  int compareTime2() {
    if (myTimer.isActive) {
      int cmp = getTimestamp() - time2;
      int mil = getMil(bpmSet, sd2);
      if (cmp > mil / 2) {
        reactions1.add(cmp - mil);
        return cmp - mil;
      }
      reactions1.add(cmp);
      return cmp;
    } else {
      return 0;
    }
  }
}

void handlePulse1() {
  //FlutterBeep.playSysSound(iOSSoundIDs.AudioTonePathAcknowledge);
  FlutterBeep.playSysSound(iOSSoundIDs.TouchTone1);
}

void handlePulse2() {
  FlutterBeep.playSysSound(iOSSoundIDs.TouchTone2);
}
