import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";

class SnehpanaPage extends StatefulWidget {
  const SnehpanaPage({super.key});

  @override
  State<SnehpanaPage> createState() => _SnehpanaPageState();
}

enum Days {
  day2(dayNumber: "2"),
  day3(dayNumber: "3"),
  day4(dayNumber: "4"),
  day5(dayNumber: "5"),
  day6(dayNumber: "6"),
  day7(dayNumber: "7");

  final String dayNumber;
  const Days({required this.dayNumber});
}

class _SnehpanaPageState extends State<SnehpanaPage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _doseController = TextEditingController();
  TextEditingController _digestiveHoursController = TextEditingController();
  double? _calculatedDose = 0;

  Days selectedDay = Days.day2;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
                icon: const Icon(Icons.logout_rounded))
          ],
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: screenHeight * 0.19),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: AutoSizeText(
                          "Snehpana Calculator",
                          minFontSize: 20,
                          style: TextStyle(
                              color: Color(0xff15400D),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffcfe1b9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: screenWidth * 0.95,
                        height: screenHeight * 0.75,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.025,
                                  right: screenWidth * 0.025,
                                  top: 8.0,
                                  bottom: 8.0),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.025,
                                    right: screenWidth * 0.025,
                                    bottom: 8.0),
                                child: SegmentedButton<Days>(
                                  style: SegmentedButton.styleFrom(
                                    backgroundColor: const Color(0xffe9f5db),
                                    foregroundColor: const Color(0xff15400d),
                                    selectedForegroundColor: Colors.white,
                                    selectedBackgroundColor:
                                        const Color(0xff718355),
                                  ),
                                  segments: const <ButtonSegment<Days>>[
                                    ButtonSegment<Days>(
                                      value: Days.day2,
                                      label: Text('Day 2'),
                                    ),
                                    ButtonSegment<Days>(
                                      value: Days.day3,
                                      label: Text('Day 3'),
                                    ),
                                    ButtonSegment<Days>(
                                      value: Days.day4,
                                      label: Text('Day 4'),
                                    ),
                                    ButtonSegment<Days>(
                                      value: Days.day5,
                                      label: Text('Day 5'),
                                    ),
                                    ButtonSegment<Days>(
                                      value: Days.day6,
                                      label: Text('Day 6'),
                                    ),
                                    ButtonSegment<Days>(
                                      value: Days.day7,
                                      label: Text('Day 7'),
                                    )
                                  ],
                                  selected: <Days>{selectedDay},
                                  onSelectionChanged: (Set<Days> newSelection) {
                                    setState(() {
                                      selectedDay = newSelection.first;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.5,
                              width: screenWidth * 0.9,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _doseController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter dose in ml',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _digestiveHoursController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter digestive hours',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      double dose =
                                          double.parse(_doseController.text);
                                      double digestiveHours = double.parse(
                                          _digestiveHoursController.text);
                                      setState(() {
                                        _calculatedDose = calculateSnehpanaDose(
                                            selectedDay, dose, digestiveHours);
                                      });
                                    },
                                    child: const Text('Calculate'),
                                  ),
                                  if (_calculatedDose != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Calculated Dose: ${_calculatedDose!.toStringAsFixed(2)} ml'),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xff0f6f03))),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DashBoardPage()));
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Back",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    )
                  ]),
            ),
          ],
        ));
  }
}

double calculateSnehpanaDose(
    Days selectedDay, double dose, double digestiveHours) {
  double dosePerHour = dose / digestiveHours;
  int hoursForNextPeriod = 0;

  switch (selectedDay) {
    case Days.day2:
      hoursForNextPeriod = 6;
      break;
    case Days.day3:
      hoursForNextPeriod = 9;
      break;
    case Days.day4:
      hoursForNextPeriod = 12;
      break;
    case Days.day5:
      hoursForNextPeriod = 15;
      break;
    case Days.day6:
      hoursForNextPeriod = 18;
      break;
    default:
      // Handle default case or error
      break;
  }

  return dosePerHour * hoursForNextPeriod;
}
