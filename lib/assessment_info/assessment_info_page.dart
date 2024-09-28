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
import 'package:vamana_app/aama_lakshana/aama_lakshana_bloc/aama_lakshana_bloc.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/components/widgets.dart';
import 'package:vamana_app/dashboard/dashboard_bloc/dashboard_state.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'assessment_info_bloc/assessment_info_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'assessment_info_bloc/assessment_info_event.dart';
import 'assessment_info_bloc/assessment_info_state.dart';

class AssessmentInfoPage extends StatefulWidget {
  const AssessmentInfoPage({super.key});

  @override
  State<AssessmentInfoPage> createState() => _AssessmentInfoPageState();
}

enum AssessmentInfo {
  patientInfo(label: "Patient Info"),
  complaints(label: "Complaints"),
  investigations(label: "Investigations"),
  poorvaKarma(label: "Poorva Karma");

  final String label;
  const AssessmentInfo({required this.label});
}

class _AssessmentInfoPageState extends State<AssessmentInfoPage> {
  String convertSnakeToTitle(String snakeCase) {
    return snakeCase
        .replaceAll('_', ' ') // Replace underscores with spaces
        .split(' ') // Split the string into words
        .map((word) =>
            word[0].toUpperCase() +
            word.substring(1)) // Capitalize the first letter of each word
        .join(' '); // Join the words back into a single string
  }

  Map<String, dynamic> assessmentInfoData = {};
  AssessmentInfo selectedSegment = AssessmentInfo.patientInfo;

  void getAAssessmentInfo() async {
    BlocProvider.of<AssessmentInfoBloc>(context).add(GetAssessmentInfo());
  }

  @override
  void initState() {
    BlocProvider.of<AssessmentInfoBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAAssessmentInfo();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: VamanaAppBar(),
        drawer: VamanaDrawer(
          selectedPage: "AssessmentInfo",
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<AssessmentInfoBloc, AssessmentInfoState>(
              listener: (context, state) {
                if (state is AssessmentInfoLoaded) {
                  if (state.AssessmentInfoDataRec != null) {}
                } else if (state is AssessmentInfoLoaded) {
                  if (state.AssessmentInfoDataRec != null) {
                    setState(() {
                      assessmentInfoData = state.AssessmentInfoDataRec!;
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
                          "Assessment Info",
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
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BlocConsumer<AssessmentInfoBloc,
                                      AssessmentInfoState>(
                                    listener: (context, state) {
                                      if (state is AssessmentInfoError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Error Occured: ${state.error}")));
                                      }
                                    },
                                    builder: (context, state) {
                                      // if (state is CreatingAssessmentInfo) {
                                      //   return ElevatedButton(
                                      //       style: ButtonStyle(
                                      //           backgroundColor:
                                      //               MaterialStateProperty
                                      //                   .all<Color>(const Color(
                                      //                       0xff0f6f03))),
                                      //       onPressed: () => null,
                                      //       child: const Padding(
                                      //         padding: EdgeInsets.all(8.0),
                                      //         child: Center(
                                      //           child: CircularProgressIndicator
                                      //               .adaptive(
                                      //                   valueColor:
                                      //                       AlwaysStoppedAnimation<
                                      //                               Color>(
                                      //                           Colors.white)),
                                      //         ),
                                      //       ));
                                      // }
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

                                            dev.log(state.toString());

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AamaLakshanaPage()));
                                          },
                                          child: SizedBox(
                                            width: screenWidth * 0.5,
                                            height: screenHeight * 0.05,
                                            child: const Center(
                                              child: AutoSizeText(
                                                "Aama Lakshana Assessment",
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
                            // create a segmented button from Assessment Info
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),
                                child: SegmentedButton<AssessmentInfo>(
                                  style: SegmentedButton.styleFrom(
                                    backgroundColor: const Color(0xffe9f5db),
                                    foregroundColor: const Color(0xff15400d),
                                    selectedForegroundColor: Colors.white,
                                    selectedBackgroundColor:
                                        const Color(0xff718355),
                                  ),
                                  segments: AssessmentInfo.values
                                      .map((info) =>
                                          ButtonSegment<AssessmentInfo>(
                                            value: info,
                                            label: Text(info.label),
                                          ))
                                      .toList(),
                                  selected: {selectedSegment},
                                  onSelectionChanged: (newSelection) {
                                    setState(() {
                                      selectedSegment = newSelection.first;
                                      dev.log(
                                          "Selected Segment: $selectedSegment");
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
                              child: BlocBuilder<AssessmentInfoBloc,
                                  AssessmentInfoState>(
                                builder: (context, state) {
                                  if (state is AssessmentInfoLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive());
                                  } else if (state is AssessmentInfoLoaded) {
                                    final Map<String, dynamic> data =
                                        state.AssessmentInfoDataRec!;

                                    Map<String, dynamic> complaintsInfo =
                                        data["complaints"] ?? {};
                                    Map<String, dynamic> investigationsInfo =
                                        data["investigations"] ?? {};
                                    Map<String, dynamic> poorvaKarmaInfo =
                                        data["poorvaKarma"] ?? {};

                                    data.forEach((key, value) {
                                      dev.log("Key: $key, Value: $value");
                                    });
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (selectedSegment ==
                                                    AssessmentInfo
                                                        .patientInfo) ...[
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "UHID",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(
                                                        data["uhid"] ??
                                                            "UHID Unavailable"),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "Name",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(
                                                        data["name"] ??
                                                            "Name Unavailable"),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "Date of Birth",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(
                                                        data["DOB"] ??
                                                            "DOB Unavailable"),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "Occupations",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(data[
                                                            "occupation"] ??
                                                        "Occupation Unavailable"),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "Address",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(data[
                                                            "address"] ??
                                                        "Address Unavailable"),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "Past Illness",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(data[
                                                            "pastIllness"] ??
                                                        "Past Illness Unavailable"),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: AutoSizeText(
                                                      "Medical History",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff15400D),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: AutoSizeText(data[
                                                            "medicalHistory"] ??
                                                        "Medical History Unavailable"),
                                                  ),
                                                ] else if (selectedSegment ==
                                                    AssessmentInfo
                                                        .complaints) ...[
                                                  ...complaintsInfo.entries
                                                      .map((entry) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AutoSizeText(
                                                            convertSnakeToTitle(
                                                                entry.key
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xff15400D),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          AutoSizeText(
                                                              convertSnakeToTitle(
                                                                  entry.value
                                                                      .toString()))
                                                        ],
                                                      ),
                                                    );
                                                  })
                                                ] else if (selectedSegment ==
                                                    AssessmentInfo
                                                        .investigations) ...[
                                                  ...investigationsInfo.entries
                                                      .map((e) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                AutoSizeText(
                                                                  convertSnakeToTitle(e
                                                                      .key
                                                                      .toString()),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xff15400D),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                AutoSizeText(
                                                                    convertSnakeToTitle(e
                                                                        .value
                                                                        .toString()))
                                                              ],
                                                            ),
                                                          ))
                                                ] else if (selectedSegment ==
                                                    AssessmentInfo
                                                        .poorvaKarma) ...[
                                                  ...poorvaKarmaInfo.entries
                                                      .map((e) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                AutoSizeText(
                                                                  convertSnakeToTitle(e
                                                                      .key
                                                                      .toString()),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xff15400D),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                AutoSizeText(
                                                                    convertSnakeToTitle(e
                                                                        .value
                                                                        .toString()))
                                                              ],
                                                            ),
                                                          ))
                                                ]
                                              ]),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: Text("No Data Found"),
                                    );
                                  }
                                },
                              ),
                            )),
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
