import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

const DURATION_SECS = 4;
const CHART_MAX = 200;

class _SpringSimulationChartPainter extends CustomPainter {
  final SpringSimulation simulation;
  final Duration elapsedTime;
  final bool isSpringing;

  _SpringSimulationChartPainter(
      {this.simulation, this.elapsedTime, this.isSpringing});

  @override
  void paint(Canvas canvas, Size size) {
    Paint white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Paint red = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), white);

    canvas.drawLine(Offset(0, 0), Offset(0, size.height), black);
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), black);

    Path springLine = Path()
      ..moveTo(0, size.height - (simulation.x(0) / CHART_MAX) * size.height);

    double pixelTimeStep = DURATION_SECS / size.width;
    double simulatedElapsedTime = pixelTimeStep;
    for (int i = 1; i < size.width.round(); i++) {
      springLine.lineTo(
          i.toDouble(),
          size.height -
              (simulation.x(simulatedElapsedTime) / CHART_MAX) * size.height);
      simulatedElapsedTime += pixelTimeStep;
    }

    canvas.drawPath(springLine, black);
    if (isSpringing && elapsedTime.inMilliseconds / 1000 < DURATION_SECS) {
      double elapsedTimePixel =
          elapsedTime.inMilliseconds / 1000 / DURATION_SECS * size.width;
      canvas.drawLine(Offset(elapsedTimePixel, 0),
          Offset(elapsedTimePixel, size.height), red);
    }
  }

  @override
  bool shouldRepaint(_SpringSimulationChartPainter oldDelegate) {
    return elapsedTime != oldDelegate.elapsedTime &&
            (oldDelegate.elapsedTime.inMilliseconds / 1000 < DURATION_SECS ||
                elapsedTime.inMilliseconds / 1000 < DURATION_SECS) ||
        simulation != oldDelegate.simulation;
  }
}

class SpringSimulationChart extends StatelessWidget {
  final SpringSimulation simulation;
  final Duration elapsedTime;
  final bool isSpringing;
  const SpringSimulationChart(
      {Key key, this.simulation, this.elapsedTime, this.isSpringing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _SpringSimulationChartPainter(
            simulation: simulation,
            elapsedTime: elapsedTime,
            isSpringing: isSpringing));
  }
}
