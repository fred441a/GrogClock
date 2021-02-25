import 'dart:async';

import 'package:flutter/material.dart';

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  var millisecs = (milliseconds % 60).toString().padLeft(2, '0');

  return "$minutes:$seconds:$millisecs";
}

class StopwatchPage extends StatefulWidget {
  Stopwatch _stopwatch;
  List<String> _laps = ["Laps:"];
  Timer _timer;
  String _timeStr = "00:00:00";

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      stop();
    } else {
      start();
    }
  }

  void start() {
    _stopwatch.start();
  }

  void stop() {
    _stopwatch.stop();
    if (_laps.last != "Laps:") {
      _timeStr = _laps.last;
    }
  }

  void reset(){
    _stopwatch.reset();
    _laps = ["Laps:"];
    _timeStr = "00:00:00";
  }

  String lap() {
    _laps.add(formatTime(_stopwatch.elapsedMilliseconds));
    return formatTime(_stopwatch.elapsedMilliseconds);
  }

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  @override
  void initState() {
    super.initState();
    widget._stopwatch = Stopwatch();
    widget._timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {
        if (widget._stopwatch.isRunning) {
          widget._timeStr = formatTime(widget._stopwatch.elapsedMilliseconds);
        }
      });
    });
  }

  @override
  void dispose() {
    widget._timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget._timeStr),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget._laps.length,
            itemBuilder: (BuildContext context, int i) {
              return Text(widget._laps[i]);
            },
          ),
        ),
      ],
    );
  }
}
