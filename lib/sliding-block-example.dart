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
  double drag = 1;
  double position = 1;
  double velocity = 100;

  @override
  void initState() {
    super.initState();

    blockAnimationController = AnimationController.unbounded(vsync: this);
  }

  void _nudgeBlock() {
    FrictionSimulation nonMovingSimulation =
        FrictionSimulation(drag, position, velocity);
    blockAnimationController.animateWith(nonMovingSimulation);
  }

  void _resetBlock() {
    FrictionSimulation nonMovingSimulation = FrictionSimulation(0, 0, 0);
    blockAnimationController.animateWith(nonMovingSimulation);
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
                Slider(
                    min: 0.0,
                    max: 2,
                    value: drag,
                    onChanged: (val) {
                      setState(() {
                        drag = val;
                      });
                    }),
                Slider(
                    min: 0.0,
                    max: 80,
                    value: position,
                    onChanged: (val) {
                      setState(() {
                        position = val;
                      });
                    }),
                Slider(
                    min: 0.0,
                    max: 200,
                    value: velocity,
                    onChanged: (val) {
                      setState(() {
                        velocity = val;
                      });
                    })
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
                  ElevatedButton(child: Text("NUDGE"), onPressed: _nudgeBlock),
                  SizedBox(width: 20),
                  ElevatedButton(child: Text("RESET"), onPressed: _resetBlock),
                ]),
              ],
            ))
      ],
    );
  }
}
