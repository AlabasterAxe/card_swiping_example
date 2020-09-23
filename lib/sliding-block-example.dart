import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'spring-simulation-chart.dart';

class SlidingBlockExample extends StatefulWidget {
  SlidingBlockExample({Key key}) : super(key: key);

  @override
  _SlidingBlockExampleState createState() => _SlidingBlockExampleState();
}

class _SlidingBlockExampleState extends State<SlidingBlockExample>
    with TickerProviderStateMixin {
  AnimationController blockAnimationController;
  double mass = 5;
  double stiffness = 5;
  double damping = 0.5;

  SpringSimulation displayedSpringSimulation;
  bool blockIsSpringing = false;
  DateTime springingStartTime;

  @override
  void initState() {
    super.initState();

    blockAnimationController = AnimationController.unbounded(vsync: this);
    _updateSpringSimulation();
  }

  void _nudgeBlock() {
    FrictionSimulation nudgeSimulation = FrictionSimulation(
        .2, blockAnimationController.value, 320,
        tolerance: Tolerance(distance: .1, velocity: .1));
    blockAnimationController.animateWith(nudgeSimulation);
    blockIsSpringing = false;
    print(nudgeSimulation.finalX);
  }

  void _resetBlock() {
    FrictionSimulation nonMovingSimulation = FrictionSimulation(0, 0, 0,
        tolerance: Tolerance(distance: .1, velocity: .1));
    blockAnimationController.animateWith(nonMovingSimulation);
    blockIsSpringing = false;
  }

  void _springBack() {
    SpringDescription spring =
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping);
    SpringSimulation springBackSimulation = SpringSimulation(
        spring, blockAnimationController.value, 0, 0,
        tolerance: Tolerance(distance: .1, velocity: .1));
    blockAnimationController.animateWith(springBackSimulation);
    blockIsSpringing = true;
    springingStartTime = DateTime.now();
  }

  void _updateSpringSimulation() {
    SpringDescription spring =
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping);
    displayedSpringSimulation = SpringSimulation(spring, 199, 0, 0);
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            top: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Mass"),
                    Slider(
                        min: 0.0,
                        max: 10,
                        value: mass,
                        onChanged: (val) {
                          setState(() {
                            mass = val;
                            _updateSpringSimulation();
                          });
                        }),
                    Text(mass.toStringAsFixed(2)),
                  ],
                ),
                Row(
                  children: [
                    Text("Stiffness"),
                    Slider(
                        min: 0.0,
                        max: 80,
                        value: stiffness,
                        onChanged: (val) {
                          setState(() {
                            stiffness = val;
                            _updateSpringSimulation();
                          });
                        }),
                    Text(stiffness.toStringAsFixed(2)),
                  ],
                ),
                Row(
                  children: [
                    Text("Damping"),
                    Slider(
                        min: 0.0,
                        max: 2,
                        value: damping,
                        onChanged: (val) {
                          setState(() {
                            damping = val;
                            _updateSpringSimulation();
                          });
                        }),
                    Text(damping.toStringAsFixed(2)),
                  ],
                ),
                SizedBox(height: 20),
                AnimatedBuilder(
                    animation: blockAnimationController,
                    builder: (context, snapshot) {
                      return Container(
                          width: 200,
                          height: 100,
                          child: SpringSimulationChart(
                            simulation: displayedSpringSimulation,
                            isSpringing: blockIsSpringing,
                            elapsedTime: blockAnimationController.isAnimating
                                ? blockAnimationController.lastElapsedDuration
                                : Duration(),
                          ));
                    }),
              ],
            )),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenSize.height / 3,
            child: Container(color: Colors.blue)),
        AnimatedBuilder(
            animation: blockAnimationController,
            builder: (context, snapshot) {
              return Positioned(
                height: 50,
                width: 50,
                bottom: screenSize.height / 3,
                left:
                    screenSize.width / 4 - 25 + blockAnimationController.value,
                child: Container(color: Colors.red),
              );
            }),
        Positioned(
            bottom: screenSize.height / 6,
            child: Column(
              children: [
                Row(children: [
                  RaisedButton(child: Text("NUDGE"), onPressed: _nudgeBlock),
                  SizedBox(width: 20),
                  RaisedButton(child: Text("RESET"), onPressed: _resetBlock),
                  SizedBox(width: 20),
                  RaisedButton(
                      child: Text("SPRING BACK"), onPressed: _springBack),
                ]),
              ],
            ))
      ],
    );
  }
}
