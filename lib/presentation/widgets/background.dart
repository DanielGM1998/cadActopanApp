import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
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
              top: -40,
              right: 0,
              child: Image.asset("assets/images/top1.png",
                  width: orientation == Orientation.portrait
                      ? size.width
                      : size.height * 1.05),
            ),
            Positioned(
              top: -72,
              right: 0,
              child: Image.asset("assets/images/top2.png",
                  width: orientation == Orientation.portrait
                      ? size.width
                      : size.height * 1.03),
            ),
            Positioned(
              top: 110,
              right: 0,
              child: Image.asset("assets/images/logo.png",
                  width: orientation == Orientation.portrait
                      ? size.width * 1.0
                      : size.width * 0.15),
            ),
            Positioned(
              bottom: orientation == Orientation.portrait ? 0 : -90,
              left: 0,
              child: Image.asset("assets/images/bottom1.png",
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
