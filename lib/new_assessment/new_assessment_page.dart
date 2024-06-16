import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "package:carousel_slider/carousel_slider.dart";
import "dart:developer" as dev;

class NewAssessmentPage extends StatefulWidget {
  const NewAssessmentPage({super.key});

  @override
  State<NewAssessmentPage> createState() => _NewAssessmentPageState();
}

class _NewAssessmentPageState extends State<NewAssessmentPage> {
  final CarouselController _carouselController = CarouselController();
  int currentIndex = 0;

  //State 1 : Patient Detials Form
  final GlobalKey<FormState> patientDetailsKey = GlobalKey<FormState>();

  final Map<String, Map<String, dynamic>> patientData = {
    'UHID': {'controller': TextEditingController(), "errorText": "UHID"},
    'Name': {'controller': TextEditingController(), "errorText": "Name"},
    'Date of Birth': {
      'controller': TextEditingController(),
      "errorText": "Date of Birth"
    },
    'Occupation': {
      'controller': TextEditingController(),
      "errorText": "Occupation"
    },
    'Address': {'controller': TextEditingController(), "errorText": "Address"},
    'Past Illness': {
      'controller': TextEditingController(),
      "errorText": "Past Illness"
    },
    'Medical History': {
      'controller': TextEditingController(),
      "errorText": "Medical History"
    },
  };

  //State 2: Complaints(Bahudosh)
  int complaintsCount = 0;

  final Map<String, bool?> complaints = {
    "Avipaka(Indigestion)": null,
    "Trishna(Feeling thirsty)": null,
    "Aruchi(Anorexia)": null,
    "Gauravam(Heaviness)": null,
    "Aalasya(Laziness)": null,
    "Nidranaasha(Sleeplessness)": null,
    "Atinidrata(excessive sleep)": null,
    "Ashasta-swapna-darshanam (Abnormal dreams)": null,
    "Tandra (somnolent/feeling sleepy)": null,
    "Shrama (Breathlessnesswhile exertion)": null,
    "Daurbalayam (Weakness)": null,
    "Klamah (Fatigue)": null,
    "Sthaulyam (Obesity)": null,
    "Pitta-samutklesha (Vitiated Pitta Features)": null,
    "Shleshma-samutklesha (Vitiated Kapha Features)": null,
    "Panduta (Anaemic)": null,
    "Kandu (Itching)": null,
    "Pidka,Kotha (Skin eruptions)": null,
    "Daurgandhyatvam (Foul smell from sweat, stool, urine etc.)": null,
    "Arati (Disturbed mind)": null,
    "Avasadaka (Depressed Mind)": null,
    "Bala-pranasha/ Brumhanairapi (Loss of physical strength even after taking good diet)":
        null,
    "Varna-pranasha (Loss of glow)": null,
    "Abudhitvam (absent mindedness)": null,
    "Klaibyam (Lost Vitality)": null,
  };

  //State 3: Investigations
  final GlobalKey<FormState> investigationsKey = GlobalKey<FormState>();

  final Map<String, Map<String, dynamic>> investigationsData = {
    'Haemoglobin': {
      'controller': TextEditingController(),
      'errorText': 'Haemoglobin'
    },
    'RBC': {'controller': TextEditingController(), 'errorText': 'RBC'},
    'Platelet Count': {
      'controller': TextEditingController(),
      'errorText': 'Platelet Count'
    },
    'ESR': {'controller': TextEditingController(), 'errorText': 'ESR'},
    'TLC': {'controller': TextEditingController(), 'errorText': 'TLC'},
    'HbA1C': {'controller': TextEditingController(), 'errorText': 'HbA1C'},
    'AEC': {'controller': TextEditingController(), 'errorText': 'AEC'},
    'CRP': {'controller': TextEditingController(), 'errorText': 'CRP'},
    'Total Cholestrol': {
      'controller': TextEditingController(),
      'errorText': 'Total Cholestrol'
    },
    'SGOT': {'controller': TextEditingController(), 'errorText': 'SGOT'},
    'SGPT': {'controller': TextEditingController(), 'errorText': 'SGPT'},
    'Total Bilirubin': {
      'controller': TextEditingController(),
      'errorText': 'Total Bilirubin'
    },
    'ECG': {'controller': TextEditingController(), 'errorText': 'ECG'},
    'USG': {'controller': TextEditingController(), 'errorText': 'USG'},
    'X-Ray': {'controller': TextEditingController(), 'errorText': 'X-Ray'},
  };

  //State 4: Deepana Pachana
  bool guduchiChoornaSelected = false;
  bool mustaChoornaSelected = false;
  bool panchakolChoornaSelected = false;

