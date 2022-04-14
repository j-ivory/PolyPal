import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polypal/pages/launchScreen.dart';
import 'package:polypal/models/functions.dart';
import 'package:flutter_beep/flutter_beep.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({Key? key}) : super(key: key);

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  //timer/stopwatch
  Stopwatch stopwatch = Stopwatch();
  Stopwatch reactionStopwatch = Stopwatch();
  bool state = false;
  int start = 0;
  int stop = 0;
  int dif = 0;
  Color stateColor = Colors.teal;
  int reaction = 0;
  int time = 0;
  int durMil = 500;
  bool isStarted = false;

  PolyTimer poly = PolyTimer();

  int getTime() {
    return reactionStopwatch.elapsedMilliseconds;
  }

  int compareTime() {
    int cmp = getTime() - time;
    if (cmp > durMil / 2) {
      return cmp - durMil;
    }
    return cmp;
    //return getTime() - time;
  }

  void callbackFunction() {
    setState(() {
      stateColor = Colors.tealAccent;
      time = getTime();
      //handlePulse1();
      FlutterBeep.playSysSound(iOSSoundIDs.TouchTone12);
      //print('$time');
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          stateColor = Colors.teal;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    reactionStopwatch.start();
    super.initState();
  }

  @override
  void dispose() {
    stopwatch.stop();
    stopwatch.reset();
    reactionStopwatch.stop();
    reactionStopwatch.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  //Navigator.pushNamed(context, '/second');
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 2),
                      pageBuilder: (_, __, ___) => const LaunchScreen(),
                    ),
                  );
                  stopwatch.stop();
                  stopwatch.reset();
                  reactionStopwatch.stop();
                  reactionStopwatch.reset();
                  poly.disposePolyTimer();
                  //dispose();
                },
                child: Hero(
                  tag: 'PolyPal',
                  child: RichText(
                    text: const TextSpan(
                      //text: '',
                      //style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Poly',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 45)),
                        TextSpan(
                            text: 'Pal',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 45)),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 100,
                width: 100,
                color: stateColor,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    reaction = compareTime();
                  });
                },
                icon: const Icon(Icons.timeline_rounded),
                label: const Text('Reaction'),
              ),
              Text('$reaction'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: state
                    ? () {
                        stopwatch.stop();
                        stop = stopwatch.elapsedMilliseconds;
                        setState(() {
                          dif = stop - start;
                          state = !state;
                        });
                      }
                    : () {
                        stopwatch.start();
                        start = stopwatch.elapsedMilliseconds;
                        setState(() {
                          state = !state;
                        });
                      },
                icon: const Icon(Icons.join_full_sharp),
                label: const Text('Time Difference'),
              ),
              Text('$dif'),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          if (!isStarted) {
            poly.createPolyTimer(150, 2, 3, handlePulse1, handlePulse2, () {});
            setState(() {
              isStarted = true;
            });
          } else {
            poly.disposePolyTimer();
            setState(() {
              isStarted = false;
            });
          }
        },
        icon: isStarted ? const Icon(Icons.stop) : const Icon(Icons.start),
        label: isStarted ? const Text('Stop') : const Text('Start'),
      ),
    );
  }
}

////TODO:
///-isolate
///-
