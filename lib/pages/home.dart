import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/HomeLogic.dart';
import 'package:flutter_application_1/pages/Profil.dart';
import 'package:flutter_application_1/services/graph_calculation.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final String userName = appState.userProfile?['first_name'] ?? 'Používateľ';
    final localizations = AppLocalizations.of(context)!;
    // Provide HomeLogic to descendants.
    return ChangeNotifierProvider<HomeLogic>(
      create: (context) => HomeLogic(appState: appState),
      child: Consumer<HomeLogic>(
        builder: (context, homeLogic, _) {
          final weeklyStickers = homeLogic.weeklyStickers;

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: Stack(
              children: [
                Column(
                  children: [
                    // Greeting Section
                    Flexible(
                      flex: 20,
                      child: Container(
                        color: headerContainerBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 70.0, left: 30, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    // Using the localized greeting with the user name as parameter
                                    localizations.greeting(userName),
                                    style: greetingTextStyle.copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              greetingFontSizeFactor,
                                    ),
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final dynamicFontSize =
                                      MediaQuery.of(context).size.width *
                                          greetingFontSizeFactor;
                                  return IconButton(
                                    icon: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: dynamicFontSize * 1.2,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Color Display Container
                    Flexible(
                      flex: 40,
                      child: GestureDetector(
                        onTap: () {
                          appState.setPage(2, date: DateTime.now());
                        },
                        child: Container(
                          padding: colorDisplayContainerPadding,
                          decoration: colorDisplayContainerDecoration,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: colorDisplayBoxDecoration,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: AspectRatio(
                                      aspectRatio: 3.7 / 5,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: homeLogic.dayData?[
                                                        'stickerColor'] ??
                                                    Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.4),
                                              ),
                                            ),
                                          ),
                                          if (homeLogic.dayData?['baby'] ??
                                              false)
                                            Positioned.fill(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(20.0),
                                                child: Image.asset(
                                                  'assets/images/baby_transparent.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
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
                                          color: Colors.grey, thickness: 1),
                                      const SizedBox(height: 10),
                                      Text(
                                        localizations.description_label,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        '${homeLogic.dayData?['bleeding'] ?? localizations.no_data}, '
                                        '${homeLogic.dayData?['mucus'] ?? localizations.no_data}, '
                                        '${homeLogic.dayData?['fertility'] ?? localizations.no_data}',
                                        style: const TextStyle(
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
                    // Weekly Stickers Row
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
                    // Circular Progress Indicator Section remains unchanged.
                    Flexible(
                      flex: 25,
                      child: Container(
                        alignment: Alignment.center,
                        child: Builder(
                          builder: (context) {
                            final int currentDay =
                                homeLogic.dayData?['day_order'] ?? 0;
                            final int displayTotal =
                                currentDay <= 28 ? 28 : currentDay + 5;
                            final double progressValue =
                                currentDay / displayTotal;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(200, 100),
                                  painter: CustomCircularProgress(
                                      value: progressValue),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Text(
                                    '$currentDay',
                                    style: circularProgressTextStyle,
                                  ),
                                ),
                              ],
                            );
                          },
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
