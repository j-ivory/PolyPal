import 'package:flutter/material.dart';
import 'package:polypal/pages/launchScreen.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({Key? key}) : super(key: key);

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
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
              const Spacer(),
            ]),
      )),
    );
  }
}
