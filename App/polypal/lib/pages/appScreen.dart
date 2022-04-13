import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polypal/models/functions.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:polypal/pages/launchScreen.dart';
import 'package:polypal/models/global.dart';

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

    SFXPlayer.cacheSounds();
    super.initState();
  }
  //animation end

  //VARIABLES start
  Sounds SFXPlayer = Sounds();
  TextEditingController bpmTextField = TextEditingController(text: '90');
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
          //SystemSound.play(SystemSoundType.click); //play subdiv1
          //SFXPlayer.playClave1SFX();
          //FlutterBeep.beep(false);
          handlePulse1();
        }
        if (counter % subDiv1 == 0) {
          //&& counter % subDiv2 != 0) {
          //SystemSound.play(SystemSoundType.click);
          //SFXPlayer.playClave2SFX(); //play subdiv2
          //FlutterBeep.beep();
          handlePulse2();
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
  bool playing = false;
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
        ],
        onTap: () {
          if (!playing) {
            SystemSound.play(SystemSoundType.click);
          }
        },
        enabled: !playing,
        // Only numbers can be entered
      ),
    );
  }

  Widget subdivisionDropdown(int buttonNum) {
    if (buttonNum == 1) {
      return DropdownButton<int>(
        iconEnabledColor: Colors.amberAccent,
        dropdownColor: Colors.amberAccent,
        //Don't forget to pass your variable to the current value
        value: _currentSubDivSelection1,
        items: <int>[1, 2, 3, 4, 5, 6, 7].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        //On changed update the variable name and don't forgot the set state!
        onChanged: !playing
            ? (newValue) {
                SystemSound.play(SystemSoundType.click);
                setState(() {
                  _currentSubDivSelection1 = newValue!;
                });
              }
            : null,
      );
    } else {
      return DropdownButton<int>(
        iconEnabledColor: Colors.tealAccent,
        dropdownColor: Colors.tealAccent,
        //Don't forget to pass your variable to the current value
        value: _currentSubDivSelection2,
        items: <int>[1, 2, 3, 4, 5, 6, 7].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        //On changed update the variable name and don't forgot the set state!
        onChanged: !playing
            ? (newValue) {
                SystemSound.play(SystemSoundType.click);
                setState(() {
                  _currentSubDivSelection2 = newValue!;
                });
              }
            : null,
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
                      Stack(
                        children: <Widget>[
                          CustomPaint(
                            painter: SubDivPainter1(_currentSubDivSelection1),
                            child: Container(),
                          ),
                          CustomPaint(
                            painter: SubDivPainter2(_currentSubDivSelection2),
                            child: Container(),
                          ),
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 1.0)
                                .animate(_controller),
                            child: CustomPaint(
                              painter: ShapePainter(),
                              child: Container(),
                            ),
                          ),
                        ],
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
                playing = false;
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
                playing = true;
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

class SubDivPainter1 extends CustomPainter {
  int subdivisions;
  SubDivPainter1(this.subdivisions); //constructor

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double xCenter = size.width / 2;
    double yCenter = size.height / 2;
    //Offset center = Offset(xCenter, yCenter);

    //canvas.drawCircle(center, 50, paint);
    //canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 100), 5, paint);

    switch (subdivisions) {
      case 1:
        canvas.drawLine(Offset(xCenter, yCenter - 65),
            Offset(xCenter, yCenter - 95), paint);
        break;
      case 2:
        {
          // for (int i = 1; i <= subdivisions; i++) {

          // }

          canvas.drawLine(Offset(xCenter, yCenter - 65),
              Offset(xCenter, yCenter - 95), paint);
          canvas.drawLine(Offset(xCenter, yCenter + 65),
              Offset(xCenter, yCenter + 95), paint);
        }
        break;
      case 3:
        canvas.drawLine(Offset(xCenter, yCenter - 65),
            Offset(xCenter, yCenter - 95), paint);
        canvas.drawLine(Offset(xCenter - 56.291, yCenter + 32.5),
            Offset(xCenter - 82.272, yCenter + 47.5), paint);
        canvas.drawLine(Offset(xCenter + 56.291, yCenter + 32.5),
            Offset(xCenter + 82.272, yCenter + 47.5), paint);
        break;
      case 4:
        {
          canvas.drawLine(Offset(xCenter, yCenter - 65),
              Offset(xCenter, yCenter - 95), paint);
          canvas.drawLine(Offset(xCenter, yCenter + 65),
              Offset(xCenter, yCenter + 95), paint);
          canvas.drawLine(Offset(xCenter - 65, yCenter),
              Offset(xCenter - 95, yCenter), paint);
          canvas.drawLine(Offset(xCenter + 65, yCenter),
              Offset(xCenter + 95, yCenter), paint);
        }
        break;
      case 5:
        {
          canvas.drawLine(Offset(xCenter, yCenter - 65),
              Offset(xCenter, yCenter - 95), paint);

          double rotation = 360 / subdivisions;
          double R = rotation / 360 * 2 * math.pi; //rotation in degrees
          double x1 = 0;
          double y1 = 95;
          double X1 = x * math.cos(R) + y1 * math.sin(R);
          double Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          double x2 = 0;
          double y2 = 65;
          double X2 = x2 * math.cos(R) + y2 * math.sin(R);
          double Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);

          rotation = rotation * 2;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 95;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 65;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter + -Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);

          //for (int i = 1; i <= subdivisions; i++) {
          int i = 4;
          rotation = rotation * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 95;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 65;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter + -Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
          //}
          i = 5;
          rotation = 288;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 95;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 65;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      case 6:
        canvas.drawLine(Offset(xCenter, yCenter - 65),
            Offset(xCenter, yCenter - 95), paint);
        double rotation = 360 / subdivisions;
        double R, x1, y1, X1, Y1, x2, y2, X2, Y2;
        for (int i = 1; i < 3; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 95;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 65;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        canvas.drawLine(Offset(xCenter, yCenter + 65),
            Offset(xCenter, yCenter + 95), paint);
        for (int i = 4; i < subdivisions; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 95;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 65;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      case 7:
        canvas.drawLine(Offset(xCenter, yCenter - 65),
            Offset(xCenter, yCenter - 95), paint);
        double rotation = 360 / subdivisions;
        double R, x1, y1, X1, Y1, x2, y2, X2, Y2;
        for (int i = 1; i < subdivisions; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 95;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 65;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SubDivPainter2 extends CustomPainter {
  int subdivisions;
  SubDivPainter2(this.subdivisions); //constructor

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double xCenter = size.width / 2;
    double yCenter = size.height / 2;
    //Offset center = Offset(xCenter, yCenter);
    double r = 100;

    //( x - xCenter )^2 + ( y - yCenter )^2 = r^2
    //canvas.drawCircle(center, 50, paint);
    //canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 100), 5, paint);
    switch (subdivisions) {
      case 1:
        canvas.drawLine(Offset(xCenter, yCenter - 135),
            Offset(xCenter, yCenter - 105), paint);
        break;
      case 2:
        {
          canvas.drawLine(Offset(xCenter, yCenter - 135),
              Offset(xCenter, yCenter - 105), paint);
          canvas.drawLine(Offset(xCenter, yCenter + 135),
              Offset(xCenter, yCenter + 105), paint);
        }
        break;
      case 3:
        canvas.drawLine(Offset(xCenter, yCenter - 105),
            Offset(xCenter, yCenter - 135), paint);
        double rotation = 360 / subdivisions;
        double R, x1, y1, X1, Y1, x2, y2, X2, Y2;
        for (int i = 1; i < subdivisions; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 135;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 105;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      case 4:
        {
          canvas.drawLine(Offset(xCenter, yCenter - 135),
              Offset(xCenter, yCenter - 105), paint);
          canvas.drawLine(Offset(xCenter, yCenter + 135),
              Offset(xCenter, yCenter + 105), paint);
          canvas.drawLine(Offset(xCenter - 135, yCenter),
              Offset(xCenter - 105, yCenter), paint);
          canvas.drawLine(Offset(xCenter + 135, yCenter),
              Offset(xCenter + 105, yCenter), paint);
        }
        break;
      case 5:
        canvas.drawLine(Offset(xCenter, yCenter - 105),
            Offset(xCenter, yCenter - 135), paint);
        double rotation = 360 / subdivisions;
        double R, x1, y1, X1, Y1, x2, y2, X2, Y2;
        for (int i = 1; i < subdivisions; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 135;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 105;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      case 6:
        canvas.drawLine(Offset(xCenter, yCenter - 105),
            Offset(xCenter, yCenter - 135), paint);
        double rotation = 360 / subdivisions;
        double R, x1, y1, X1, Y1, x2, y2, X2, Y2;
        for (int i = 1; i < 3; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 135;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 105;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        canvas.drawLine(Offset(xCenter, yCenter + 135),
            Offset(xCenter, yCenter + 105), paint);
        for (int i = 4; i < 6; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 135;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 105;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      case 7:
        canvas.drawLine(Offset(xCenter, yCenter - 105),
            Offset(xCenter, yCenter - 135), paint);
        double rotation = 360 / subdivisions;
        double R, x1, y1, X1, Y1, x2, y2, X2, Y2;
        for (int i = 1; i < subdivisions; i++) {
          rotation = 360 / subdivisions * i;
          R = rotation / 360 * 2 * math.pi;
          x1 = 0;
          y1 = 135;
          X1 = x * math.cos(R) + y1 * math.sin(R);
          Y1 = -x1 * math.sin(R) + y1 * math.cos(R);

          x2 = 0;
          y2 = 105;
          X2 = x2 * math.cos(R) + y2 * math.sin(R);
          Y2 = -x2 * math.sin(R) + y2 * math.cos(R);

          canvas.drawLine(Offset(xCenter + X2, yCenter - Y2),
              Offset(xCenter + X1, yCenter - Y1), paint);
        }
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; //or true? hm does false optimize ?
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