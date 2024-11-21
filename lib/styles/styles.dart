import 'package:flutter/material.dart';

const kBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(30)),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10.0,
      offset: Offset(3, 10),
    ),
  ],
);

const kTextStyleTitle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const kTextStyleSubtitle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);
