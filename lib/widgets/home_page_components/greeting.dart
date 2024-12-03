import 'package:flutter/material.dart';
// import '../assets/font/Borel-Regular.ttf';


class Greeting extends StatelessWidget {
  final String userName;
  final double height;

  const Greeting({
    Key? key,
    required this.userName,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(169, 15, 159, 0.75),
      height: height,
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          'Ahoj $userName 👋',
          style: TextStyle(
            fontSize: height / 4,
            fontWeight: FontWeight.bold,
            fontFamily: 'Borel',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
