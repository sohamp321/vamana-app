import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_bloc/aama_lakshana_bloc.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_bloc/login_bloc.dart';
import 'package:vamana_app/login/login_bloc/login_event.dart';
import 'package:vamana_app/login/login_bloc/login_state.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_bloc.dart';
import 'package:vamana_app/new_assessment/new_assessment_page.dart';
import 'package:vamana_app/sneh_jeeryaman_lakshana/sneh_jeeryaman_lakshana_bloc/sneh_jeeryaman_lakshana_bloc.dart';
import 'package:vamana_app/sneh_jeeryaman_lakshana/sneh_jeeryaman_lakshana_page.dart';
import 'package:vamana_app/yoga_lakshana/yoga_lakshana_bloc.dart/yoga_lakshana_bloc.dart';
import 'package:vamana_app/yoga_lakshana/yoga_lakshana_page.dart';
import 'package:vamana_app/sarvanga_lakshana/sarvanga_lakshana_bloc/sarvanga_lakshana_bloc.dart';
import 'package:vamana_app/sarvanga_lakshana/sarvanga_lakshana_page.dart';
import 'package:vamana_app/snehpana_calculator/snehpana_page.dart';

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
              return SnehpanaPage();
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