  final TextEditingController otherDeepanaPachana = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<Widget> formWidgets = [
      PatientDetailsForm(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        patientDetailsKey: patientDetailsKey,
        fieldData: patientData,
      ),
      Complaints(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        complaintsMap: complaints,
        complaintsCount: complaintsCount,
      ),
      Investigations(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        investigationsKey: investigationsKey,
        fieldData: investigationsData,
      ),
      DeepanaPachana(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        guduchiChoornaSelected: guduchiChoornaSelected,
        mustaChoornaSelected: mustaChoornaSelected,
        panchakolChoornaSelected: panchakolChoornaSelected,
        otherDeepanaPachana: otherDeepanaPachana,
      ),
    ];

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: [
          Image.asset(
            "assets/images/bg1.jpg",
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: screenHeight * 0.175,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Create New Assessment",
                      style: TextStyle(
                          color: Color(0xff15400D),
                          fontWeight: FontWeight.w900,
                          fontSize: 30),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffcfe1b9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.75,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: screenHeight * 0.01,
                          width: screenWidth * 0.93,
                          child: LinearProgressIndicator(
                            value: (currentIndex + 1) / formWidgets.length,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: const Color(0xffe9f5db),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CarouselSlider(
                          items: formWidgets,
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: screenHeight * 0.65,
                            enableInfiniteScroll: false,
                            viewportFraction: 1.0,
                            disableCenter: true,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                      // ! Update This On Next Press
                      // ? State 1 : Fill Patient Details
                      // PatientDetailsForm(
                      //     screenWidth: screenWidth,
                      //     screenHeight: screenHeight,
                      //     patientDetailsKey: patientDetailsKey,
                      //     fieldData: patientData),
                      // ? State 2 : Fill Complaints
                      // Complaints(
                      //     screenWidth: screenWidth,
                      //     screenHeight: screenHeight,
                      //     complaintsMap: complaints,
                      //     complaintsCount: complaintsCount),
                      // ? State 3 : Fill Investigations
                      // Investigations(
                      //     screenWidth: screenWidth,
                      //     screenHeight: screenHeight,
                      //     investigationsKey: investigationsKey,
                      //     fieldData: investigationsData),
                      // ? State 4 : Select Deselect Buttons
                      // DeepanaPachana(
                      //     screenWidth: screenWidth,
                      //     screenHeight: screenHeight,
                      //     guduchiChoornaSelected: guduchiChoornaSelected,
                      //     mustaChoornaSelected: mustaChoornaSelected,
                      //     panchakolChoornaSelected: panchakolChoornaSelected,
                      //     otherDeepanaPachana: otherDeepanaPachana),
                      // ! Update This On Next Press
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xff0f6f03))),
                                onPressed: () {
                                  _carouselController.previousPage();
                                  print(complaints);
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Back",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                            const Spacer(),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xff0f6f03))),
                                onPressed: () {
                                  _carouselController.nextPage();
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Next",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                )
              ],
            ),
          )
        ]));
  }
}

class DeepanaPachana extends StatelessWidget {
  const DeepanaPachana({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.guduchiChoornaSelected,
    required this.mustaChoornaSelected,
    required this.panchakolChoornaSelected,
    required this.otherDeepanaPachana,
  });

  final double screenWidth;
  final double screenHeight;
  final bool guduchiChoornaSelected;
  final bool mustaChoornaSelected;
  final bool panchakolChoornaSelected;
  final TextEditingController otherDeepanaPachana;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth * 0.93,
        height: screenHeight * 0.65,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Poorva Karma",
                    style: TextStyle(
                        color: Color(0xff15400d),
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Deepana Pachana",
                    style: TextStyle(
                        color: Color(0xff15400d),
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SelectionButton(
                  selectionState: guduchiChoornaSelected,
                  buttonName: "Guduchi Choorna"),
              SelectionButton(
                  selectionState: mustaChoornaSelected,
                  buttonName: "Musta Choorna"),
              SelectionButton(
                  selectionState: panchakolChoornaSelected,
                  buttonName: "Pancha Kol Churna"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: otherDeepanaPachana,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Other"),
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
        ]));
  }
}

// CODE COMPONENTS MAY BE TRANSFERRED TO A DIFFERENT FILE //
class CustomFormField extends StatelessWidget {
  CustomFormField(
      {super.key,
      required this.fieldController,
      required this.labelText,
      required this.errorText});

  final TextEditingController fieldController;
  String labelText;
  String errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: fieldController,
        decoration: InputDecoration(
            label: Text(labelText), border: const OutlineInputBorder()),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $errorText';
          }
          return null;
        },
      ),
    );
  }
}

