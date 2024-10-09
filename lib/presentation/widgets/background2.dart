import 'package:flutter/material.dart';

class Background2 extends StatelessWidget {
  final Widget child;

  const Background2({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      return SizedBox(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: -75,
              right: 0,
              child: Image.asset("assets/images/top1.png",
                  width: orientation == Orientation.portrait
                      ? size.width
                      : size.height * 1.05),
            ),
            Positioned(
              top: -98,
              right: 0,
              child: Image.asset("assets/images/top2.png",
                  color: Colors.blue[700],
                  width: orientation == Orientation.portrait
                      ? size.width
                      : size.height * 1.03),
            ),
            Positioned(
              bottom: orientation == Orientation.portrait ? -10 : -90,
              left: 0,
              child: Image.asset("assets/images/bottom1.png",
                  color: const Color.fromRGBO(0, 0, 102, 0.4),
                  width: orientation == Orientation.portrait
                      ? size.width
                      : size.height),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset("assets/images/bottom2.png",
                  width: orientation == Orientation.portrait ? size.width : 0),
            ),
            Positioned(
              bottom: -80,
              left: 0,
              child: RotatedBox(
                quarterTurns: 90,
                child: Image.asset("assets/images/top1.png",
                    width: orientation == Orientation.portrait
                        ? 0
                        : size.height * 1.05),
              ),
            ),
            child
          ],
        ),
      );
    });
  }
}
