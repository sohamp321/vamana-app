import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/assessment_info/assessment_info_page.dart';
import 'package:vamana_app/blood_pressure/blood_pressure_page.dart';
import 'package:vamana_app/chatushprakara_shuddhi/chatushprakara_shuddhi_page.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:vamana_app/pashchat_karma/pashchat_karma_page.dart';
import 'package:vamana_app/pradhankarma/pradhankarma_page.dart';
import 'package:vamana_app/rookshana/rookshana_page.dart';
import 'package:vamana_app/samsar_jana_krama/samsar_jana_krama_page.dart';
import 'package:vamana_app/sarvanga_lakshana/sarvanga_lakshana_page.dart';
import 'package:vamana_app/sneh_jeeryaman_lakshana/sneh_jeeryaman_lakshana_page.dart';
import 'package:vamana_app/snehana_lakshana/snehana_lakshana_page.dart';
import 'package:vamana_app/snehapana/snehapana_page.dart';
import 'package:vamana_app/snehpana_calculator/snehpana_page.dart';
import 'package:vamana_app/vega_nirikshana/vega_nirikshana_page.dart';
import 'package:vamana_app/yoga_lakshana/yoga_lakshana_page.dart';
import "dart:developer" as dev;

class VamanaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VamanaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.clear();

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout_rounded))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class VamanaDrawer extends StatefulWidget {
  String? selectedPage;
  VamanaDrawer({super.key, required this.selectedPage});

  @override
  State<VamanaDrawer> createState() => _VamanaDrawerState();
}

class _VamanaDrawerState extends State<VamanaDrawer> {
  String? userName;
  String? patientName;
  String? patientUhid;
  String? assessmentId;
  void getHeaderData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "Physician UserName";
      patientName = prefs.getString("patientName") ?? "Patient Name";
      assessmentId = prefs.getString("assessmentID") ?? "Assessment ID";
      patientUhid = prefs.getString("patientUhid") ?? "Patient UHID";
    });
  }

  @override
  void initState() {
    getHeaderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dev.log(widget.selectedPage ?? "null");
    return Drawer(
      backgroundColor: const Color(0xffcfe1b9),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff97a97c),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(userName ?? "User Name"),
                      const Spacer(),
                      AutoSizeText(patientName ?? "Patient Name"),
                      AutoSizeText(patientUhid ?? "Patient UHID"),
                      AutoSizeText(assessmentId ?? "Assessment ID")
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "Dashboard"
                ? Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Dashboard"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const DashBoardPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Dashboard"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const DashBoardPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "AssessmentInfo"
                ? Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Assessment Info"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const AssessmentInfoPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Assessment Info"),
                    onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const AssessmentInfoPage())));},
                  ),
          ),
          Divider(
              color: const Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: AutoSizeText(
              "Poorvakarma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "AamaLakshana",
              label: "Aama Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const AamaLakshanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "Rookshana",
              label: "Rookshana",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const RookshanaPage())));
              }),
          Divider(
              color: const Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: const AutoSizeText(
              "Snehapana",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SnehapanaCalculator",
              label: "Snehapana Calculator",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const SnehpanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SnehanaLakshana",
              label: "Snehana Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SnehanaLakshanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "Snehapana",
              label: "Snehpana",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const SnehapanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SnehJeeryamanLakshana",
              label: "Sneh Jeeryaman Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SnehJeeryamanLakshanaPage())));
              }),
          Divider(
              color: const Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: const AutoSizeText(
              "Vishrama Kala",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SarvangaLakshana",
              label: "Sarvanga Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SarvangaLakshanaPage())));
              }),
          Divider(
              color: const Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: const AutoSizeText(
              "Pradhan Karma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "PradhanKarma",
              label: "PradhanKarma",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const PradhanKarmaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "VegaNirikshana",
              label: "Vega Nirikshana and Nirnaya",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const VegaNirikshanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "BloodPressure",
              label: "Blood Pressure",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const BloodPressurePage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "YogaLakshana",
              label: "Yoga Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const YogaLakshanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "ChatushPrakaraShuddhi",
              label: "Chatush Prakara Shuddhi",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ChatushprakaraShuddhiPage())));
              }),
          Divider(
              color: const Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: const AutoSizeText(
              "Paschat Karma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SamsarJanaKrama",
              label: "Samsarjana Krama",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const SamsarKramaPage())));
              }),
          VamanaDrawerTile(
            selectedPage: widget.selectedPage,
            toCheck: "PashchatKarma",
            label: "Pashchat Karma",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const PashchatKarmaPage())));
            },
          ),
        ],
      ),
    );
  }
}

class VamanaDrawerTile extends StatefulWidget {
  String? selectedPage;
  String toCheck;
  String label;

  VoidCallback onPressed;

  VamanaDrawerTile(
      {super.key,
      required this.selectedPage,
      required this.toCheck,
      required this.label,
      required this.onPressed});

  @override
  State<VamanaDrawerTile> createState() => _VamanaDrawerTileState();
}

class _VamanaDrawerTileState extends State<VamanaDrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.selectedPage == widget.toCheck
          ? Container(
              decoration: BoxDecoration(
                  color: const Color(0xffb5c99a),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(widget.label),
                onTap: widget.onPressed,
              ),
            )
          : ListTile(
              title: Text(widget.label),
              onTap: widget.onPressed,
            ),
    );
  }
}
