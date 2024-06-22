import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/blood_pressure/blood_pressure_page.dart';
import 'package:vamana_app/chatushprakara_shuddhi/chatushprakara_shuddhi_page.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:vamana_app/pashchat_karma/pashchat_karma_page.dart';
import 'package:vamana_app/pradhankarma/pradhankarma_page.dart';
import 'package:vamana_app/rookshana/rookshana_page.dart';
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
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
  @override
  Widget build(BuildContext context) {
    dev.log(widget.selectedPage ?? "null");
    return Drawer(
      backgroundColor: Color(0xffcfe1b9),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff97a97c),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText("Physician Name"),
                      Spacer(),
                      AutoSizeText("Patient Name"),
                      AutoSizeText("Patient UHID"),
                      AutoSizeText("Assessment ID")
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "Dashboard"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Dashboard"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => DashBoardPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Dashboard"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => DashBoardPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "AssessmentInfo"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Assessment Info"),
                      onTap: () {},
                    ),
                  )
                : ListTile(
                    title: const Text("Assessment Info"),
                    onTap: () {},
                  ),
          ),
          Divider(
              color: Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: AutoSizeText(
              "Poorvakarma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),

          VamanaDrawerTile(selectedPage: widget.selectedPage, toCheck: "AamaLakshana", label: "Aama Lakshana", onPressed:() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => AamaLakshanaPage())));
          }),

          VamanaDrawerTile(selectedPage: widget.selectedPage, toCheck: "Rookshana", label: "Rookshana", onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => RookshanaPage())));
          }),

          Divider(
              color: Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: AutoSizeText(
              "Snehapana",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(selectedPage: widget.selectedPage, toCheck: "SnehapanaCalculator", label: "Snehapana Calculator", onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => SnehpanaPage())));
          }),

          VamanaDrawerTile(selectedPage: widget.selectedPage, toCheck: "SnehanaLakshana", label: "Snehana Lakshana", onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => SnehanaLakshanaPage())));
          } ),

          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "Snehapana",
              label: "Snehpana",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => SnehapanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SnehJeeryamanLakshana",
              label: "Sneh Jeeryaman Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SnehJeeryamanLakshanaPage())));
              }),
          Divider(
              color: Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: AutoSizeText(
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
                        builder: ((context) => SarvangaLakshanaPage())));
              }),
          Divider(
              color: Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: AutoSizeText(
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
                        builder: ((context) => PradhanKarmaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "VegaNirikshana",
              label: "Vega Nirikshana and Nirnaya",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => VegaNirikshanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "BloodPressure",
              label: "Blood Pressure",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => BloodPressurePage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "YogaLakshana",
              label: "Yoga Lakshana",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => YogaLakshanaPage())));
              }),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "ChatushPrakaraShuddhi",
              label: "Chatush Prakara Shuddhi",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ChatushprakaraShuddhiPage())));
              }),
          Divider(
              color: Color(0xff15400d),
              endIndent: MediaQuery.of(context).size.width * 0.05,
              indent: MediaQuery.of(context).size.width * 0.05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: AutoSizeText(
              "Paschat Karma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          VamanaDrawerTile(
              selectedPage: widget.selectedPage,
              toCheck: "SamsarjanaKrama",
              label: "Samsarjana Krama",
              onPressed: () {}),
          VamanaDrawerTile(
            selectedPage: widget.selectedPage,
            toCheck: "PashchatKarma",
            label: "Pashchat Karma",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => PashchatKarmaPage())));
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
                  color: Color(0xffb5c99a),
                  borderRadius: BorderRadius.circular(30)),
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
