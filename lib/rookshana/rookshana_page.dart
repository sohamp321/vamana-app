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
import 'rookshana_bloc/rookshana_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'rookshana_bloc/rookshana_event.dart';
import 'rookshana_bloc/rookshana_state.dart';

class RookshanaPage extends StatefulWidget {
  const RookshanaPage({super.key});

  @override
  State<RookshanaPage> createState() => _RookshanaPageState();
}

enum Days {
  day0(dayNumber: "0"),
  day1(dayNumber: "1"),
  day2(dayNumber: "2"),
  day3(dayNumber: "3"),
  day4(dayNumber: "4"),
  day5(dayNumber: "5"),
  day6(dayNumber: "6"),
  day7(dayNumber: "7"),
  day8(dayNumber: "8");

  final String dayNumber;
  const Days({required this.dayNumber});
}

class _RookshanaPageState extends State<RookshanaPage> {
  void getARookshana() async {
    BlocProvider.of<RookshanaBloc>(context)
        .add(GetRookshana(dayNumber: selectedDay.dayNumber));
  }

  @override
  void initState() {
    BlocProvider.of<RookshanaBloc>(context).add(Day0Rookshana());
    BlocProvider.of<RookshanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getARookshana();
    super.initState();
  }

  Map<String, dynamic> giSymptoms = {
    "vaataVisarga": {
      "label":
          "Vaata Visarga (Free & Satisfactory Passage or Movement of Flatus / Gas )",
      "isSelected": null as bool?
    },
    "mutraVisarga": {
      "label":
          "Mutra visarga (Free & Satisfactory Passage or Movement of Urine)",
      "isSelected": null as bool?
    },
    "purishaVisarga": {
      "label":
          "Purisha visarga (Free & Satisfactory Passage or Movement of Faces / Bowel Movements)",
      "isSelected": null as bool?
    }
  };

  Map<String, dynamic> physicalSymptoms = {
    "kanthaShuddhi": {
      "label": "Kantha Shuddhi(Clear Throat)",
      "isSelected": null as bool?
    },
    "udgaraShuddhi": {
      "label":
          " Udgara Shuddhi(Clear Belching – Without Odour / Taste/ Other sensations )",
      "isSelected": null as bool?
    },
    "aasyaShuddhi": {
      "label": "Aasya Shuddhi(Clear Oral Cavity – Natural Feeling)",
      "isSelected": null as bool?
    },
    "kshut": {
      "label": "Kshut (Regular Appetite & Hunger)",
      "isSelected": null as bool?
    },
    "trishna": {
      "label": "Trishna (Regular Thirst)",
      "isSelected": null as bool?
    },
    "ruchi": {
      "label": "Ruchi (Relishing Consumed Food)",
      "isSelected": null as bool?
    }
  };

