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
import 'snehana_lakshana_bloc/snehana_lakshana_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'snehana_lakshana_bloc/snehana_lakshana_event.dart';
import 'snehana_lakshana_bloc/snehana_lakshana_state.dart';

class SnehanaLakshanaPage extends StatefulWidget {
  const SnehanaLakshanaPage({super.key});

  @override
  State<SnehanaLakshanaPage> createState() => _SnehanaLakshanaPageState();
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

class _SnehanaLakshanaPageState extends State<SnehanaLakshanaPage> {
  void getASnehanaLakshana() async {
    BlocProvider.of<SnehanaLakshanaBloc>(context)
        .add(GetSnehanaLakshana(dayNumber: selectedDay.dayNumber));
  }

  @override
  void initState() {
    BlocProvider.of<SnehanaLakshanaBloc>(context).add(Day0SnehanaLakshana());
    BlocProvider.of<SnehanaLakshanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getASnehanaLakshana();
    super.initState();
  }

  Map<String, dynamic> snehanaLakshanaData = {
    "vatanulomana": {
      "title": "Vatanulomana",
      "label0": "Less expulsion of adhovaya, faeces and urine",
      "label1": "Incomplete expulsion of adhovayu, faeces and urine",
      "label2": "Proper expulsion of adhovayu, urine and stool",
      "isSelected": null as int?
    },
    "agnideepthi": {
      "title":
          "Agnideepthi \n (as per agni index = Test Dose / given dose * digestion hrs)",
      "label0": "Less (index >3)",
      "label1": "Medium (index =3)",
      "label2": "Good (index <3)",
      "isSelected": null as int?
    },
    "snigdhaVarchas": {
      "title": "Snigdha Varchas",
      "label0": "No visible oiliness in stools",
      "label1": "Oil floats in water",
      "label2": "Oil felt in hands",
      "isSelected": null as int?
    },
    "asamhataVarchas": {
      "title": "Asamhata Varchas",
      "label0": "Lump like stool",
      "label1": "Mushy like stools",
      "label2": "Liquid stools",
      "isSelected": null as int?
    },
    "snehodwega": {
      "title": "Snehodwega",
      "label0": "No much problem in consuming ghee",
      "label1": "Cannot smell ghee",
      "label2": "Intolerance towards ghee",
      "isSelected": null as int?
    },
    "angaSnigdhata": {
      "title": "Anga Snigdhata",
      "label0": "No profound changes found",
      "label1": "Oiliness seen only on certain areas of the body",
      "label2": "Oilliness noticed all over the body",
      "isSelected": null as int?
    },
    "klama": {
      "title": "Klama",
      "label0": "Mild tiredness",
      "label1": "Moderate tiredness",
      "label2": "Fatigue with giddiness",
      "isSelected": null as int?
    },
    "angaMardavta": {
      "title": "Anga Mardavta",
      "label0": "No changes in the muscle felt",
      "label1": "Mild looseness of muscles",
      "label2": "Laxity of the muscles",
      "isSelected": null as int?
    },
    "angaLaghutwa": {
      "title": "Anga Laghutwa",
      "label0": "Mild lightness felt",
      "label1": "Moderate lightness",
      "label2": "Feeling of complete lightness of the body",
      "isSelected": null as int?
    }
  };
  int score = 0;
  String? grade = "";

  void calculateScore() {
    int totalScore = 0;
    snehanaLakshanaData.forEach((key, value) {
      totalScore += (value["isSelected"] ?? 0) as int;
    });
    setState(() {
      dev.log(totalScore.toString());
      score = totalScore;
    });

    if (score >= 6 && score <= 8) {
      setState(() {
        grade = "Avara";
      });
    } else if (score >= 9 && score <= 13) {
      setState(() {
        grade = "Madhyama";
      });
    } else if (score >= 14 && score <= 18) {
      setState(() {
        grade = "Pravara";
      });
    } else {
      setState(() {
        grade = "";
      });
    }
  }

