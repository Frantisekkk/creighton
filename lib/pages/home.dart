import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/HomeLogic.dart';
import 'package:flutter_application_1/pages/Profil.dart';
import 'package:flutter_application_1/services/graph_calculation.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_application_1/styles/styles.dart';

class HomePage extends StatelessWidget {
  final String userName;

  HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // Wrap the UI in a ChangeNotifierProvider so HomeLogic is available.
    return ChangeNotifierProvider<HomeLogic>(
      create: (context) => HomeLogic(appState: appState),
      child: Consumer<HomeLogic>(
        builder: (context, homeLogic, _) {
          final dayData = homeLogic.dayData;
          final weeklyStickers = homeLogic.weeklyStickers;

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: Stack(
              children: [
                Column(
                  children: [
                    // GREETING SECTION
                    Flexible(
                      flex: 20,
                      child: Container(
                        color: headerContainerBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 70.0, left: 30, right: 10),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  'Ahoj $userName \u{1F44B}', // 👋
                                  style: greetingTextStyle.copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            greetingFontSizeFactor,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                // Profile icon leading to ProfilePage
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // COLOR DISPLAY CONTAINER
                    Flexible(
                      flex: 40,
                      child: GestureDetector(
                        onTap: () {
                          appState.setPage(2, date: DateTime.now());
                          // mainScreenKey.currentState
                          //     ?.onItemTapped(2, date: DateTime.now());
                        },
                        child: Container(
                          padding: colorDisplayContainerPadding,
                          decoration: colorDisplayContainerDecoration,
                          child: dayData == null
                              ? const Center(child: CircularProgressIndicator())
                              : Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: colorDisplayBoxDecoration,
                                  child: Row(
                                    children: [
                                      // Left half: colored rectangle
                                      Flexible(
                                        flex: 1,
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 3.7 / 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    dayData['stickerColor'] ??
                                                        Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      // Right half: date and label text
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('E dd.MM')
                                                  .format(DateTime.now()),
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Divider(
                                                color: Colors.grey,
                                                thickness: 1),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Popis:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                            Text(
                                              '${dayData['bleeding']}, ${dayData['mucus']}, ${dayData['fertility']}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // WEEKLY STICKERS ROW
                    Flexible(
                      flex: 15,
                      child: Container(
                        margin: homePageStickersMargin,
                        child: weeklyStickers == null
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(7, (index) {
                                  DateTime date = DateTime.now()
                                      .subtract(Duration(days: 6 - index));
                                  final color =
                                      weeklyStickers[index].withOpacity(0.7);

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        appState.setPage(2, date: date);
                                        // mainScreenKey.currentState
                                        //     ?.onItemTapped(2, date: date);
                                      },
                                      child: Container(
                                        margin: stickerMargin,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(19),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.8),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10.0,
                                              offset: Offset(3, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('E').format(date),
                                              style: stickerWeekdayTextStyle,
                                            ),
                                            Text(
                                              DateFormat('dd').format(date),
                                              style: stickerDayTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                      ),
                    ),

                    // CIRCULAR PROGRESS INDICATOR SECTION
                    Flexible(
                      flex: 25,
                      child: Container(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(200, 100),
                              painter: CustomCircularProgress(value: 0.75),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                '${(25 * 0.75).round()}',
                                style: circularProgressTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
