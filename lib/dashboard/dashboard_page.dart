import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_bloc/aama_lakshana_bloc.dart';
import 'package:vamana_app/components/widgets.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:vamana_app/new_assessment/new_assessment_page.dart';
import '../aama_lakshana/aama_lakshana_page.dart';
import 'dashboard_bloc/dashboard_state.dart';
import 'dashboard_bloc/dashboard_bloc.dart';
import 'dashboard_bloc/dashboard_event.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  // ? Another approach is to instantiate the BLoC and dispatch an event within the initState method of a StatefulWidget. This method is useful when you need to perform actions right after the widget is inserted into the widget tree, such as fetching data or initializing resources.

  // late DashBoardBloc _dashBoardBloc;

  // @override
  // void initState() {
  //   super.initState();
  //   _dashBoardBloc = DashBoardBloc()..add(GetDashBoardData());
  // }

  // @override
  // void dispose() {
  //   _dashBoardBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: VamanaAppBar(),
      drawer: VamanaDrawer(selectedPage: "Dashboard",),
      body: BlocProvider(
        create: (context) => DashBoardBloc()..add(GetDashBoardData()),
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bg1.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Physician's Dashboard",
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
                    child: BlocConsumer<DashBoardBloc, DashBoardState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is DashBoardLoaded) {
                          final List assessments = state.dashBoardData;
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: assessments.map((assessment) {
                                  return AssessmentItem(
                                      uhid: assessment["patientUhid"],
                                      patientName: assessment["patientName"],
                                      assessmentID: assessment["_id"]);
                                }).toList(),
                              ),
                            ),
                          );
                        }
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      },
                    )),
                SizedBox(
                  height: screenHeight * 0.01,
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewAssessmentPage(),
              ));
        },
        backgroundColor: const Color(0xff0F6f03),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
    ;
  }
}

class AssessmentItem extends StatelessWidget {
  String? uhid;
  String? patientName;
  String? assessmentID;

  AssessmentItem(
      {super.key,
      required this.uhid,
      required this.patientName,
      required this.assessmentID});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: InkWell(
        onTap: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (assessmentID != null) {
            prefs.setString("assessmentID", assessmentID!);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AamaLakshanaPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("Error: Assessment ID does not exist")));
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffb5c99a),
              borderRadius: BorderRadius.circular(20)),
          height: screenHeight * 0.075,
          width: screenWidth * 0.93,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(uhid ?? "UHID Error"),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(patientName ?? "Patient Name Error"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
