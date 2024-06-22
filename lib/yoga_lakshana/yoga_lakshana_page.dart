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
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import "yoga_lakshana_bloc.dart/yoga_lakshana_bloc.dart";
import "yoga_lakshana_bloc.dart/yoga_lakshana_event.dart";
import "yoga_lakshana_bloc.dart/yoga_lakshana_state.dart";

class YogaLakshanaPage extends StatefulWidget {
  const YogaLakshanaPage({super.key});

  @override
  State<YogaLakshanaPage> createState() => _YogaLakshanaPageState();
}

enum yogaLakshana {
  samyak(yoga: "samyaka"),
  ayoga(yoga: "ayoga"),
  atiyoga(yoga: "atiyoga"),
  ;

  final String yoga;
  const yogaLakshana({required this.yoga});
}

class _YogaLakshanaPageState extends State<YogaLakshanaPage> {
  void getAYogaLakshana() async {
    BlocProvider.of<YogaLakshanaBloc>(context).add(GetYogaLakshana());
  }

  @override
  void initState() {
    BlocProvider.of<YogaLakshanaBloc>(context).add(Day0YogaLakshana());
    BlocProvider.of<YogaLakshanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAYogaLakshana();
    super.initState();
  }

  Map<String, dynamic> samayakYogaLakshanaData = {
    "kalePravruti": {
      "label": "Kale-pravruti (Timely initiation of emesis)",
      "isSelected": null as bool?
    },
    "yathakramaKaphaPittaAnilaAgaman": {
      "label":
          "Yathakrama kapha Pitta- anila agaman (sequential elimination of Kapha, pitta, and anila)",
      "isSelected": null as bool?
    },
    "swayamChaAvasthanam": {
      "label":
          "Swayam cha avasthanam (emesis Stops on its own after elimination of all toxins)",
      "isSelected": null as bool?
    },
    "kanthaShudhi": {
      "label": "Kantha-shudhi (No irritation in Throat)",
      "isSelected": null as bool?
    },
    "srotovishudi": {
      "label":
          "Srotovishudi (clarity of channels/ Bahya srotas -External Orifices- to be considered for immediate effect)",
      "isSelected": null as bool?
    },
    "hridayaParshvaShudhi": {
      "label":
          "Hridaya-parshva-shudhi (No discomfort in chest region and flanks)",
      "isSelected": null as bool?
    },
    "indriyaShudhi": {
      "label": "Indriya-shudhi (sense organs appearing to be more active)",
      "isSelected": null as bool?
    },
    "murdhaShudhi": {
      "label": "Murdha-shudhi (lightness of head without any discomfort)",
      "isSelected": null as bool?
    },
    "laghuta": {"label": "Laghuta (lightness)", "isSelected": null as bool?},
    "daurbalya": {"label": "Daurbalya (fatigue)", "isSelected": null as bool?},
    "swasthtaa": {
      "label": "Swasthtaa (Decreased intensity of disease) - After effect",
      "isSelected": null as bool?
    },
    "manahPrasada": {
      "label":
          "Manah-prasada (Feeling more happy and contented) - After effect",
      "isSelected": null as bool?
    }
  };

  Map<String, dynamic> ayogaLakshanaData = {
    "apravrutiKevalAushadhaPravruti": {
      "label":
          "Apravruti/keval aushadha pravruti (cessation of emesis or expulsion of medicine only)",
      "isSelected": null as bool?
    },
    "kaphaPrasekaNishtheva": {
      "label": "Kapha-praseka/nishtheva (Excessive mucous stained salivation)",
      "isSelected": null as bool?
    },
    "srotoAvishudhi": {
      "label":
          "Sroto-avishudhi (Absence of clarity of channels/ Bahya srotas - External Orifices- to be considered for immediate effect)",
      "isSelected": null as bool?
    },
    "hridayaAvishudhi": {
      "label": "Hridaya-Avishudhi (discomfort in chest region and flanks)",
      "isSelected": null as bool?
    },
    "gurugatrata": {
      "label": "Gurugatrata (heaviness)",
      "isSelected": null as bool?
    },
    "sphotaKotha": {
      "label": "Sphota-kotha (Skin rashes or eruptions)",
      "isSelected": null as bool?
    },
    "kandu": {"label": "Kandu (Itching)", "isSelected": null as bool?}
  };
  Map<String, dynamic> atiyogaLakshanaData = {
    "phenilaVamana": {
      "label": "Phenila-vamana (frothy appearance of vomitus)",
      "isSelected": null as bool?
    },
    "raktaChandikaYuktaVamana": {
      "label": "Rakta-chandika-yukta-vamana (blood stained vomitus)",
      "isSelected": null as bool?
    },
    "kanthaPida": {
      "label": "Kantha-pida (pain/irritation of throat)",
      "isSelected": null as bool?
    },
    "hritaPida": {
      "label": "Hrita-pida (pain in chest region)",
      "isSelected": null as bool?
    },
    "trishna": {
      "label": "Trishna (Excessive thirst/dehydration)",
      "isSelected": null as bool?
    },
    "balaHani": {
      "label": "Bala hani (loss of strength)",
      "isSelected": null as bool?
    },
    "mohaMurchha": {
      "label": "Moha/murchha (state of confusion/loss of consciousness)",
      "isSelected": null as bool?
    }
  };

