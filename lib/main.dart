import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_bloc/aama_lakshana_bloc.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/blood_pressure/blood_pressure_page.dart';
import 'package:vamana_app/chatushprakara_shuddhi/chatushprakara_shuddhi_bloc/chatushprakara_shuddhi_bloc.dart';
import 'package:vamana_app/chatushprakara_shuddhi/chatushprakara_shuddhi_page.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_bloc/login_bloc.dart';
import 'package:vamana_app/login/login_bloc/login_event.dart';
import 'package:vamana_app/login/login_bloc/login_state.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_bloc.dart';
import 'package:vamana_app/new_assessment/new_assessment_page.dart';
import 'package:vamana_app/pashchat_karma/pashchat_karma_bloc/pashchat_karma_bloc.dart';
import 'package:vamana_app/pashchat_karma/pashchat_karma_page.dart';
import 'package:vamana_app/pradhankarma/pradhankarma_bloc/pradhankarma_bloc.dart';
import 'package:vamana_app/pradhankarma/pradhankarma_page.dart';
import 'package:vamana_app/rookshana/rookshana_bloc/rookshana_bloc.dart';
import 'package:vamana_app/rookshana/rookshana_page.dart';
import 'package:vamana_app/sneh_jeeryaman_lakshana/sneh_jeeryaman_lakshana_bloc/sneh_jeeryaman_lakshana_bloc.dart';
import 'package:vamana_app/sneh_jeeryaman_lakshana/sneh_jeeryaman_lakshana_page.dart';
import 'package:vamana_app/snehana_lakshana/snehana_lakshana_bloc/snehana_lakshana_bloc.dart';
import 'package:vamana_app/snehana_lakshana/snehana_lakshana_page.dart';
import 'package:vamana_app/snehapana/snehapana_bloc/snehapana_bloc.dart';
import 'package:vamana_app/snehapana/snehapana_page.dart';
import 'package:vamana_app/vega_nirikshana/vega_nirikshana_bloc/vega_nirikshana_bloc.dart';
import 'package:vamana_app/vega_nirikshana/vega_nirikshana_page.dart';
import 'package:vamana_app/yoga_lakshana/yoga_lakshana_bloc.dart/yoga_lakshana_bloc.dart';
import 'package:vamana_app/yoga_lakshana/yoga_lakshana_page.dart';
import 'package:vamana_app/sarvanga_lakshana/sarvanga_lakshana_bloc/sarvanga_lakshana_bloc.dart';
import 'package:vamana_app/sarvanga_lakshana/sarvanga_lakshana_page.dart';
import 'package:vamana_app/snehpana_calculator/snehpana_page.dart';
import "package:vamana_app/blood_pressure/blood_pressure_bloc/blood_pressure_bloc.dart";

import 'dashboard/dashboard_bloc/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()..add(UserLoggedIn())),
        BlocProvider(create: (_) => DashBoardBloc()),
        BlocProvider(create: (_) => NewAssessmentBloc()),
        BlocProvider(create: (_) => AamaLakshanaBloc()),
        BlocProvider(create: (_) => YogaLakshanaBloc()),
        BlocProvider(create: (_) => SnehJeeryamanLakshanaBloc()),
        BlocProvider(create: (_) => SarvangaLakshanaBloc()),
        BlocProvider(create: (_) => RookshanaBloc()),
        BlocProvider(create: (_) => SnehanaLakshanaBloc()),
        BlocProvider(create: (_) => PradhanKarmaBloc()),
        BlocProvider(create: (_) => BloodPressureBloc()),
        BlocProvider(create: (_) => ChatushprakaraShuddhiBloc()),
        BlocProvider(create: (_) => SnehapanaBloc()),
        BlocProvider(create: (_) => PashchatKarmaBloc()),
        BlocProvider(create: (_) => VegaNirikshanaBloc()),
      ],
      child: MaterialApp(
        title: 'Vamana App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff15400d)),
          useMaterial3: true,
        ),
        home: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserVerified) {
              return VegaNirikshanaPage();
            } else if (state is CheckingUser) {
              return const CircularProgressIndicator.adaptive();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
