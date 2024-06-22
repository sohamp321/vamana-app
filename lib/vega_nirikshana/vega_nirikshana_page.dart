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
import 'vega_nirikshana_bloc/vega_nirikshana_bloc.dart';
import 'package:vamana_app/login/login_page.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'vega_nirikshana_bloc/vega_nirikshana_event.dart';
import 'vega_nirikshana_bloc/vega_nirikshana_state.dart';

class VegaNirikshanaPage extends StatefulWidget {
  const VegaNirikshanaPage({super.key});

  @override
  State<VegaNirikshanaPage> createState() => _VegaNirikshanaPageState();
}

enum Entries {
  entry1(entryNumber: "1"),
  entry2(entryNumber: "2"),
  entry3(entryNumber: "3"),
  entry4(entryNumber: "4"),
  entry5(entryNumber: "5"),
  entry6(entryNumber: "6"),
  entry7(entryNumber: "7"),
  entry8(entryNumber: "8"),
  entry9(entryNumber: "9"),
  entry10(entryNumber: "10"),
  entry11(entryNumber: "11"),
  entry12(entryNumber: "12"),
  entry13(entryNumber: "13"),
  entry14(entryNumber: "14"),
  entry15(entryNumber: "15"),
  entry16(entryNumber: "16"),
  entry17(entryNumber: "17"),
  entry18(entryNumber: "18"),
  entry19(entryNumber: "19"),
  entry20(entryNumber: "20"),
  entry21(entryNumber: "21"),
  entry22(entryNumber: "22"),
  entry23(entryNumber: "23"),
  entry24(entryNumber: "24");

  final String entryNumber;
  const Entries({required this.entryNumber});
}

class _VegaNirikshanaPageState extends State<VegaNirikshanaPage> {
  void getAVegaNirikshana() async {
    BlocProvider.of<VegaNirikshanaBloc>(context)
        .add(GetVegaNirikshana(dayNumber: selectedEntry.entryNumber));
  }

  @override
  void initState() {
    BlocProvider.of<VegaNirikshanaBloc>(context).add(Day0VegaNirikshana());
    BlocProvider.of<VegaNirikshanaBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAVegaNirikshana();
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

  String? selectedInput;
  double inputValue = 1;
  double vegaValue = 1;
  double upvegaValue = 1;
  String? observations;
  final TextEditingController otherController = TextEditingController();
  final TextEditingController outputController = TextEditingController();

  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

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
          selectedPage: "VegaNirikshana",
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<VegaNirikshanaBloc, VegaNirikshanaState>(
              listener: (context, state) {
                if (state is VegaNirikshanaLoaded) {
                  if (state.VegaNirikshanaDataRec != null) {
                    setState(() {
                      selectedDate = state.VegaNirikshanaDataRec!["date"];
                    });

                    state.VegaNirikshanaDataRec!.forEach((key, value) {
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
                  } else {
                    selectedInput = null;
                    inputValue = 1;
                    vegaValue = 1;
                    upvegaValue = 1;
                    observations = null;
                    otherController.clear();
                    outputController.clear();
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
                            "Vega Nirikshana and Nirnaya",
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
                                    segments: Entries.values
                                        .map((entry) => ButtonSegment<Entries>(
                                            value: entry,
                                            label: Text(entry.entryNumber)))
                                        .toList(),
                                    selected: <Entries>{selectedEntry},
                                    onSelectionChanged:
                                        (Set<Entries> newSelection) {
                                      setState(() {
                                        selectedEntry = newSelection.first;
                                        selectedInput = null;
                                        inputValue = 1;
                                        vegaValue = 1;
                                        upvegaValue = 1;
                                        observations = null;
                                        otherController.clear();
                                        outputController.clear();
                                        getAVegaNirikshana();
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
                                child: BlocBuilder<VegaNirikshanaBloc,
                                    VegaNirikshanaState>(
                                  builder: (context, state) {
                                    if (state is VegaNirikshanaLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    }
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Column(children: [
                                            const AutoSizeText(
                                              "No. Of Glasses Taken (INPUT)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400d)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DropdownButtonFormField<
                                                      String>(
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
                                                  value: selectedInput,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: "madhuyashtiPhanta",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Madhuyashti Phanta",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    const DropdownMenuItem(
                                                        value: "lavanodaka",
                                                        child: AutoSizeText(
                                                            "Lavanodaka")),
                                                  ],
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      selectedInput = newValue;
                                                    });
                                                  }),
                                            ),
                                            AutoSizeText(
                                                inputValue.toInt().toString()),
                                            Slider(
                                                min: 1,
                                                max: 25,
                                                divisions: 24,
                                                value: inputValue,
                                                label:
                                                    inputValue.toInt().toString(),
                                                onChanged: (double value) {
                                                  selectedInput != null
                                                      ? setState(() {
                                                          inputValue = value;
                                                        })
                                                      : null;
                                                }),
                                            const AutoSizeText(
                                              "No. Of Vega",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400D)),
                                            ),
                                            AutoSizeText(
                                                vegaValue.toInt().toString()),
                                            Slider(
                                                min: 1,
                                                max: 8,
                                                divisions: 7,
                                                value: vegaValue,
                                                label:
                                                    vegaValue.toInt().toString(),
                                                onChanged: (double value) {
                                                  setState(() {
                                                    vegaValue = value;
                                                  });
                                                }),
                                            const AutoSizeText(
                                              "No. Of Upavega",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400D)),
                                            ),
                                            AutoSizeText(
                                                upvegaValue.toInt().toString()),
                                            Slider(
                                                min: 1,
                                                max: 20,
                                                divisions: 19,
                                                value: upvegaValue,
                                                label: upvegaValue
                                                    .toInt()
                                                    .toString(),
                                                onChanged: (double value) {
                                                  setState(() {
                                                    upvegaValue = value;
                                                  });
                                                }),
                                            const AutoSizeText(
                                              "Observations",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400D)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DropdownButtonFormField<
                                                      String>(
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
                                                  value: observations,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: "milkYavagu",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Milk Yavagu",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "kapha",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Kapha",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "pitta",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Pitta",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "aushadha",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Aushadha",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "madhuyashtiPhanta",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Madhuyashti Phanta",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "lavanodaka",
                                                      child: SizedBox(
                                                        width: screenWidth * 0.7,
                                                        child: const AutoSizeText(
                                                          "Lavanodaka",
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      observations = newValue;
                                                    });
                                                  }),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: otherController,
                                                decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    label: Text("Others")),
                                              ),
                                            ),
                                            const AutoSizeText(
                                              "Output",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400D)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: outputController,
                                                decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    label: Text("Output")),
                                              ),
                                            ),
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
                                    BlocConsumer<VegaNirikshanaBloc,
                                        VegaNirikshanaState>(
                                      listener: (context, state) {
                                        if (state is VegaNirikshanaError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Error Occured: ${state.error}")));
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is CreatingVegaNirikshana) {
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
                                                "assessmentName":
                                                    "VegaNirikshana",
                                                "day": selectedEntry.entryNumber,
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
                                              BlocProvider.of<VegaNirikshanaBloc>(
                                                      context)
                                                  .add(CreateVegaNirikshana(
                                                      VegaNirikshanaData:
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
