import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class DraggableCard extends StatefulWidget {
  final int displayNumber;

  DraggableCard({Key key, this.displayNumber}) : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Offset dragOffset = Offset(0, 0);

  Offset dragStartOffset = Offset(0, 0);

  Offset targetOffset = Offset(0, 0);

  AnimationController cardSwipeAnimationController;

  @override
  void initState() {
    super.initState();

    cardSwipeAnimationController = new AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    log("${cardSwipeAnimationController.value}");

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
        Offset relativeDragOffset = dragOffset - dragStartOffset;
        if (relativeDragOffset.dy > screenSize.height / 3 &&
            details.velocity.pixelsPerSecond.dy > 80) {
          var sim = FrictionSimulation(
              10, 0, details.velocity.pixelsPerSecond.dy / 80);
          targetOffset = Offset(0, screenSize.height);
          setState(() {
            cardSwipeAnimationController = AnimationController(vsync: this);
            cardSwipeAnimationController.animateWith(sim);
            cardSwipeAnimationController.addListener(() {
              if (cardSwipeAnimationController.value > .9) {
                cardSwipeAnimationController.stop(canceled: false);
                targetOffset = Offset(0, 0);
                // finishCurrentCardAndShowNext(true);
              }
            });
          });
        } else if (relativeDragOffset.dx > screenWidth / 4 &&
            relativeDragOffset.dx + details.velocity.pixelsPerSecond.dx >
                screenWidth / 2 &&
            details.velocity.pixelsPerSecond.dx > 80) {
          var sim = FrictionSimulation(
              10, 0, details.velocity.pixelsPerSecond.dx / 80);
          targetOffset = Offset(screenWidth, 0);
          setState(() {
            cardSwipeAnimationController = AnimationController(vsync: this);
            cardSwipeAnimationController.animateWith(sim);
            cardSwipeAnimationController.addListener(() {
              if (cardSwipeAnimationController.value > .9) {
                cardSwipeAnimationController.stop(canceled: false);
                targetOffset = Offset(0, 0);
                // finishCurrentCardAndShowNext(false);
              }
            });
          });
        } else if (relativeDragOffset.dx < -screenWidth / 4 &&
            relativeDragOffset.dx + details.velocity.pixelsPerSecond.dx <
                -screenWidth / 2 &&
            details.velocity.pixelsPerSecond.dx < -80) {
          var sim = FrictionSimulation(
              10, 0, -(details.velocity.pixelsPerSecond.dx / 80));
          targetOffset = Offset(-screenWidth, 0);
          setState(() {
            cardSwipeAnimationController = AnimationController(vsync: this);
            cardSwipeAnimationController.animateWith(sim);
            cardSwipeAnimationController.addListener(() {
              if (cardSwipeAnimationController.value > .9) {
                cardSwipeAnimationController.stop(canceled: false);
                targetOffset = Offset(0, 0);
                // finishCurrentCardAndShowNext(false);
              }
            });
          });
        } else {
          const spring = SpringDescription(
            mass: 30,
            stiffness: 1,
            damping: 1,
          );

          final simulation = SpringSimulation(
              spring, 0, 1, -details.primaryVelocity / screenWidth);

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
            return Transform.translate(
                offset: cardSwipeAnimationController.isAnimating
                    ? Offset.lerp(dragOffset - dragStartOffset, targetOffset,
                        cardSwipeAnimationController.value)
                    : dragOffset - dragStartOffset,
                child: Card(
                    child: Center(
                        child: Text("${widget.displayNumber}",
                            style: TextStyle(fontSize: 40)))));
          }),
    ));
  }
}
