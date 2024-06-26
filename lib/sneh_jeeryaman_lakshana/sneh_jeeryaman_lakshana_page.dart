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
import 'sneh_jeeryaman_lakshana_bloc/sneh_jeeryaman_lakshana_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'sneh_jeeryaman_lakshana_bloc/sneh_jeeryaman_lakshana_event.dart';
import 'sneh_jeeryaman_lakshana_bloc/sneh_jeeryaman_lakshana_state.dart';

class SnehJeeryamanLakshanaPage extends StatefulWidget {
  const SnehJeeryamanLakshanaPage({super.key});

  @override
  State<SnehJeeryamanLakshanaPage> createState() =>
      _SnehJeeryamanLakshanaPageState();
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

class _SnehJeeryamanLakshanaPageState extends State<SnehJeeryamanLakshanaPage> {
  void getASnehJeeryamanLakshana() async {
    BlocProvider.of<SnehJeeryamanLakshanaBloc>(context)
        .add(GetSnehJeeryamanLakshana(dayNumber: selectedDay.dayNumber));
  }

  @override
  void initState() {
    BlocProvider.of<SnehJeeryamanLakshanaBloc>(context)
        .add(Day0SnehJeeryamanLakshana());
    BlocProvider.of<SnehJeeryamanLakshanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getASnehJeeryamanLakshana();
    super.initState();
  }

  Map<String, dynamic> snehajeeryamanaLakshanaData = {
    "trishna": {
      "label": "Trishna (Excessive thirst)",
      "isSelected": null as bool?
    },
    "daha": {"label": "Daha (Burning sensation)", "isSelected": null as bool?},
    "bhrama": {"label": "Bhrama (Dizziness)", "isSelected": null as bool?},
    "saad": {"label": "Saad (Nausea)", "isSelected": null as bool?},
    "arati": {"label": "Arati (Dislike/aversion)", "isSelected": null as bool?},
    "klama": {"label": "Klama (Fatigue)", "isSelected": null as bool?}
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
        drawer:  VamanaDrawer(selectedPage: "SnehJeeryamanLakshana",),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<SnehJeeryamanLakshanaBloc, SnehJeeryamanLakshanaState>(
              listener: (context, state) {
                if (state is SnehJeeryamanLakshanaLoaded) {
                  if (state.SnehJeeryamanLakshanaDataRec != null) {
                
                    state.SnehJeeryamanLakshanaDataRec!.forEach((key, value) {
                      snehajeeryamanaLakshanaData[key]["isSelected"] = value;
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
                          "Sneha Jeeryamana Assessment",
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenWidth * 0.025,
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
                                      snehajeeryamanaLakshanaData
                                          .forEach((key, value) {
                                        value["isSelected"] = null;
                                      });

                                      getASnehJeeryamanLakshana();
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
                                  // color: const Color(0xffb5c99a),
                                  borderRadius: BorderRadius.circular(20)),
                              child: BlocBuilder<SnehJeeryamanLakshanaBloc,
                                  SnehJeeryamanLakshanaState>(
                                builder: (context, state) {
                                  if (state is SnehJeeryamanLakshanaLoading) {
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
                                          ...snehajeeryamanaLakshanaData.values
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  BlocConsumer<SnehJeeryamanLakshanaBloc,
                                      SnehJeeryamanLakshanaState>(
                                    listener: (context, state) {
                                      if (state is SnehJeeryamanLakshanaError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error Occured: ${state.error}")));
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state
                                          is CreatingSnehJeeryamanLakshana) {
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
                                                snehajeeryamanaLakshanaReq = {
                                              "assessmentName":
                                                  "SnehJeeryamanLakshana",
                                              "day": selectedDay.dayNumber,
                                              "id": assessmentID,
                                              "data": {
                                                ...snehajeeryamanaLakshanaData
                                                    .map((key, value) =>
                                                        MapEntry(
                                                            key,
                                                            value[
                                                                "isSelected"]))
                                              }
                                            };
                                            dev.log(state.toString());
                                            BlocProvider.of<
                                                        SnehJeeryamanLakshanaBloc>(
                                                    context)
                                                .add(CreateSnehJeeryamanLakshana(
                                                    SnehJeeryamanLakshanaData:
                                                        snehajeeryamanaLakshanaReq));
                                          },
                                          child: SizedBox(
                                            width: 80,
                                            height: 50,
                                            child: Center(
                                              child: AutoSizeText(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
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
