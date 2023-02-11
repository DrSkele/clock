import 'package:flutter/material.dart';

import 'timer_clock/timer_clock.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const MyTimerExamplePage(),
    );
  }
}

class MyTimerExamplePage extends StatefulWidget {
  const MyTimerExamplePage({super.key});

  @override
  State<MyTimerExamplePage> createState() => _MyTimerExamplePageState();
}

class _MyTimerExamplePageState extends State<MyTimerExamplePage> {
  int seconds = 0;

  var controller = TimerClockController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer Clock Example')),
      body: TimerClock(
        controller: controller,
        startOnBuild: true,
        isCountDown: false,
        duration: const Duration(seconds: 10),
        interval: const Duration(milliseconds: 100),
        onTimerEnd: () {
          print('Timer End');
        },
        itemBuilder: (context, time) {
          print('interval');
          return Center(child: Text('$time'));
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.play_arrow),
              onPressed: () {
                controller.start();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.restart_alt),
              onPressed: () {
                controller.reset();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: const Icon(Icons.cancel),
              onPressed: () {
                controller.stop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