class PatientDetailsForm extends StatelessWidget {
  const PatientDetailsForm({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.patientDetailsKey,
    required this.fieldData,
  });

  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> patientDetailsKey;
  final Map<String, Map<String, dynamic>> fieldData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.93,
      height: screenHeight * 0.65,
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Patient Details",
                style: TextStyle(
                    color: Color(0xff15400d),
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Form(
                key: patientDetailsKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: fieldData.entries.map((entry) {
                        return CustomFormField(
                            fieldController: entry.value["controller"],
                            labelText: entry.key,
                            errorText: entry.value['errorText']);
                      }).toList(),
                    ),
                  ),
                )),
          ),
          // ! Remove This Add to next button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (patientDetailsKey.currentState?.validate() ?? false) {
                  final Map<String, String> formData = {};

                  fieldData.forEach((label, data) {
                    formData[label] = data['controller'].text;

                    data["controller"].clear();
                  });

                  print(formData);

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Form Data'),
                      content: Text(formData.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text(
                  'Submit Button -> To Be Added to Next Without Dialogue'),
            ),
          )
        ],
      ),
    );
  }
}

class Investigations extends StatelessWidget {
  Investigations(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.investigationsKey,
      required this.fieldData});

  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> investigationsKey;
  final Map<String, Map<String, dynamic>> fieldData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.93,
      height: screenHeight * 0.65,
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Investigations",
                style: TextStyle(
                    color: Color(0xff15400d),
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Form(
                key: investigationsKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: fieldData.entries.map((entry) {
                        return CustomFormField(
                            fieldController: entry.value["controller"],
                            labelText: entry.key,
                            errorText: entry.value['errorText']);
                      }).toList(),
                    ),
                  ),
                )),
          ),
          // ! Remove This -> Add To Next Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (investigationsKey.currentState?.validate() ?? false) {
                  final Map<String, String> formData = {};

                  fieldData.forEach((label, data) {
                    formData[label] = data['controller'].text;

                    data["controller"].clear();
                  });

                  print(formData);

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Form Data'),
                      content: Text(formData.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text(
                  'Submit Button -> To Be Added to Next Without Dialogue'),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionButton extends StatefulWidget {
  bool selectionState;
  String buttonName;

  SelectionButton({required this.selectionState, required this.buttonName});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                widget.selectionState
                    ? const Color(0xff0f6f03)
                    : Theme.of(context).colorScheme.primaryContainer)),
        onPressed: () {
          setState(() {
            widget.selectionState = !widget.selectionState;
          });
        },
        child: Text(
          widget.buttonName,
          style: TextStyle(
              color: widget.selectionState
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class ComplaintsRow extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String label;
  bool? isSelected;
  int complaintsCount;
  VoidCallback onCheckPressed;
  VoidCallback onCrossPressed;

  ComplaintsRow({
    required this.screenWidth,
    required this.screenHeight,
    required this.label,
    required this.isSelected,
    required this.complaintsCount,
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
            width: widget.screenWidth * 0.6,
            height: widget.screenHeight * 0.05,
            decoration: const BoxDecoration(
              color: Color(0xff97a97c),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: widget.screenWidth * 0.1475,
            height: widget.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: widget.isSelected == true
                  ? Colors.green.withOpacity(0.5)
                  : Color(0xffe9f5db),
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
            width: widget.screenWidth * 0.1475,
            height: widget.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: widget.isSelected == false
                  ? Colors.red.withOpacity(0.5)
                  : Color(0xffe9f5db),
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

class Complaints extends StatefulWidget {
  Complaints(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.complaintsMap,
      required this.complaintsCount});

  final double screenWidth;
  final double screenHeight;
  final Map<String, bool?> complaintsMap;
  int complaintsCount;
  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  void updateSelection(String label, bool? isSelected) {
    setState(() {
      bool? previousSelection = widget.complaintsMap[label];

      if (previousSelection != isSelected) {
        if ((previousSelection == null || previousSelection == false) &&
            isSelected == true &&
            widget.complaintsCount < 25) {
          widget.complaintsCount++;
        } else if (previousSelection == true &&
            isSelected == false &&
            widget.complaintsCount > 0) {
          widget.complaintsCount--;
        }

        widget.complaintsMap[label] = isSelected;
      }
      print(widget.complaintsCount);
      print(widget.complaintsMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.screenWidth * 0.93,
        height: widget.screenHeight * 0.65,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Complaints (Bahudosh)",
                style: TextStyle(
                    color: Color(0xff15400d),
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            width: widget.screenWidth * 0.9,
            height: widget.screenHeight * 0.575,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: widget.complaintsMap.keys.map((complaint) {
                  return ComplaintsRow(
                    screenWidth: widget.screenWidth,
                    screenHeight: widget.screenHeight,
                    label: complaint,
                    isSelected: widget.complaintsMap[complaint],
                    complaintsCount: widget.complaintsCount,
                    onCheckPressed: () {
                      if (widget.complaintsMap[complaint] != true &&
                          widget.complaintsCount < 25) {
                        updateSelection(complaint, true);
                      }
                    },
                    onCrossPressed: () {
                      if (widget.complaintsMap[complaint] != false &&
                          widget.complaintsCount > 0) {
                        updateSelection(complaint, false);
                      }
                    },
                  );
                }).toList(),
              ),
            )),
          ),
          Text(" ${widget.complaintsCount} / 25 Factors present")
        ]));
  }
}
