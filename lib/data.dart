import 'dart:async';

import 'package:lite_ref/lite_ref.dart';
import 'package:signals/signals_flutter.dart';

abstract class LapDistance extends Disposable {
  late final ListSignal<double> drivers;
}

class LapDistanceImpl extends LapDistance {
  late final _drivers = listSignal<double>([0.1, 0.5]);

  @override
  ListSignal<double> get drivers => _drivers;

  @override
  void dispose() {
    _drivers.dispose();
  }
}

class FakeLapDistanceImpl extends LapDistance {
  FakeDataProvider data;

  FakeLapDistanceImpl(this.data);

  @override
  ListSignal<double> get drivers => data.lapDist;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

class FakeDataProvider extends Disposable {
  Timer? timer;

  final lapDist = listSignal<double>([0.1, 0.3, 0.5, 0.8]);

  FakeDataProvider();

  void startTimer() {
    const double speed = 0.001;
    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      lapDist.value = lapDist.value.map((driver) {
        final newLapDistPct = driver + speed;
        return newLapDistPct > 1.00 ? 0.0 : newLapDistPct;
      }).toList();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;

    lapDist.dispose();

    print('Disposed FakeDataProvider');
  }
}
