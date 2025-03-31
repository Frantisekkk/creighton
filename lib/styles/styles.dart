import 'package:flutter/material.dart';

// Colors
const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
const Color textColorDark = Colors.black;
const Color headerContainerBackgroundColor = Color.fromRGBO(169, 15, 159, 0.75);
// const Color buttbackroundColor = Color.fromARGB(255, 154, 135, 157);
const Color buttonTextColor = Colors.white;
const Color buttBackgroundColor = Color.fromRGBO(241, 165, 173, 1);
const Color activeButtonColor = Color.fromRGBO(172, 81, 128, 1);

const Color buttonTextColor2 = Colors.black26;
const Color buttBackgroundColor2 = Colors.white;
const Color activeButtonColor2 = Color.fromRGBO(172, 81, 128, 1);
// Text Styles
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
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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

// -------------------------------------------------------------------
// Additional HomePage Styles
// -------------------------------------------------------------------

// Greeting Text Style (without font size so we can adjust dynamically)
const TextStyle greetingTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: 'Borel',
  color: Colors.white,
);

// A factor to compute the greeting font size based on screen width.
const double greetingFontSizeFactor = 0.10;

// Padding for the color display container.
const EdgeInsets colorDisplayContainerPadding = EdgeInsets.all(30);

// Decoration for the color display container (outer container).
final BoxDecoration colorDisplayContainerDecoration = BoxDecoration(
  color: headerContainerBackgroundColor,
  borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
  ),
);

// Decoration for the inner white box inside the color display container.
final BoxDecoration colorDisplayBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(30),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10.0,
      offset: Offset(3, 10),
    ),
  ],
);

// Margin for the weekly stickers row container.
const EdgeInsets homePageStickersMargin =
    EdgeInsets.symmetric(horizontal: 30, vertical: 10);

// Margin for each sticker in the weekly stickers row.
const EdgeInsets stickerMargin = EdgeInsets.symmetric(horizontal: 3.0);

// Text style for the weekday inside each sticker.
const TextStyle stickerWeekdayTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.black54,
);

// Text style for the day number inside each sticker.
const TextStyle stickerDayTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black54,
);

// Text style for the overlay inside the circular progress indicator.
const TextStyle circularProgressTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w400,
  fontFamily: 'Arial',
  color: Colors.black87,
);
// -------------------------------------------------------------------
// Table Page Styles
// -------------------------------------------------------------------

// Width for each table cell
const double tableCellWidth = 80.0;

// Decoration for each table cell (used for both header and data cells)
final BoxDecoration tableCellDecoration = BoxDecoration(
  border: Border.all(color: Colors.black, width: 1),
);

// Text style for header cells in the table
const TextStyle tableHeaderTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

// Padding for each row in the table (vertical spacing between cycles)
const EdgeInsets tableRowPadding = EdgeInsets.symmetric(vertical: 20);

// -------------------------------------------------------------------
// Login Page Styles
// -------------------------------------------------------------------

// Page padding and spacing
const EdgeInsets defaultPagePadding = EdgeInsets.all(16.0);
const double defaultVerticalSpacing = 20.0;

// Default text field decoration factory
InputDecoration defaultTextFieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
  );
}

// AppBar background color for Login (you can also add one for Sign Up if needed)
const Color loginAppBarColor = Colors.blueAccent;

// Error text style
const TextStyle errorTextStyle = TextStyle(color: Colors.red);

// Helper function to map color names to Flutter Color objects.
Color getColor(String color) {
  switch (color.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'white':
      return Colors.white;
    default:
      return Colors.grey; // Default to gray for unknown colors
  }
}

// Convert Color object back to string name
String getColorName(Color color) {
  if (color == Colors.red) return 'red';
  if (color == Colors.green) return 'green';
  if (color == Colors.yellow) return 'yellow';
  if (color == Colors.white) return 'white';
  return 'grey'; // Default if unknown color
}
