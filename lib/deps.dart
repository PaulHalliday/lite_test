import 'package:lite_ref/lite_ref.dart';
import 'package:lite_test/data.dart';

final liteRefFakeData = Ref.scoped<FakeDataProvider>((ctx) {
  final model = FakeDataProvider();

  model.startTimer();
  return model;
});

final liteRefLapDist = Ref.scoped<LapDistance>((ctx) => LapDistanceImpl());
final liteRefFakeLapDist =
    Ref.scoped<LapDistance>((ctx) => FakeLapDistanceImpl(liteRefFakeData(ctx)));
