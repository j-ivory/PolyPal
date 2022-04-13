import 'package:flutter_beep/flutter_beep.dart';

void handlePulse1() {
  FlutterBeep.playSysSound(iOSSoundIDs.AudioTonePathAcknowledge);
}

void handlePulse2() {
  FlutterBeep.playSysSound(iOSSoundIDs.TouchTone2);
}
