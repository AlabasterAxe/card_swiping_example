import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class DraggableCard extends StatefulWidget {
  final int displayNumber;
  final Function onCardSwipedAway;

  DraggableCard({Key key, this.displayNumber, this.onCardSwipedAway})
      : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Offset dragOffset = Offset(0, 0);

  Offset dragStartOffset = Offset(0, 0);

  Offset targetOffset = Offset(0, 0);

  double slideDirection;

  AnimationController cardSwipeAnimationController;

  @override
  void initState() {
    super.initState();

    cardSwipeAnimationController = new AnimationController(vsync: this);
  }

  Offset _getAnimatedOffset() {
    if (cardSwipeAnimationController.isAnimating) {
      if (slideDirection != null) {
        return Offset.fromDirection(
            slideDirection, cardSwipeAnimationController.value);
      } else {
        return Offset.lerp(dragOffset - dragStartOffset, targetOffset,
            cardSwipeAnimationController.value);
      }
    } else {
      return dragOffset - dragStartOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    // log("${cardSwipeAnimationController.value}");

    return Container(
        child: GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          dragOffset = details.globalPosition;
        });
      },
      onPanStart: (DragStartDetails details) {
        dragStartOffset = details.globalPosition;
        dragOffset = details.globalPosition;
        cardSwipeAnimationController.stop();
      },
      onPanEnd: (DragEndDetails details) {
        var sim = FrictionSimulation(
            10, dragOffset.distance, details.velocity.pixelsPerSecond.distance);
        if (sim.finalX.abs() > screenSize.height / 2) {
          slideDirection = details.velocity.pixelsPerSecond.direction;
          setState(() {
            cardSwipeAnimationController =
                AnimationController.unbounded(vsync: this);
            cardSwipeAnimationController.animateWith(sim);
            cardSwipeAnimationController.addListener(() {
              if (cardSwipeAnimationController.value.abs() >
                  sim.finalX.abs() - 1) {
                cardSwipeAnimationController.stop(canceled: false);
                targetOffset = Offset(0, 0);
                widget.onCardSwipedAway();
              }
            });
          });
        } else {
          slideDirection = null;
          const spring = SpringDescription(
            mass: 30,
            stiffness: 1,
            damping: 1,
          );

          final simulation = SpringSimulation(spring, 0, 1,
              -details.velocity.pixelsPerSecond.distance / screenWidth);

          setState(() {
            cardSwipeAnimationController = AnimationController(vsync: this);

            cardSwipeAnimationController.addListener(() {
              if (cardSwipeAnimationController.value > .99) {
                setState(() {
                  dragOffset = Offset(0, 0);
                  dragStartOffset = Offset(0, 0);
                });
              }
            });

            cardSwipeAnimationController.animateWith(simulation);
          });
        }
      },
      child: AnimatedBuilder(
          animation: cardSwipeAnimationController,
          builder: (context, snapshot) {
            Offset translateOffset = _getAnimatedOffset();

            return Transform.translate(
                offset: translateOffset,
                child: Card(
                    child: Center(
                        child: Text("${widget.displayNumber}",
                            style: TextStyle(fontSize: 40)))));
          }),
    ));
  }
}
