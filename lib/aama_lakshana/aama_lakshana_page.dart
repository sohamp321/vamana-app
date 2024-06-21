import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:vamana_app/components/widgets.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'aama_lakshana_bloc/aama_lakshana_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'aama_lakshana_bloc/aama_lakshana_event.dart';
import 'aama_lakshana_bloc/aama_lakshan_state.dart';

class AamaLakshanaPage extends StatefulWidget {
  const AamaLakshanaPage({super.key});

  @override
  State<AamaLakshanaPage> createState() => _AamaLakshanaPageState();
}

enum Days {
  day1(dayNumber: "1"),
  day2(dayNumber: "2"),
  day3(dayNumber: "3"),
  day4(dayNumber: "4"),
  day5(dayNumber: "5"),
  day6(dayNumber: "6"),
  day7(dayNumber: "7");

  final String dayNumber;
  const Days({required this.dayNumber});
}

class _AamaLakshanaPageState extends State<AamaLakshanaPage> {
  void getAaamaLakshana() async {
    BlocProvider.of<AamaLakshanaBloc>(context)
        .add(GetAamaLakshana(dayNumber: selectedDay.dayNumber));
  }

  @override
  void initState() {
    BlocProvider.of<AamaLakshanaBloc>(context).add(Day0AamaLakshana());
    BlocProvider.of<AamaLakshanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAaamaLakshana();
    super.initState();
  }

  Map<String, dynamic> aamaLakshanData = {
    "aruchi": {
      "label": "Aruchi-Do you experience lack of desire towards food",
      "isSelected": null as bool?
    },
    "apakti": {
      "label": "Aruchi-Do you experience lack of desire towards food",
      "isSelected": null as bool?
    },
    "nishteeva": {
      "label":
          "Nishtheeva-Do you have urge for repetitive spitting/ excessive salivation?",
      "isSelected": null as bool?
    },
    "anilaMudata": {
      "label":
          "Do you have any bothersome feeling of improper  passing of Flatus / stool?",
      "isSelected": null as bool?
    },
    "malaSanga": {
      "label":
          "Mala sanga- Do you experience decreased sweating ? micturition or incomplete evacuation ? (already covered in srotodhalakshan part)",
      "isSelected": null as bool?
    },
    "gaurav": {
      "label":
          "Gaurav- Do you ever experience unusual feeling of heaviness in the body?",
      "isSelected": null as bool?
    }
  };

  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool? doseSelected = null;

