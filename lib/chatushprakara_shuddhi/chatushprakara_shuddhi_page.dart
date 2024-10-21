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
import 'chatushprakara_shuddhi_bloc/chatushprakara_shuddhi_bloc.dart';
import 'chatushprakara_shuddhi_bloc/chatushprakara_shuddhi_event.dart';
import 'chatushprakara_shuddhi_bloc/chatushprakara_shuddhi_state.dart';

class ChatushprakaraShuddhiPage extends StatefulWidget {
  const ChatushprakaraShuddhiPage({super.key});

  @override
  State<ChatushprakaraShuddhiPage> createState() =>
      _ChatushprakaraShuddhiPageState();
}

class _ChatushprakaraShuddhiPageState extends State<ChatushprakaraShuddhiPage> {
  void getAChatushprakaraShuddhi() async {
    BlocProvider.of<ChatushprakaraShuddhiBloc>(context)
        .add(GetChatushprakaraShuddhi(dayNumber: "1"));
  }

  @override
  void initState() {
    BlocProvider.of<ChatushprakaraShuddhiBloc>(context)
        .add(Day0ChatushprakaraShuddhi());
    BlocProvider.of<ChatushprakaraShuddhiBloc>(context).stream.listen((state) {
      dev.log('Current state: $state');
    });
    getAChatushprakaraShuddhi();
    super.initState();
  }

