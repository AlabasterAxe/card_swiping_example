import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SlidingBlockExample extends StatefulWidget {
  SlidingBlockExample({Key key}) : super(key: key);

  @override
  _SlidingBlockExampleState createState() => _SlidingBlockExampleState();
}

class _SlidingBlockExampleState extends State<SlidingBlockExample>
    with TickerProviderStateMixin {
  AnimationController blockSlideAnimationController;

  @override
  void initState() {
    super.initState();
    blockSlideAnimationController = AnimationController.unbounded(vsync: this);
  }

  void _nudgeBlock() {
    Simulation sim = FrictionSimulation(.7, 10, 10);
    blockSlideAnimationController.animateWith(sim);
  }

  void _reset() {
    Simulation sim = FrictionSimulation(0, 0, 0);
    blockSlideAnimationController.animateWith(sim);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenSize.height / 3,
          child: Container(color: Colors.blue),
        ),
        AnimatedBuilder(
            animation: blockSlideAnimationController,
            builder: (context, snapshot) {
              return Positioned(
                bottom: screenSize.height / 3,
                left: screenSize.width / 4 -
                    25 +
                    blockSlideAnimationController.value,
                width: 50,
                height: 50,
                child: Container(color: Colors.red),
              );
            }),
        Positioned(
            bottom: screenSize.height / 6,
            child: Row(
              children: [
                RaisedButton(
                  child: Text("NUDGE"),
                  onPressed: _nudgeBlock,
                ),
                SizedBox(width: 20),
                RaisedButton(
                  child: Text("RESET"),
                  onPressed: _reset,
                )
              ],
            ))
      ],
    );
  }
}
