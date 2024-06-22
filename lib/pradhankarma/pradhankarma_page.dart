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
import 'pradhankarma_bloc/pradhankarma_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'pradhankarma_bloc/pradhankarma_event.dart';
import 'pradhankarma_bloc/pradhankarma_state.dart';

class PradhanKarmaPage extends StatefulWidget {
  const PradhanKarmaPage({super.key});

  @override
  State<PradhanKarmaPage> createState() => _PradhanKarmaPageState();
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

class _PradhanKarmaPageState extends State<PradhanKarmaPage> {
  void getAPradhanKarma() async {
    BlocProvider.of<PradhanKarmaBloc>(context)
        .add(GetPradhanKarma(dayNumber: "1"));
  }

  @override
  void initState() {
    BlocProvider.of<PradhanKarmaBloc>(context).add(Day0PradhanKarma());
    BlocProvider.of<PradhanKarmaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAPradhanKarma();
    super.initState();
  }

  Map<String, dynamic> pradhanKarmaData = {
    "yavagu": {"label": "Yavagu", "intakeQuantity": TextEditingController()},
    "milk": {"label": "Milk", "intakeQuantity": TextEditingController()},
    "madhanphalaChoorna": {
      "label": "Madhanphala Choorna",
      "intakeQuantity": TextEditingController()
    },
    "madhuyashtiChoorna": {
      "label": "Mashuyashti Choorna",
      "intakeQuantity": TextEditingController()
    },
    "vachaChoorna": {
      "label": "Vacha Choorna",
      "intakeQuantity": TextEditingController()
    },
    "saindhavaLavana": {
      "label": "Saindhava Lavana",
      "intakeQuantity": TextEditingController()
    },
    "madhu": {"label": "Madhu", "intakeQuantity": TextEditingController()},
    "madhuyashtiPhanta": {
      "label": "Madhuyashti Phanta",
      "intakeQuantity": TextEditingController()
    },
    "lavanodaka": {
      "label": "Lavanodaka",
      "intakeQuantity": TextEditingController()
    },
  };


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(selectedPage: "PradhanKarma",),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<PradhanKarmaBloc, PradhanKarmaState>(
              listener: (context, state) {
                if (state is PradhanKarmaLoaded) {
                  if (state.PradhanKarmaDataRec != null) {
                    setState(() {
                      
                    });

                    state.PradhanKarmaDataRec!.forEach((key, value) {
                      
                        pradhanKarmaData[key]["intakeQuantityt"].text = value;
                      
                    });
                  }
                }
              },
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: screenHeight*0.195,),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: AutoSizeText(
                            "PradhanKarma",
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
                                    "Medicine Intake Quantities",
                                    minFontSize: 15,
                                    style: TextStyle(
                                      color: Color(0xff15400d),
                                      fontWeight: FontWeight.w700,
                                    ),
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
                                child: BlocBuilder<PradhanKarmaBloc,
                                    PradhanKarmaState>(
                                  builder: (context, state) {
                                    if (state is PradhanKarmaLoading) {
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
                                            ...pradhanKarmaData.values
                                                .map((lakshan) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller:
                                                      lakshan["inputQuantity"],
                                                  decoration: InputDecoration(
                                                      labelStyle: const TextStyle(
                                                          // fontWeight:
                                                          //     FontWeight.bold,
                                                          color:
                                                              Color(0xff15400D)),
                                                      // filled: true,
                                                      // fillColor: Color(0xffe9f5db),
                                                      border:
                                                          const OutlineInputBorder(),
                                                      label:
                                                          Text(lakshan["label"])),
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
                                    const Spacer(),
                                    BlocConsumer<PradhanKarmaBloc,
                                        PradhanKarmaState>(
                                      listener: (context, state) {
                                        if (state is PradhanKarmaError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Error Occured: ${state.error}")));
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is CreatingPradhanKarma) {
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
                                                "assessmentName": "PradhanKarma",
                                                "day": "1",
                                                "id": assessmentID,
                                                "data": 
                                                  pradhanKarmaData.map(
                                                      (key, value) => MapEntry(
                                                          key,
                                                          value["intakeQuantity"].text))
                                                
                                              };
                                              dev.log(state.toString());
                                              BlocProvider.of<PradhanKarmaBloc>(
                                                      context)
                                                  .add(CreatePradhanKarma(
                                                      PradhanKarmaData:
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