  String? selectedAntikiShuddhi;
  String? selectedLaingikiShuddhi;
  String? selectedVaigikiShuddhi;
  double vaigikiShuddhi = 1.0;
  double manikiShuddhi = 0.0;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: const VamanaAppBar(),
        drawer: VamanaDrawer(
          selectedPage: "ChatushPrakaraShuddhi",
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            BlocListener<ChatushprakaraShuddhiBloc, ChatushprakaraShuddhiState>(
              listener: (context, state) {
                if (state is ChatushprakaraShuddhiLoaded) {
                  if (state.ChatushprakaraShuddhiDataRec != null) {
                    setState(() {
                      state.ChatushprakaraShuddhiDataRec!.forEach((key, value) {
                        if (key == "antikiShuddhi") {
                          selectedAntikiShuddhi = value;
                        } else if (key == "laingikiShuddhi") {
                          selectedLaingikiShuddhi = value;
                        } else if (key == "manikiShuddhi") {
                          manikiShuddhi = value;
                        } else if (key == "manikiShuddhiText") {
                          _controller.text = value;
                        } else {
                          selectedVaigikiShuddhi = value["selection"];
                          vaigikiShuddhi = value["value"];
                        }
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
                      SizedBox(height: screenHeight * 0.195),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: AutoSizeText(
                            "Chatush Prakara Shuddhi",
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
                              SizedBox(height: screenHeight * 0.01),
                              SingleChildScrollView(
                                  child: Container(
                                height: screenHeight * 0.5,
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                    // color: const Color(0xffb5c99a),
                                    borderRadius: BorderRadius.circular(20)),
                                child: BlocBuilder<ChatushprakaraShuddhiBloc,
                                    ChatushprakaraShuddhiState>(
                                  builder: (context, state) {
                                    if (state is ChatushprakaraShuddhiLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    }
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: Column(children: [
                                            const AutoSizeText(
                                              "Antiki Shuddhi",
                                              minFontSize: 15,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400d)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                  value: selectedAntikiShuddhi,
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value:
                                                          "Aushadha without Kapha Cheda",
                                                      child: AutoSizeText(
                                                        "Aushadha without Kapha Cheda",
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                        value:
                                                            "Aushadha with Kapha Cheda",
                                                        child: AutoSizeText(
                                                            "Aushadha with Kapha Cheda")),
                                                    DropdownMenuItem(
                                                        value: "Kapha Cheda",
                                                        child: AutoSizeText(
                                                            "Kapha Cheda")),
                                                    DropdownMenuItem(
                                                        value: "Pitta Darshana",
                                                        child: AutoSizeText(
                                                            "Pitta Darshana")),
                                                    DropdownMenuItem(
                                                        value: "Pittanta",
                                                        child: AutoSizeText(
                                                            "Pittanta")),
                                                  ],
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedAntikiShuddhi =
                                                          newValue;
                                                    });
                                                  }),
                                            ),
                                            const AutoSizeText(
                                              "Laingiki Shuddhi",
                                              minFontSize: 15,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400d)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                  value:
                                                      selectedLaingikiShuddhi,
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value:
                                                          "Expulsion of Kapha Pitta Vata in a sequence",
                                                      child: AutoSizeText(
                                                        "Expulsion of Kapha Pitta Vata in a sequence",
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                        value: "Clear Channels",
                                                        child: AutoSizeText(
                                                            "Clear Channels")),
                                                    DropdownMenuItem(
                                                        value: "Lightness",
                                                        child: AutoSizeText(
                                                            "Lightness")),
                                                    DropdownMenuItem(
                                                        value: "All",
                                                        child:
                                                            AutoSizeText("All"))
                                                  ],
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedLaingikiShuddhi =
                                                          newValue;
                                                    });
                                                  }),
                                            ),
                                            const AutoSizeText(
                                              "Vaigiki Shuddhi",
                                              minFontSize: 15,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400d)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                  value: selectedVaigikiShuddhi,
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: "Between 1 to 8",
                                                      child: AutoSizeText(
                                                        "Between 1 to 8",
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                        value: "More than 8",
                                                        child: AutoSizeText(
                                                            "More Than 8")),
                                                  ],
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedVaigikiShuddhi =
                                                          newValue;

                                                      if (newValue ==
                                                          "Between 1 to 8") {
                                                        vaigikiShuddhi = 1.0;
                                                      }
                                                    });
                                                  }),
                                            ),
                                            Visibility(
                                              visible: selectedVaigikiShuddhi ==
                                                  "Between 1 to 8",
                                              child: Column(
                                                children: [
                                                  AutoSizeText(
                                                    '${vaigikiShuddhi.toInt()}',
                                                  ),
                                                  Slider(
                                                      value: vaigikiShuddhi,
                                                      min: 1,
                                                      max: 8,
                                                      label: vaigikiShuddhi
                                                          .toInt()
                                                          .toString(),
                                                      divisions: 7,
                                                      onChanged:
                                                          (double value) {
                                                        setState(() {
                                                          vaigikiShuddhi =
                                                              value;
                                                        });
                                                      }),
                                                ],
                                              ),
                                            ),
                                            const AutoSizeText(
                                              "Maniki Shuddhi",
                                              minFontSize: 15,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff15400d)),
                                            ),
                                            AutoSizeText(
                                              '${manikiShuddhi.toInt()}',
                                            ),
                                            Slider(
                                                min: 0,
                                                max: 20,
                                                label: manikiShuddhi
                                                    .toInt()
                                                    .toString(),
                                                divisions: 20,
                                                value: manikiShuddhi,
                                                onChanged: (double value) {
                                                  setState(() {
                                                    manikiShuddhi = value;
                                                  });
                                                }),
                                            TextField(
                                              controller: _controller,
                                              decoration: const InputDecoration(
                                                  labelText: "Enter Text",
                                                  border: OutlineInputBorder()),
                                            )
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
                                    BlocConsumer<ChatushprakaraShuddhiBloc,
                                        ChatushprakaraShuddhiState>(
                                      listener: (context, state) {
                                        if (state
                                            is ChatushprakaraShuddhiError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Error Occured: ${state.error}")));
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state
                                            is CreatingChatushprakaraShuddhi) {
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
                                                    "ChatushprakaraShuddhi",
                                                "day": "1",
                                                "id": assessmentID,
                                                "data": {
                                                  "antikiShuddhi":
                                                      selectedAntikiShuddhi,
                                                  "vaigikiShuddhi": {
                                                    "selection":
                                                        selectedVaigikiShuddhi,
                                                    "value": vaigikiShuddhi
                                                  },
                                                  "laingikiShuddhi":
                                                      selectedLaingikiShuddhi,
                                                  "manikiShuddhi":
                                                      manikiShuddhi,
                                                  "manikiShuddhiText":
                                                      _controller.text
                                                }
                                              };
                                              dev.log(state.toString());
                                              BlocProvider.of<
                                                          ChatushprakaraShuddhiBloc>(
                                                      context)
                                                  .add(CreateChatushprakaraShuddhi(
                                                      ChatushprakaraShuddhiData:
                                                          aamaLakshanReq));

                                              _controller.clear();
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
