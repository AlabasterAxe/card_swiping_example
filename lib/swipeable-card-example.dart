import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'swipeable-card.dart';

import 'package:google_fonts/google_fonts.dart';

List<CardContents> CARDS = [
  CardContents()
    ..name = "Mr. Oinks"
    ..age = "5w"
    ..imageUrl =
        "https://static.boredpanda.com/blog/wp-content/uuuploads/cute-baby-animals/cute-baby-animals-10.jpg"
    ..fruitDescription = "Way better than Apples",
  CardContents()
    ..name = "Earboy"
    ..age = "1m"
    ..imageUrl =
        "https://wl-brightside.cf.tsp.li/resize/728x/jpg/637/974/b84c0e573e91d52ded84291c09.jpg"
    ..fruitDescription = "Way better than Apples",
  CardContents()
    ..name = "Sneak Bear"
    ..age = "1y"
    ..imageUrl =
        "https://i.pinimg.com/736x/33/32/6d/33326dcddbf15c56d631e374b62338dc.jpg"
    ..fruitDescription = "Way better than Apples",
  CardContents()
    ..name = "Q-Tip"
    ..age = "5m"
    ..imageUrl =
        "https://www.warrenphotographic.co.uk/photography/bigs/11717-Cute-Bichon-Frise-puppy-on-grey-background.jpg"
    ..fruitDescription = "Way better than Apples",
  CardContents()
    ..name = "No Feet"
    ..age = "25y"
    ..imageUrl =
        "https://www.treehugger.com/thmb/TcZhbna7HLnadU56fgnzIqV2GGs=/644x398/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__mnn__images__2014__06__baby-snake-e26c5896b48d4433b42b74228be3a127.jpg"
    ..fruitDescription = "Way better than Apples",
  CardContents()
    ..name = "Bubbles"
    ..age = "2y"
    ..imageUrl =
        "https://www.mypetsname.com/wp-content/uploads/2019/07/Funny-Fish-Face.jpg"
    ..fruitDescription = "Way better than Apples",
];

class SwipeableCardExample extends StatefulWidget {
  SwipeableCardExample({Key key}) : super(key: key);

  @override
  _SwipeableCardExampleState createState() => _SwipeableCardExampleState();
}

class _SwipeableCardExampleState extends State<SwipeableCardExample> {
  List<int> cards = [2, 1];

  @override
  void initState() {
    super.initState();
  }

  Widget _getCardContents(CardContents contents) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.network(contents.imageUrl,
            height: constraints.maxWidth,
            width: constraints.maxWidth,
            fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8.0),
          child: RichText(
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              TextSpan(
                  text: contents.name,
                  style: GoogleFonts.montserrat(
                      fontSize: 30, fontWeight: FontWeight.w500)),
              TextSpan(
                  text: ", ${contents.age}",
                  style: GoogleFonts.montserrat(fontSize: 30))
            ]),
            textAlign: TextAlign.left,
          ),
        ),
      ]);
    });
  }

  Function _prepareFutureCards(int x) {
    return () {
      setState(() {
        if (!cards.contains(x + 1)) {
          cards.insert(0, x + 1);
        }
        if (!cards.contains(x + 2)) {
          cards.insert(0, x + 2);
        }
      });
    };
  }

  Function _removeCard(int x) {
    return () {
      setState(() {
        if (cards.contains(x)) {
          cards.remove(x);
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: cards
              .map((int x) => SwipeableCard(
                    key: Key("$x"),
                    child: _getCardContents(CARDS[x % CARDS.length]),
                    onDragStart: _prepareFutureCards(x),
                    onCardOffscreen: _removeCard(x),
                  ))
              .toList()),
    );
  }
}
