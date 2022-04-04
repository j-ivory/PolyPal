import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  //VARIABLES start
  TextEditingController bpmTextField = TextEditingController();
  int _currentSubDivSelection1 = 1;
  int _currentSubDivSelection2 = 1;
  Timer _timer =
      Timer(const Duration(seconds: 0), () => print('Timer member declared'));

  bool startButtonEnabled = true;
  bool stopButtonEnabled = false;
  //end of variables

  //METHODS start
  void createTimer() {
    if (!_timer.isActive) {
      //if timer not active create a timer
      print('Timer Created');
      Timer.periodic(const Duration(milliseconds: 2 * 1000), (timer) {
        SystemSound.play(SystemSoundType.click);
        _timer = timer;
      });
    } else {
      print('Timer already active');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
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

  Widget subdivisionDropdown1() {
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
  }

  Widget subdivisionDropdown2() {
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
  //end of widgets

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      subdivisionDropdown1(),
                      const Spacer(),
                      numField(),
                      const Spacer(),
                      //subdivisionDropdown2(),
                      const Spacer(),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: startButtonEnabled
                        ? () {
                            SystemSound.play(SystemSoundType.click);
                            createTimer();
                            setState(() {
                              stopButtonEnabled = true;
                              startButtonEnabled = false;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.timer, size: 18),
                    label: const Text("Start"),
                  ),
                  TextButton.icon(
                    onPressed: stopButtonEnabled
                        ? () {
                            //if buttonenabled == true then pass a function otherwise pass "null"
                            SystemSound.play(SystemSoundType.click);
                            print('cancel timer');
                            _timer.cancel();
                            setState(() {
                              stopButtonEnabled = false;
                              startButtonEnabled = true;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.stop, size: 18),
                    label: const Text("Stop"),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
