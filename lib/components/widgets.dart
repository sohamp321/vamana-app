import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
                borderRadius: BorderRadius.circular(20),),
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
          const Center(
            child: AutoSizeText(
              "Poorvakarma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "AamaLakshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Aama Lakshana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AamaLakshanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Aama Lakshana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AamaLakshanaPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "Rookshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Rookshana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => RookshanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Rookshana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => RookshanaPage())));
                    },
                  ),
          ),
          const Center(
            child: AutoSizeText(
              "Snehapana",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "SnehapanaCalculator"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Snehapana Calculator"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SnehpanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Snehapana Calculator"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SnehpanaPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "SnehanaLakshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Snehana Lakshana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SnehanaLakshanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Snehana Lakshana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SnehanaLakshanaPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "Snehapana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Snehpana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SnehapanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Snehpana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SnehapanaPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "SnehJeeryamanLakshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Sneha Jeeryaman Lakshana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    SnehJeeryamanLakshanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Sneha Jeeryaman Lakshana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  SnehJeeryamanLakshanaPage())));
                    },
                  ),
          ),
          const Center(
            child: AutoSizeText(
              "Vishrama Kala",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "SarvangaLakshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Sarvanga Lakshana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    SarvangaLakshanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Sarvanga Lakshana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SarvangaLakshanaPage())));
                    },
                  ),
          ),
          const Center(
            child: AutoSizeText(
              "Pradhan Karma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "PradhanKarma"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Pradhankarma"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => PradhanKarmaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Pradhankarma"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PradhanKarmaPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "VegaNirikshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Vega Nirikshana and Nirnaya"),
                      onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    VegaNirikshanaPage())));},
                    ),
                  )
                : ListTile(
                    title: const Text("Vega Nirikshana and Nirnaya"),
                    onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    VegaNirikshanaPage())));},
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "BloodPressure"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Blood Pressure"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => BloodPressurePage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Blood Pressure"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => BloodPressurePage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "YogaLakshana"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Yoga Lakshana"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => YogaLakshanaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Yoga Lakshana"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => YogaLakshanaPage())));
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "ChatushPrakaraShuddhi"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Chatush Prakara Shuddhi"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    ChatushprakaraShuddhiPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Chatush Prakara Shuddhi"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  ChatushprakaraShuddhiPage())));
                    },
                  ),
          ),
          const Center(
            child: AutoSizeText(
              "Paschat Karma",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff15400D)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "SamsarjanaKrama"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Samsarjana Krama"),
                      onTap: () {},
                    ),
                  )
                : ListTile(
                    title: const Text("Samsarjana Krama"),
                    onTap: () {},
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.selectedPage == "PashchatKarma"
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xffb5c99a),
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      title: const Text("Pashchat Karma"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => PashchatKarmaPage())));
                      },
                    ),
                  )
                : ListTile(
                    title: const Text("Pashchat Karma"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PashchatKarmaPage())));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
