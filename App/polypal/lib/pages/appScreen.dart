import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:polypal/pages/launchScreen.dart';

int x = 2;

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with TickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  //ANIMATION start
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }
  //animation end

  //VARIABLES start
  TextEditingController bpmTextField = TextEditingController(text: '120');
  int _currentSubDivSelection1 = 1;
  int _currentSubDivSelection2 = 1;
  Timer _timer =
      Timer(const Duration(seconds: 0), () => print('Timer member declared'));

  bool startButtonEnabled = true;
  bool stopButtonEnabled = false;
  int counter = 0;
  int? ticks;
  //end of variables

  //METHODS start
  void createTimer(int bpm, int subDiv1, int subDiv2) {
    if (!_timer.isActive) {
      //if timer not active create a timer
      ticks = subDiv1 * subDiv2;
      print('$ticks');
      double x = 60000 / bpm * 4 / ticks!;
      int tickDurMilli = x.round();
      print('$tickDurMilli');

      double s = 60000 / bpm * 4;
      int sDur = s.round();
      _controller = AnimationController(
        duration: Duration(milliseconds: sDur),
        vsync: this,
      );
      //int durMilli = noteDurationMilli.round();
      print('Timer Created');
      Timer.periodic(Duration(milliseconds: tickDurMilli), (timer) {
        if (counter == 0) {
          _controller.repeat();
        }
        if (counter % subDiv2 == 0) {
          SystemSound.play(SystemSoundType.click); //play subdiv1
        }
        if (counter % subDiv1 == 0 && counter % subDiv2 != 0) {
          SystemSound.play(SystemSoundType.click); //play subdiv2
        }
        _timer = timer;
        counter++;
      });
    } else {
      print('Timer already active');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
  //end of methods

  //WIDGETS start
  Widget numField() {
    return SizedBox(
      height: 75,
      width: 75,
      child: TextField(
        controller: bpmTextField,
        maxLength: 3,
        decoration: const InputDecoration(
          labelText: "BPM",
          counterText: "",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ], // Only numbers can be entered
      ),
    );
  }

  Widget subdivisionDropdown(int buttonNum) {
    if (buttonNum == 1) {
      return DropdownButton<int>(
        //Don't forget to pass your variable to the current value
        value: _currentSubDivSelection1,
        items: <int>[1, 2, 3, 4, 5, 6, 7].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        //On changed update the variable name and don't forgot the set state!
        onChanged: (newValue) {
          setState(() {
            _currentSubDivSelection1 = newValue!;
          });
        },
      );
    } else {
      return DropdownButton<int>(
        //Don't forget to pass your variable to the current value
        value: _currentSubDivSelection2,
        items: <int>[1, 2, 3, 4, 5, 6, 7].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        //On changed update the variable name and don't forgot the set state!
        onChanged: (newValue) {
          setState(() {
            _currentSubDivSelection2 = newValue!;
          });
        },
      );
    }
  }
  //end of widgets

  //EXPERIMENT/TESTING start

  //end of experimenting/testing

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      subdivisionDropdown(1),
                      const Spacer(),
                      numField(),
                      const Spacer(),
                      subdivisionDropdown(2),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(flex: 2),
                      stopButton(),
                      const Spacer(),
                      startButton(),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: <Widget>[
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                        child: CustomPaint(
                          painter: ShapePainter(),
                          child: Container(),
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )),
    );
  }

  TextButton stopButton() {
    return TextButton.icon(
      onPressed: stopButtonEnabled
          ? () {
              //if buttonenabled == true then pass a function otherwise pass "null"
              SystemSound.play(SystemSoundType.click);
              print('Timer Canceled');
              _timer.cancel();
              setState(() {
                stopButtonEnabled = false;
                startButtonEnabled = true;
                _controller.reset();
                counter = 0;
              });
            }
          : null,
      icon: const Icon(Icons.stop, size: 18),
      label: const Text("Stop"),
    );
  }

  TextButton startButton() {
    return TextButton.icon(
      onPressed: startButtonEnabled
          ? () {
              SystemSound.play(SystemSoundType.click);
              int userBPM = int.parse(bpmTextField.text);
              print('$userBPM BPM');
              createTimer(
                  userBPM, _currentSubDivSelection1, _currentSubDivSelection2);
              setState(() {
                stopButtonEnabled = true;
                startButtonEnabled = false;
                //_controller.repeat();
              });
            }
          : null,
      icon: const Icon(Icons.timer, size: 18),
      label: const Text("Start"),
    );
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 100, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 100), 5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// class SubDivPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.amber
//       ..strokeWidth = 5
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     Offset center = Offset(size.width / 2, size.height / 2);

    

//     canvas.drawLine(center, Offset(size.width, size.height), paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
  
// }

////ToDo: add parameters for bpm in createtimer function
//ToDo: add parameters for subDiv in createtimer function
//ToDo: create a second callback within timer callback that fires at another indicated subDiv/pulse
//ToDo: add parameters for second subDiv in createtimer function

//somehow all these puzzle pieces rearrange around me
//i feel the same as i always did
//what does life expect of me
//take it slow.


//       double noteDurationMilli;
//       switch (subDiv1) {
//         case 1:
//           {
//             noteDurationMilli = 60000 / bpm * 4;
//           }
//           break;
//         case 2:
//           {
//             noteDurationMilli = 60000 / bpm * 2;
//           }
//           break;
//         case 3:
//           {
//             noteDurationMilli = 60000 / bpm * 4 / 3;
//           }
//           break;
//         case 4: //quarter note
//           {
//             noteDurationMilli = 60000 / bpm;
//           }
//           break;
//         case 5:
//           {
//             noteDurationMilli = 60000 / bpm * 4 / 5;
//           }
//           break;
//         case 6:
//           {
//             noteDurationMilli = 60000 / bpm * 4 / 6;
//           }
//           break;
//         case 7:
//           {
//             noteDurationMilli = 60000 / bpm * 4 / 7;
//           }
//           break;
//         default:
//           {
//             noteDurationMilli = 60000 / bpm;
//           }
//       }


////ToDo: icons adjust, album, allout, api, audiotrack_rounded, auto_awesome_rounded, bedtime_rounded, brightness_1,
/////cake, catching_pokemon, child_care, circle, circle_outlined, commit, coronavirus
/////cruelty_free, diamond, directions_car, eco, egg, emoji..., filter_vintage, flare
///front_hand, grade, heart_broken, hexagon, icecream, label_important, light_mode, local...
///pan_tool_alt, panorama, park