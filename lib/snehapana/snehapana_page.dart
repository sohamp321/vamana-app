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
import 'snehapana_bloc/snehapana_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'snehapana_bloc/snehapana_event.dart';
import 'snehapana_bloc/snehapana_state.dart';

class SnehapanaPage extends StatefulWidget {
  const SnehapanaPage({super.key});

  @override
  State<SnehapanaPage> createState() => _SnehapanaPageState();
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

class _SnehapanaPageState extends State<SnehapanaPage> {
  void getASnehapana() async {
    BlocProvider.of<SnehapanaBloc>(context)
        .add(GetSnehapana(dayNumber: selectedDay.dayNumber));
  }

  @override
  void initState() {
    BlocProvider.of<SnehapanaBloc>(context).add(Day0Snehapana());
    BlocProvider.of<SnehapanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getASnehapana();
    super.initState();
  }

  Map<String, dynamic> snehapanaData = {
    "dose": {"label": "Dose", "hintText" : "Enter" , "value": TextEditingController()},
    "hunger": {"label": "Onset Of Hunger", "hintText": "Enter" ,"value": TextEditingController()},
    "snehapanaScore": {
      "label": "Snehapana Score",
      "hintText" : "Enter",
      "value": TextEditingController()
    }
  };

  Days selectedDay = Days.day1;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(
          selectedPage: "Snehapana",
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<SnehapanaBloc, SnehapanaState>(
              listener: (context, state) {
                if (state is SnehapanaLoaded) {
                  if (state.SnehapanaDataRec != null) {
                    setState(() {
                      state.SnehapanaDataRec!.forEach((key, value) {
                        snehapanaData[key]["value"].text = value;
                      });
                    });
                  }
                }
              },
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.195,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: AutoSizeText(
                            "Snehapana",
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
                                    top: screenWidth*0.025,
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
                                    onSelectionChanged:
                                        (Set<Days> newSelection) {
                                      setState(() {
                                        selectedDay = newSelection.first;
                                        // Get Request of the day 1 data from server and update
                                        snehapanaData.forEach((key, value) {
                                          value["value"].clear();
                                        });
                                        getASnehapana();
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
                                child:
                                    BlocBuilder<SnehapanaBloc, SnehapanaState>(
                                  builder: (context, state) {
                                    if (state is SnehapanaLoading) {
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
                                            ...snehapanaData.values
                                                .map((value) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: value["value"],
                                                  decoration: InputDecoration(
                                                      labelStyle:
                                                          const TextStyle(
                                                              color: Color(
                                                                  0xff15400d)),
                                                      // filled: true,
                                                      // fillColor:
                                                      //     Color(0xffe9f5db),
                                                      
                                                      border:
                                                          OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                                      // hintText: Text("Enter"),
                                                      label: Text(
                                                          value["label"])),
                                                ),
                                              );
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

                                    BlocConsumer<SnehapanaBloc, SnehapanaState>(
                                      listener: (context, state) {
                                        if (state is SnehapanaError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Error Occured: ${state.error}")));
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is CreatingSnehapana) {
                                          return ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          const Color(
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
                                                                  Colors
                                                                      .white)),
                                                ),
                                              ));
                                        }
                                        return ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xff0f6f03))),
                                            onPressed: () async {
                                              final SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String? assessmentID = prefs
                                                  .getString("assessmentID");

                                              dev.log(assessmentID ??
                                                  "Does not exist");

                                              Map<String, dynamic>
                                                  aamaLakshanReq = {
                                                "assessmentName": "Snehapana",
                                                "day": selectedDay.dayNumber,
                                                "id": assessmentID,
                                                "data": snehapanaData.map(
                                                    (key, value) => MapEntry(
                                                        key,
                                                        value["value"].text))
                                              };
                                              dev.log(state.toString());
                                              BlocProvider.of<SnehapanaBloc>(
                                                      context)
                                                  .add(CreateSnehapana(
                                                      SnehapanaData:
                                                          aamaLakshanReq));
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
              ),
            )
          ],
        ));
  }
}
