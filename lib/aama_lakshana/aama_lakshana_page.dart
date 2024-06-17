import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:vamana_app/login/login_page.dart';

class AamaLakshanaPage extends StatefulWidget {
  const AamaLakshanaPage({super.key});

  @override
  State<AamaLakshanaPage> createState() => _AamaLakshanaPageState();
}

enum Days { day1, day2, day3, day4, day5, day6, day7 }

class _AamaLakshanaPageState extends State<AamaLakshanaPage> {
  Map<String, bool?> aamaLakshanData = {
    "Aruchi-Do you experience lack of desire towards food": null,
    "Apakti- Do you experience symptoms like indigestion or abdominal distension?":
        null,
    "Nishtheeva-Do you have urge for repetitive spitting/ excessive salivation?":
        null,
    "Anila mudata- Do you have any bothersome feeling of improper  passing of Flatus / stool?":
        null,
    "Mala sanga- Do you experience decreased sweating ? micturition or incomplete evacuation ? (already covered in srotodhalakshan part)":
        null,
    "Gaurav- Do you ever experience umusual feeling of heaviness in the body?":
        null
  };

  Days selectedDay = Days.day1;
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
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Aama Lakshana Assessment",
                        style: TextStyle(
                            color: Color(0xff15400D),
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                    ),
                  ),
                  Container(
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
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Deepana Pachana Yog",
                              style: TextStyle(
                                  color: Color(0xff15400d),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25),
                            ),
                          ),
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
                                  value: Days.day1,
                                  label: Text('Day 1'),
                                ),
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
                          height: screenHeight * 0.57,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                              color: const Color(0xffb5c99a),
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: aamaLakshanData.keys.map((lakshan) {
                                return ComplaintsRow(
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    label: lakshan,
                                    isSelected: aamaLakshanData[lakshan],
                                    onCheckPressed: () {
                                      setState(() {
                                        aamaLakshanData[lakshan] = true;
                                      });
                                    },
                                    onCrossPressed: () {
                                      setState(() {
                                        aamaLakshanData[lakshan] = false;
                                      });
                                    });
                              }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xff0f6f03))),
                                  onPressed: () {
                                    aamaLakshanData.forEach((key, value) {
                                      print('${key}: ${value.toString()}');
                                    });
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
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )),
                              const Spacer(),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xff0f6f03))),
                                  onPressed: () {},
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  )
                ])
          ],
        ));
  }
}

class ComplaintsRow extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String label;
  bool? isSelected;
  VoidCallback onCheckPressed;
  VoidCallback onCrossPressed;

  ComplaintsRow({
    required this.screenWidth,
    required this.screenHeight,
    required this.label,
    required this.isSelected,
    required this.onCheckPressed,
    required this.onCrossPressed,
  });

  @override
  State<ComplaintsRow> createState() => _ComplaintsRowState();
}

class _ComplaintsRowState extends State<ComplaintsRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Row(
        children: [
          Container(
            width: widget.screenWidth * 0.6,
            height: widget.screenHeight * 0.05,
            decoration: const BoxDecoration(
              color: Color(0xff97a97c),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: widget.screenWidth * 0.1475,
            height: widget.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: widget.isSelected == true
                  ? Colors.green.withOpacity(0.5)
                  : const Color(0xffe9f5db),
              border: const Border(
                right: BorderSide(color: Color(0xff15400d)),
                left: BorderSide(color: Color(0xff15400d)),
              ),
            ),
            child: IconButton(
              onPressed: widget.onCheckPressed,
              icon: const Icon(Icons.check_rounded),
            ),
          ),
          Container(
            width: widget.screenWidth * 0.1475,
            height: widget.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: widget.isSelected == false
                  ? Colors.red.withOpacity(0.5)
                  : const Color(0xffe9f5db),
            ),
            child: IconButton(
              onPressed: widget.onCrossPressed,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