  yogaLakshana selectedYogaLakshana = yogaLakshana.samyak;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(selectedPage: "YogaLakshana",),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<YogaLakshanaBloc, YogaLakshanaState>(
              listener: (context, state) {
                if (state is YogaLakshanaLoaded) {
                  if (state.YogaLakshanaDataRec != null) {
                    setState(() {
                      state.YogaLakshanaDataRec!["samyaka"]
                          .forEach((key, value) {
                        samayakYogaLakshanaData[key]["isSelected"] = value;
                      });
                    });
                    setState(() {
                      state.YogaLakshanaDataRec!["ayoga"].forEach((key, value) {
                        ayogaLakshanaData[key]["isSelected"] = value;
                      });
                    });
                    setState(() {
                      state.YogaLakshanaDataRec!["atiyoga"]
                          .forEach((key, value) {
                        atiyogaLakshanaData[key]["isSelected"] = value;
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
                          "Yoga Lakshana Observation",
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
                                child: SegmentedButton<yogaLakshana>(
                                  style: SegmentedButton.styleFrom(
                                    backgroundColor: const Color(0xffe9f5db),
                                    foregroundColor: const Color(0xff15400d),
                                    selectedForegroundColor: Colors.white,
                                    selectedBackgroundColor:
                                        const Color(0xff718355),
                                  ),
                                  segments: const <ButtonSegment<yogaLakshana>>[
                                    ButtonSegment<yogaLakshana>(
                                      value: yogaLakshana.samyak,
                                      label: Text('Samyaka'),
                                    ),
                                    ButtonSegment<yogaLakshana>(
                                      value: yogaLakshana.ayoga,
                                      label: Text('Ayoga'),
                                    ),
                                    ButtonSegment<yogaLakshana>(
                                      value: yogaLakshana.atiyoga,
                                      label: Text('Atiyoga'),
                                    )
                                  ],
                                  selected: <yogaLakshana>{
                                    selectedYogaLakshana
                                  },
                                  onSelectionChanged:
                                      (Set<yogaLakshana> newSelection) {
                                    setState(() {
                                      selectedYogaLakshana = newSelection.first;
                                      // Get Request of the day 1 data from server and update
                                    });
                                  },
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                                child: Container(
                              height: screenHeight * 0.6,
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  color: const Color(0xffb5c99a),
                                  borderRadius: BorderRadius.circular(20)),
                              child: BlocBuilder<YogaLakshanaBloc,
                                  YogaLakshanaState>(
                                builder: (context, state) {
                                  if (state is YogaLakshanaLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive());
                                  }
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(children: [
                                          if (selectedYogaLakshana ==
                                              yogaLakshana.samyak)
                                            ...samayakYogaLakshanaData.values
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
                                          else if (selectedYogaLakshana ==
                                              yogaLakshana.atiyoga)
                                            ...atiyogaLakshanaData.values
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
                                          else if (selectedYogaLakshana ==
                                              yogaLakshana.ayoga)
                                            ...ayogaLakshanaData.values
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
                                  BlocConsumer<YogaLakshanaBloc,
                                      YogaLakshanaState>(
                                    listener: (context, state) {
                                      if (state is YogaLakshanaError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error Occured: ${state.error}")));
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is CreatingYogaLakshana) {
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
                                              "assessmentName": "YogaLakshana",
                                              "day": "1",
                                              "id": assessmentID,
                                              "data": {
                                                "samyaka":
                                                    samayakYogaLakshanaData.map(
                                                        (key, value) => MapEntry(
                                                            key,
                                                            value[
                                                                "isSelected"])),
                                                "ayoga": ayogaLakshanaData.map(
                                                    (key, value) => MapEntry(
                                                        key,
                                                        value["isSelected"])),
                                                "atiyoga": atiyogaLakshanaData
                                                    .map((key, value) =>
                                                        MapEntry(
                                                            key,
                                                            value[
                                                                "isSelected"]))
                                              }
                                            };
                                            dev.log(state.toString());
                                            BlocProvider.of<YogaLakshanaBloc>(
                                                    context)
                                                .add(CreateYogaLakshana(
                                                    YogaLakshanaData:
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
