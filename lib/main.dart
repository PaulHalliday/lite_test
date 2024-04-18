import 'package:flutter/material.dart';
import 'package:lite_ref/lite_ref.dart';
import 'package:lite_test/deps.dart';
import 'package:signals/signals_flutter.dart';

void main() {
  runApp(const LiteRefScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SignalsObserver.instance = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MinimalLiteRef(),
    );
  }
}

class MinimalLiteRef extends StatefulWidget {
  const MinimalLiteRef({super.key});

  @override
  State<MinimalLiteRef> createState() => _MinimalLiteRefState();
}

class _MinimalLiteRefState extends State<MinimalLiteRef> {
  bool live = false;

  void toggleLive() {
    setState(() {
      live = !live;
    });
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        /// UniqueKey is used to force rebuild on save
        key: UniqueKey(),
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Live Data'),
                value: live,
                onChanged: (v) => toggleLive(),
              ),
              live
                  ? const LapDist()
                  : LiteRefScope(
                      overrides: {
                        liteRefLapDist
                            .overrideWith((ctx) => liteRefFakeLapDist(ctx))
                      },
                      child: const LapDist(),
                    ),
              ElevatedButton(onPressed: rebuild, child: const Text('Rebuild')),
            ],
          ),
        ),
      ),
    );
  }
}

class LapDist extends StatelessWidget {
  const LapDist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => CustomPaint(
        painter: DriverPainter(
          drivers: liteRefLapDist(context).drivers.value,
        ),
        size: const Size(400, 100),
      ),
    );
  }
}

class DriverPainter extends CustomPainter {
  final List<double> drivers;

  DriverPainter({required this.drivers});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < drivers.length; i++) {
      final driver = drivers[i];
      var dx = size.width * driver;
      final dy = size.height / 2;

      final paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
