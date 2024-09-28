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
import 'blood_pressure_bloc/blood_pressure_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'blood_pressure_bloc/blood_pressure_event.dart';
import 'blood_pressure_bloc/blood_pressure_state.dart';

class BloodPressurePage extends StatefulWidget {
  const BloodPressurePage({super.key});

  @override
  State<BloodPressurePage> createState() => _BloodPressurePageState();
}

enum Entries {
  entry1(dayNumber: "1"),
  entry2(dayNumber: "2"),
  entry3(dayNumber: "3"),
  entry4(dayNumber: "4"),
  entry5(dayNumber: "5");

  final String dayNumber;
  const Entries({required this.dayNumber});
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  void getABloodPressure() async {
    BlocProvider.of<BloodPressureBloc>(context)
        .add(GetBloodPressure(dayNumber: selectedEntry.dayNumber));
  }

  @override
  void initState() {
    BlocProvider.of<BloodPressureBloc>(context).add(Day0BloodPressure());
    BlocProvider.of<BloodPressureBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getABloodPressure();
    timeController.text = selectedTime;
    super.initState();
  }

  Map<String, dynamic> bloodPressureData = {
    "bloodPressure": {
      "label": "Blood Pressure(in mmHg)",
      "value": TextEditingController()
    },
    "pulse": {"label": "Pulse(per min)", "value": TextEditingController()},
    "other": {"label": "Other", "value": TextEditingController()}
  };

  String selectedTime = DateFormat('HH:mm').format(DateTime.now());

  final TextEditingController timeController = TextEditingController();

  bool? doseSelected = null;

  Entries selectedEntry = Entries.entry1;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(
          selectedPage: "BloodPressure",
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<BloodPressureBloc, BloodPressureState>(
              listener: (context, state) {
                if (state is BloodPressureLoaded) {
                  if (state.BloodPressureDataRec != null) {
                    setState(() {});

                    state.BloodPressureDataRec!.forEach((key, value) {
                      if (key == "time") {
                        timeController.text = value;
                      } else {
                        bloodPressureData[key]["value"].text = value;
                      }
                    });
                  }
                }
              },
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: screenHeight * 0.195),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: AutoSizeText(
                            "Blood Pressure",
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
                                  child: SegmentedButton<Entries>(
                                    style: SegmentedButton.styleFrom(
                                      backgroundColor: const Color(0xffe9f5db),
                                      foregroundColor: const Color(0xff15400d),
                                      selectedForegroundColor: Colors.white,
                                      selectedBackgroundColor:
                                          const Color(0xff718355),
                                    ),
                                    segments: const <ButtonSegment<Entries>>[
                                      ButtonSegment<Entries>(
                                        value: Entries.entry1,
                                        label: Text('1'),
                                      ),
                                      ButtonSegment<Entries>(
                                        value: Entries.entry2,
                                        label: Text('2'),
                                      ),
                                      ButtonSegment<Entries>(
                                        value: Entries.entry3,
                                        label: Text('3'),
                                      ),
                                      ButtonSegment<Entries>(
                                        value: Entries.entry4,
                                        label: Text('4'),
                                      ),
                                      ButtonSegment<Entries>(
                                        value: Entries.entry5,
                                        label: Text('5'),
                                      ),
                                    ],
                                    selected: <Entries>{selectedEntry},
                                    onSelectionChanged:
                                        (Set<Entries> newSelection) {
                                      setState(() {
                                        selectedEntry = newSelection.first;
                                        // Get Request of the day 1 data from server and update
                                        bloodPressureData.forEach((key, value) {
                                          value["value"].clear();
                                        });

                                        selectedTime = DateFormat('HH:mm')
                                            .format(DateTime.now());

                                        timeController.text = selectedTime;
                                        getABloodPressure();
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
                                child: BlocBuilder<BloodPressureBloc,
                                    BloodPressureState>(
                                  builder: (context, state) {
                                    if (state is BloodPressureLoading) {
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final TimeOfDay? picked =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (picked != null) {
                                                    setState(() {
                                                      selectedTime = picked
                                                          .format(context);
                                                      timeController.text =
                                                          selectedTime;
                                                    });
                                                  }
                                                },
                                                child: AbsorbPointer(
                                                  child: TextFormField(
                                                    controller: timeController,
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            label:
                                                                Text("Time")),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ...bloodPressureData.values
                                                .map((value) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: value["value"],
                                                  decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(),
                                                      label:
                                                          Text(value["label"])),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BlocConsumer<BloodPressureBloc,
                                        BloodPressureState>(
                                      listener: (context, state) {
                                        if (state is BloodPressureError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Error Occured: ${state.error}")));
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is CreatingBloodPressure) {
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
                                                "assessmentName":
                                                    "BloodPressure",
                                                "day": selectedEntry.dayNumber,
                                                "id": assessmentID,
                                                "data": {
                                                  "time": timeController.text,
                                                  ...bloodPressureData.map(
                                                      (key, value) => MapEntry(
                                                          key,
                                                          value["value"].text))
                                                }
                                              };
                                              dev.log(state.toString());
                                              BlocProvider.of<
                                                          BloodPressureBloc>(
                                                      context)
                                                  .add(CreateBloodPressure(
                                                      BloodPressureData:
                                                          aamaLakshanReq));
                                            },
                                            child: const SizedBox(
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
