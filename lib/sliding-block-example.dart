import 'package:card_swiping_example/spring-simulation-chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SlidingBlockExample extends StatefulWidget {
  SlidingBlockExample({Key key}) : super(key: key);

  @override
  _SlidingBlockExampleState createState() => _SlidingBlockExampleState();
}

class _SlidingBlockExampleState extends State<SlidingBlockExample>
    with TickerProviderStateMixin {
  AnimationController blockAnimationController;
  double mass = 5;
  double stiffness = 50;
  double damping = 1;

  SpringSimulation displayedSpringSimulation;
  bool isSpringing = false;

  @override
  void initState() {
    super.initState();

    blockAnimationController = AnimationController.unbounded(vsync: this);

    _recalculateDisplayedSpringSimulation();
  }

  void _nudgeBlock() {
    FrictionSimulation nudgeSimulation = FrictionSimulation(
      0.2,
      0,
      320,
    );
    blockAnimationController.animateWith(nudgeSimulation);
    isSpringing = false;
  }

  void _resetBlock() {
    FrictionSimulation nonMovingSimulation = FrictionSimulation(0, 0, 0);
    blockAnimationController.animateWith(nonMovingSimulation);
    isSpringing = false;
  }

  void _springBack() {
    SpringDescription springDesc =
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping);
    SpringSimulation springSim =
        SpringSimulation(springDesc, blockAnimationController.value, 0, 0);
    blockAnimationController.animateWith(springSim);
    isSpringing = true;
  }

  void _recalculateDisplayedSpringSimulation() {
    SpringDescription desc =
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping);

    setState(() {
      displayedSpringSimulation = SpringSimulation(desc, 200, 0, 0);
    });
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
                            _recalculateDisplayedSpringSimulation();
                          });
                        }),
                    Text("${mass.toStringAsFixed(2)}")
                  ],
                ),
                Row(
                  children: [
                    Text("Stiffness"),
                    Slider(
                        min: 0.0,
                        max: 100,
                        value: stiffness,
                        onChanged: (val) {
                          setState(() {
                            stiffness = val;
                            _recalculateDisplayedSpringSimulation();
                          });
                        }),
                    Text("${stiffness.toStringAsFixed(2)}")
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
                            _recalculateDisplayedSpringSimulation();
                          });
                        }),
                    Text("${damping.toStringAsFixed(2)}")
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  width: 200,
                  child: AnimatedBuilder(
                      animation: blockAnimationController,
                      builder: (context, snapshot) {
                        return SpringSimulationChart(
                          simulation: displayedSpringSimulation,
                          elapsedTime: blockAnimationController.isAnimating
                              ? blockAnimationController.lastElapsedDuration
                              : Duration(),
                          isSpringing: isSpringing,
                        );
                      }),
                ),
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