  Map<String, dynamic> functionalSymptoms = {
    "hridhyaShuddhi": {
      "label": "Hridhya Shuddhi (Calmness of Mind)",
      "isSelected": null as bool?
    },
    "tandraNasha": {
      "label": " Tandra Nasha(Feeling Non Drowsy)",
      "isSelected": null as bool?
    },
    "klamaNasha": {
      "label": "Klama Nasha (Feeling Energetic)",
      "isSelected": null as bool?
    },
    "vimalendriyata": {
      "label":
          "Vimalendriyata with Manahprasada (Focussed Sensory Perception - Vision, Smell, Hearing, Touch)",
      "isSelected": null as bool?
    },
    "trishna": {
      "label": "Trishna (Regular Thirst)",
      "isSelected": null as bool?
    },
    "gatraLaghava": {
      "label": "Gatra Laghava(Physical , Weight)",
      "isSelected": null as bool?
    },
    "vyadhiMardavam": {
      "label": "Vyadhi Mardavam (Reduction in Symptoms of Disease)",
      "isSelected": null as bool?
    }
  };

  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Days selectedDay = Days.day0;
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
            BlocListener<RookshanaBloc, RookshanaState>(
              listener: (context, state) {
                if (state is RookshanaLoaded) {
                  if (state.RookshanaDataRec != null) {
                    setState(() {
                      state.RookshanaDataRec!.forEach((key, value) {
                        if (key == "date") {
                          selectedDate = value;
                        } else if (key == "giSymptoms") {
                          value.forEach((key1, value1) {
                            giSymptoms[key1]["isSelected"] = value1;
                          });
                        } else if (key == "physicalSymptoms") {
                          value.forEach((key2, value2) {
                            physicalSymptoms[key2]["isSelected"] = value2;
                          });
                        } else if (key == "functional") {
                          value.forEach((key3, value3) {
                            functionalSymptoms[key3]["isSelected"] = value3;
                          });
                        }
                      });
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
                          "Rookshana",
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
                                      value: Days.day0,
                                      label: Text('Day 0'),
                                    ),
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
                                    ),
                                    ButtonSegment<Days>(
                                      value: Days.day8,
                                      label: Text('Day 8'),
                                    )
                                  ],
                                  selected: <Days>{selectedDay},
                                  onSelectionChanged: (Set<Days> newSelection) {
                                    setState(() {
                                      selectedDay = newSelection.first;
                                      // Get Request of the day 1 data from server and update
                                      giSymptoms.forEach((key, value) {
                                        value["isSelected"] = null;
                                      });
                                      physicalSymptoms.forEach((key, value) {
                                        value["isSelected"] = null;
                                      });
                                      functionalSymptoms.forEach((key, value) {
                                        value["isSelected"] = null;
                                      });
                                      selectedDate = DateFormat("dd-MM-yyyy")
                                          .format(DateTime.now());
                                    });
                                    getARookshana();
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
                              child: BlocBuilder<RookshanaBloc, RookshanaState>(
                                builder: (context, state) {
                                  if (state is RookshanaLoading) {
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
                                          const AutoSizeText(
                                            "GI Symptoms",
                                            minFontSize: 15,
                                            style: TextStyle(
                                                color: Color(0xff15400D),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ...giSymptoms.values.map((lakshan) {
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
                                          }),
                                          const AutoSizeText(
                                            "Objective / Physical Symptoms",
                                            minFontSize: 15,
                                            style: TextStyle(
                                                color: Color(0xff15400D),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ...physicalSymptoms.values
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
                                          }),
                                          const AutoSizeText(
                                            "Functional (Involving-Manah)",
                                            minFontSize: 15,
                                            style: TextStyle(
                                                color: Color(0xff15400D),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ...functionalSymptoms.values.map(
                                              (lakshan) => ComplaintsRow(
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
                                                  }))
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
                                  BlocConsumer<RookshanaBloc, RookshanaState>(
                                    listener: (context, state) {
                                      if (state is RookshanaError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error Occured: ${state.error}")));
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is CreatingRookshana) {
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

                                            Map<String, dynamic> RookshanaReq =
                                                {
                                              "assessmentName": "Rookshana",
                                              "day": selectedDay.dayNumber,
                                              "id": assessmentID,
                                              "data": {
                                                "date": selectedDate,
                                                "giSymptoms": giSymptoms.map(
                                                    (key, value) => MapEntry(
                                                        key,
                                                        value["isSelected"])),
                                                "physicalSymptoms":
                                                    physicalSymptoms.map((key,
                                                            value) =>
                                                        MapEntry(
                                                            key,
                                                            value[
                                                                "isSelected"])),
                                                "functional": functionalSymptoms
                                                    .map((key, value) =>
                                                        MapEntry(
                                                            key,
                                                            value[
                                                                "isSelected"]))
                                              }
                                            };
                                            dev.log(state.toString());
                                            BlocProvider.of<RookshanaBloc>(
                                                    context)
                                                .add(CreateRookshana(
                                                    RookshanaData:
                                                        RookshanaReq));
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
