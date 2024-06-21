import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:vamana_app/rookshana/rookshana_page.dart';
import 'package:vamana_app/sarvanga_lakshana/sarvanga_lakshana_page.dart';
import 'package:vamana_app/sneh_jeeryaman_lakshana/sneh_jeeryaman_lakshana_page.dart';
import 'package:vamana_app/snehpana_calculator/snehpana_page.dart';
import 'package:vamana_app/yoga_lakshana/yoga_lakshana_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}

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
  const VamanaDrawer({super.key});

  @override
  State<VamanaDrawer> createState() => _VamanaDrawerState();
}

class _VamanaDrawerState extends State<VamanaDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xffcfe1b9),
      child: ListView(
        children: [
          DrawerHeader(child: Center(child: Text("Vamana App"))),
          ListTile(
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => DashBoardPage())));
            },
          ),
          ListTile(
            title: const Text("Aama Lakshan"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => AamaLakshanaPage())));
            },
          ),
          ListTile(
            title: const Text("Rookshana"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => RookshanaPage())));
            },
          ),
          ListTile(
            title: const Text("Sarvanga Lakshana"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => SarvangaLakshanaPage())));
            },
          ),
          ListTile(
            title: const Text("Sneha Jeeryaman Lakshana"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => SnehJeeryamanLakshanaPage())));
            },
          ),
          ListTile(
            title: const Text("SnehaPana Calculator"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => SnehpanaPage())));
            },
          ),
          ListTile(
            title: const Text("Yoga Lakshana"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => YogaLakshanaPage())));
            },
          ),
        ],
      ),
    );
  }
}
