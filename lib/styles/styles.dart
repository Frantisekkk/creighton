// lib/styles/styles.dart
import 'package:flutter/material.dart';

// Colors
const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
const Color textColorDark = Colors.black;
const Color headerContainerBackgroundColor = Color.fromRGBO(169, 15, 159, 0.75);
const Color buttbackroundColor = Color.fromARGB(255, 154, 135, 157);
const Color buttonTextColor = Colors.white;
const Color buttBackgroundColor = Color.fromARGB(255, 154, 135, 157);
const Color activeButtonColor = Colors.green; // Active toggle color

const TextStyle headerTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  fontFamily: 'Borel',
  color: textColorDark,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: buttonTextColor,
);

// Define common styles for toggle buttons
final ButtonStyle toggleButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: buttBackgroundColor,
  foregroundColor: buttonTextColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
  elevation: 5,
);

const TextStyle dialogTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: textColorDark,
);

const TextStyle temperatureTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: textColorDark,
);

const TextStyle buttonSectionTitleTextStyle = TextStyle(
  color: buttonTextColor,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);