  Days selectedDay = Days.day1;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<AamaLakshanaBloc, AamaLakshanaState>(
              listener: (context, state) {
                if (state is AamaLakshanaLoaded) {
                  if (state.aamaLakshanaDataRec != null) {
                    setState(() {
                      selectedDate = state.aamaLakshanaDataRec!["date"];
                    });

                    state.aamaLakshanaDataRec!.forEach((key, value) {
                      if (key == "date") {
                        selectedDate = value;
                      } else if (key == "dose") {
                        if (value == "3") {
                          doseSelected = true;
                        } else {
                          doseSelected = false;
                        }
                      } else {
                        aamaLakshanData[key]["isSelected"] = value;
                      }
                    });
                  }
                }
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: AutoSizeText(
                          "Aama Lakshana Assessment",
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
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  "Deepana Pachana Yog",
                                  minFontSize: 15,
                                  style: TextStyle(
                                    color: Color(0xff15400d),
                                    fontWeight: FontWeight.w700,
                                  ),
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
                                      // Get Request of the day 1 data from server and update
                                      aamaLakshanData.forEach((key, value) {
                                        value["isSelected"] = null;
                                      });
                                      doseSelected = null;
                                      selectedDate = DateFormat("dd-MM-yyyy")
                                          .format(DateTime.now());

                                      getAaamaLakshana();
                                    });
                                  },
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                                child: Container(
                              height: screenHeight * 0.5,
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  color: const Color(0xffb5c99a),
                                  borderRadius: BorderRadius.circular(20)),
                              child: BlocBuilder<AamaLakshanaBloc,
                                  AamaLakshanaState>(
                                builder: (context, state) {
                                  if (state is AamaLakshanaLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive());
                                  }
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 2.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.05,
                                              child: Row(children: [
                                                Container(
                                                  height: screenHeight * 0.5,
                                                  width: screenWidth * 0.595,
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xff97a97c),
                                                      border: Border(
                                                          right: BorderSide(
                                                              color: Color(
                                                                  0xff15400D)))),
                                                  child: const Center(
                                                      child: Text(
                                                    "Date",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final DateTime? picked =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2100),
                                                    );
                                                    if (picked != null &&
                                                        picked !=
                                                            DateTime.now()) {
                                                      setState(() {
                                                        selectedDate =
                                                            DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(picked);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                      width: screenWidth * 0.28,
                                                      height:
                                                          screenHeight * 0.05,
                                                      color: const Color(
                                                          0xffe9f5db),
                                                      child: Center(
                                                        child:
                                                            Text(selectedDate),
                                                      )),
                                                )
                                              ]),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 2.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.05,
                                              child: Row(children: [
                                                Container(
                                                  height: screenHeight * 0.5,
                                                  width: screenWidth * 0.595,
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xff97a97c),
                                                      border: Border(
                                                          right: BorderSide(
                                                              color: Color(
                                                                  0xff15400D)))),
                                                  child: const Center(
                                                      child: Text(
                                                    "Dose",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      doseSelected = true;
                                                    });
                                                  },
                                                  child: Container(
                                                      width: screenWidth * 0.14,
                                                      height:
                                                          screenHeight * 0.05,
                                                      decoration: BoxDecoration(
                                                        color: doseSelected ==
                                                                true
                                                            ? Colors.green
                                                                .withOpacity(
                                                                    0.5)
                                                            : const Color(
                                                                0xffe9f5db),
                                                        border: const Border(
                                                          right: BorderSide(
                                                              color: Color(
                                                                  0xff15400d)),
                                                        ),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0),
                                                        child: Center(
                                                          child: AutoSizeText(
                                                              "3gm 2xday"),
                                                        ),
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      doseSelected = false;
                                                    });
                                                  },
                                                  child: Container(
                                                      width: screenWidth * 0.14,
                                                      height:
                                                          screenHeight * 0.05,
                                                      decoration: BoxDecoration(
                                                        color: doseSelected ==
                                                                false
                                                            ? Colors.green
                                                                .withOpacity(
                                                                    0.5)
                                                            : const Color(
                                                                0xffe9f5db),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0),
                                                        child: Center(
                                                          child: AutoSizeText(
                                                              "5gm 2xday"),
                                                        ),
                                                      )),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          ...aamaLakshanData.values
                                              .map((lakshan) {
                                            return ComplaintsRow(
                                                screenWidth: screenWidth,
                                                screenHeight: screenHeight,
                                                label: lakshan["label"],
                                                isSelected:
                                                    lakshan["isSelected"],
                                                onCheckPressed: () {
                                                  setState(() {
                                                    lakshan["isSelected"] =
                                                        true;
                                                  });
                                                },
                                                onCrossPressed: () {
                                                  setState(() {
                                                    lakshan["isSelected"] =
                                                        false;
                                                  });
                                                });
                                          })
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
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
                                  const Spacer(),
                                  BlocConsumer<AamaLakshanaBloc,
                                      AamaLakshanaState>(
                                    listener: (context, state) {
                                      if (state is AamaLakshanaError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error Occured: ${state.error}")));
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is CreatingAamaLakshana) {
                                        return ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xff0f6f03))),
                                            onPressed: () => null,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white)),
                                              ),
                                            ));
                                      }
                                      return ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xff0f6f03))),
                                          onPressed: () async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? assessmentID =
                                                prefs.getString("assessmentID");

                                            dev.log(assessmentID ??
                                                "Does not exist");

                                            Map<String, dynamic>
                                                aamaLakshanReq = {
                                              "assessmentName": "aamaLakshana",
                                              "day": selectedDay.dayNumber,
                                              "id": assessmentID,
                                              "data": {
                                                "date": selectedDate,
                                                "dose": doseSelected == true
                                                    ? "3"
                                                    : "5",
                                                ...aamaLakshanData.map(
                                                    (key, value) => MapEntry(
                                                        key,
                                                        value["isSelected"]))
                                              }
                                            };
                                            dev.log(state.toString());
                                            BlocProvider.of<AamaLakshanaBloc>(
                                                    context)
                                                .add(CreateAamaLakshana(
                                                    aamaLakshanaData:
                                                        aamaLakshanReq));
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              AutoSizeText(
                                                "Next",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
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
            )
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
            width: widget.screenWidth * 0.595,
            height: widget.screenHeight * 0.05,
            decoration: const BoxDecoration(
              color: Color(0xff97a97c),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: AutoSizeText(
                  maxLines: 2,
                  widget.label,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            width: widget.screenWidth * 0.14,
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
            width: widget.screenWidth * 0.14,
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
