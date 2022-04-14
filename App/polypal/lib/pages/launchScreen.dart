import 'package:flutter/material.dart';
import 'package:polypal/pages/pages.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:polypal/models/global.dart';

Sounds SFXPlayer = Sounds();

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    SFXPlayer.cacheSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Splash Screen'),
      //   backgroundColor: Colors.black,
      // ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, //Alignment.topRight,
              end: Alignment.bottomCenter, //Alignment.bottomLeft,
              stops: [
                0.4, 0.8,
                // 0.1,
                // 0.4,
                // 0.6,
                // 0.9,
              ],
              colors: [
                Colors.white,
                // Colors.red,
                // Colors.indigo,
                Colors.tealAccent,
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const Spacer(flex: 8),
                TextButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/second');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 2),
                        pageBuilder: (_, __, ___) => const AppScreen(),
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
                const Spacer(flex: 2),
                OutlinedButton(
                  onPressed: () {
                    SFXPlayer.playLaunchSFX();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 2),
                        pageBuilder: (_, __, ___) => const AppScreen(),
                      ),
                    );
                  },
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        'Polynome',
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: //Color.fromARGB(255, 255, 191,0),
                              Color.fromARGB(255, 76, 108, 119),
                        ),
                      ),
                      //WavyAnimatedText('Second Text'),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {
                      SFXPlayer.playLaunchSFX();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 2),
                          pageBuilder: (_, __, ___) => const AppScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                trainButton(context),
                const Spacer(flex: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget trainButton(context) {
  return OutlinedButton(
      onPressed: () {
        SFXPlayer.playLaunchSFX();
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 2),
            pageBuilder: (_, __, ___) => const TrainScreen(),
          ),
        );
      },
      child: const Text('Train',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: //Color.fromARGB(255, 255, 191,0),
                Color.fromARGB(255, 76, 108, 119),
          )) //AnimatedTextKit(
      //   animatedTexts: [
      //     WavyAnimatedText(
      //       'Train',
      //       textStyle: const TextStyle(
      //         fontSize: 30,
      //         fontWeight: FontWeight.w600,
      //         color: //Color.fromARGB(255, 255, 191,0),
      //             Color.fromARGB(255, 76, 108, 119),
      //       ),
      //     ),
      //     //WavyAnimatedText('Second Text'),
      //   ],
      //   isRepeatingAnimation: true,
      //   onTap: () {
      //     SFXPlayer.playLaunchSFX();
      //     Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //         transitionDuration: const Duration(seconds: 2),
      //         pageBuilder: (_, __, ___) => const TrainScreen(),
      //       ),
      //     );
      //   },
      // ),
      );
}
