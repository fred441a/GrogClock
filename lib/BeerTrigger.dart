import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:io';

class beerSmash {
  StreamSubscription<AccelerometerEvent> _accSub;
  StreamController<bool> tableTrigger = StreamController.broadcast();
  List<double> _accVal;
  List<double> _oldAccVal;
  var timeout;
  double _cutoff = 0.3;

  beerSmash() {
    timeout = DateTime.now().millisecondsSinceEpoch;
    _accSub = accelerometerEvents.listen((AccelerometerEvent event) {
      _oldAccVal = _accVal;
      _accVal = <double>[event.x, event.y, event.z];
      List<double> diff = [0, 0, 0];
      double shakeVal = 0;
      for (int i = 0; i < 3; i++) {
        diff[i] = _oldAccVal[i] - _accVal[i];
      }

      for (int i = 0; i < 2; i++) {
        shakeVal += diff[i].abs();
      }

      if (shakeVal > _cutoff) {
        if((DateTime.now().millisecondsSinceEpoch - timeout)>1000){
          tableTrigger.add(true);
          timeout = DateTime.now().millisecondsSinceEpoch;
        }
          
      }
    });
  }

  void dispose() {
    _accSub.cancel();
  }
}