  Days selectedDay = Days.day1;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(selectedPage: "SnehanaLakshana",),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<SnehanaLakshanaBloc, SnehanaLakshanaState>(
              listener: (context, state) {
                if (state is SnehanaLakshanaLoaded) {
                  if (state.SnehanaLakshanaDataRec != null) {
                    setState(() {
                      state.SnehanaLakshanaDataRec!.forEach((key, value) {
                        snehanaLakshanaData[key]["isSelected"] = value;
                      });
                    });
                    calculateScore();
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
                          "Snehana Lakshana Assessment",
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
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
                                      snehanaLakshanaData.forEach((key, value) {
                                        value["isSelected"] = null;
                                      });

                                      getASnehanaLakshana();
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
                              child: BlocBuilder<SnehanaLakshanaBloc,
                                  SnehanaLakshanaState>(
                                builder: (context, state) {
                                  if (state is SnehanaLakshanaLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive());
                                  }
                                  return SingleChildScrollView(
                                      child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                      ...snehanaLakshanaData.keys.map((key) {
                                        return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: AutoSizeText(
                                              snehanaLakshanaData[key]["title"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400d)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButtonFormField<int>(
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xff15400d)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xff15400d)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xffe9f5db),
                                                ),
                                                isExpanded: true,
                                                hint: const Text("Select"),
                                                value: snehanaLakshanaData[key]
                                                    ["isSelected"],
                                                items: [
                                                  DropdownMenuItem(
                                                    value: 0,
                                                    child: SizedBox(
                                                      width: screenWidth * 0.7,
                                                      child: AutoSizeText(
                                                        snehanaLakshanaData[key]
                                                            ["label0"],
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DropdownMenuItem(
                                                      value: 1,
                                                      child: Text(
                                                          snehanaLakshanaData[
                                                              key]["label1"])),
                                                  DropdownMenuItem(
                                                      value: 2,
                                                      child: Text(
                                                          snehanaLakshanaData[
                                                              key]["label2"])),
                                                ],
                                                onChanged: (int? newValue) {
                                                  setState(() {
                                                    snehanaLakshanaData[key]
                                                            ["isSelected"] =
                                                        newValue;
                                                  });
                                                  calculateScore();
                                                }),
                                          ),
                                        ]);
                                      }),
                                      AutoSizeText("Current Grade: $grade")
                                    ]),
                                  ));
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

                                  BlocConsumer<SnehanaLakshanaBloc,
                                      SnehanaLakshanaState>(
                                    listener: (context, state) {
                                      if (state is SnehanaLakshanaError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error Occured: ${state.error}")));
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is CreatingSnehanaLakshana) {
                                        return ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xff0f6f03))),
                                            onPressed: () {},
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
                                              "assessmentName":
                                                  "SnehanaLakshana",
                                              "day": selectedDay.dayNumber,
                                              "id": assessmentID,
                                              "data": snehanaLakshanaData.map(
                                                  (key, value) => MapEntry(
                                                      key, value["isSelected"]))
                                            };
                                            dev.log(state.toString());
                                            BlocProvider.of<
                                                        SnehanaLakshanaBloc>(
                                                    context)
                                                .add(CreateSnehanaLakshana(
                                                    SnehanaLakshanaData:
                                                        aamaLakshanReq));
                                          },
                                          child: SizedBox(
                                            height: 50,
                                            width: 80,
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

class SnehanaLakshanaObservation extends StatelessWidget {
  SnehanaLakshanaObservation({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.label0,
    required this.label1,
    required this.label2,
    required this.isSelected,
    required this.onCheckPressed,
    required this.onCrossPressed,
  });

  final double screenWidth;
  final double screenHeight;
  VoidCallback onCheckPressed;
  VoidCallback onCrossPressed;
  final String title;
  final String label0;
  final String label1;
  final String label2;
  int? isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [],
      ),
    );
  }
}

class ComplaintsRow extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String label;
  int? isSelected;
  int toCheck;
  VoidCallback onCheckPressed;
  VoidCallback onCrossPressed;

  ComplaintsRow(
      {required this.screenWidth,
      required this.screenHeight,
      required this.label,
      required this.isSelected,
      required this.onCheckPressed,
      required this.onCrossPressed,
      required this.toCheck});

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
              color: widget.isSelected == widget.toCheck
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
              color: widget.isSelected != widget.toCheck
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
