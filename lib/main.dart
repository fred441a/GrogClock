import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'BeerTrigger.dart';
import 'Timer.dart';

//globals
beerSmash beerListnerClass;

void main() {
  runApp(MyApp());
  beerListnerClass = new beerSmash();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrogClock',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: MyHomePage(title: 'Grogclock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = -1;
  bool flipflop = true;

  var streamSubscription;

  Widget Counter() {
    if (_counter == -1) {
      return Text("Tap Your drink on the table to start your timer.");
    } else {
      return Text("$_counter");
    }
  }

  StopwatchPage stopWatch = new StopwatchPage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [Text("Drinks drunk:"), Counter(), stopWatch],
          ),
        ),
        floatingActionButton: StartStopButton(
          onPressed: () {
            if (flipflop) {
              setState(() {
                stopWatch.reset();
                _counter = -1;
              });
              streamSubscription =
                  beerListnerClass.tableTrigger.stream.listen((event) {
                if (event) {
                  setState(() {
                    if (_counter == -1) {
                      stopWatch.start();
                    } else {
                      stopWatch.lap();
                    }
                    _counter++;
                  });
                }
              });
              flipflop = false;
            } else {
              stopWatch.stop();
              streamSubscription.cancel();
              flipflop = true;
            }
          },
        ));
  }
}

class StartStopButton extends StatefulWidget {
  StartStopButton({
    Key,
    key,
    this.onPressed,
  }) : super(key: key);

  VoidCallback onPressed;

  @override
  _StartStopButtonState createState() => _StartStopButtonState();
}

class _StartStopButtonState extends State<StartStopButton> {
  bool fabIcon = true;
  Widget fab = Icon(Icons.play_arrow);

  void fabIconSwitcher() {
    setState(() {
      if (fabIcon) {
        fab = Icon(
          Icons.stop,
        );
        fabIcon = false;
      } else {
        fab = Icon(Icons.play_arrow);
        fabIcon = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        fabIconSwitcher();
        widget.onPressed();
      },
      child: fab,
    );
  }
}
