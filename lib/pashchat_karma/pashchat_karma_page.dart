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
import 'pashchat_karma_bloc/pashchat_karma_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'pashchat_karma_bloc/pashchat_karma_event.dart';
import 'pashchat_karma_bloc/pashchat_karma_state.dart';

class PashchatKarmaPage extends StatefulWidget {
  const PashchatKarmaPage({super.key});

  @override
  State<PashchatKarmaPage> createState() => _PashchatKarmaPageState();
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

class _PashchatKarmaPageState extends State<PashchatKarmaPage> {
  void getAPashchatKarma() async {
    BlocProvider.of<PashchatKarmaBloc>(context)
        .add(GetPashchatKarma(dayNumber: "1"));
  }

  @override
  void initState() {
    BlocProvider.of<PashchatKarmaBloc>(context).add(Day0PashchatKarma());
    BlocProvider.of<PashchatKarmaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAPashchatKarma();
    super.initState();
  }

  Map<String, dynamic> pashchatKarma = {
    "aaturaPariksha": {
      "label": "Aatura Pariksha (examination of subject)",
      "value": TextEditingController()
    },
    "pulseRate": {"label": "Pulse Rate", "value": TextEditingController()},
    "bloodPressure": {
      "label": "Blood Pressure",
      "value": TextEditingController()
    },
    "vamanaVyapada": {
      "label": "Vamana Vyapada and their management(if any)",
      "value": TextEditingController()
    },
    "parihara": {
      "label": "Parihara (Behavioral & Diet Restriction)",
      "value": TextEditingController()
    }
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: const VamanaAppBar(),
        drawer: VamanaDrawer(
          selectedPage: "PashchatKarma",
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<PashchatKarmaBloc, PashchatKarmaState>(
              listener: (context, state) {
                if (state is PashchatKarmaLoaded) {
                  if (state.PashchatKarmaDataRec != null) {
                    setState(() {
                      state.PashchatKarmaDataRec!.forEach((key, value) {
                        pashchatKarma[key]["value"].text = value;
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
                            "Pashchat Karma",
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
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              SingleChildScrollView(
                                  child: Container(
                                height: screenHeight * 0.5,
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                    // color: const Color(0xffb5c99a),
                                    borderRadius: BorderRadius.circular(20)),
                                child: BlocBuilder<PashchatKarmaBloc,
                                    PashchatKarmaState>(
                                  builder: (context, state) {
                                    if (state is PashchatKarmaLoading) {
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
                                            ...pashchatKarma.values.map((e) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            const OutlineInputBorder(),
                                                        label:
                                                            Text(e["label"])),
                                                    controller: e["value"]),
                                              );
                                            }),
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

                                    BlocConsumer<PashchatKarmaBloc,
                                        PashchatKarmaState>(
                                      listener: (context, state) {
                                        if (state is PashchatKarmaError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Error Occured: ${state.error}")));
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is CreatingPashchatKarma) {
                                          return ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          const Color(
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
                                                                  Colors
                                                                      .white)),
                                                ),
                                              ));
                                        }
                                        return ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty
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
                                                    "PashchatKarma",
                                                "day": "1",
                                                "id": assessmentID,
                                                "data": pashchatKarma.map(
                                                    (key, value) => MapEntry(
                                                        key,
                                                        value["value"].text))
                                              };
                                              dev.log(state.toString());
                                              BlocProvider.of<
                                                          PashchatKarmaBloc>(
                                                      context)
                                                  .add(CreatePashchatKarma(
                                                      PashchatKarmaData:
                                                          aamaLakshanReq));
                                            },
                                            child: const SizedBox(
                                              width: 80,
                                              height: 50,
                                              child: Center(
                                                child: AutoSizeText(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18
                                                  ),
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

  ComplaintsRow({super.key, 
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
