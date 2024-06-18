import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vamana_app/aama_lakshana/aama_lakshana_page.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_bloc/login_bloc.dart';
import 'package:vamana_app/login/login_bloc/login_event.dart';
import 'package:vamana_app/login/login_bloc/login_state.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_bloc.dart';
import 'package:vamana_app/new_assessment/new_assessment_page.dart';

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
        // BlocProvider(create: (_) => DashBoardBloc())
        BlocProvider(create: (_) => NewAssessmentBloc())
      ],
      child: MaterialApp(
        title: 'Vamana App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff15400d)),
          useMaterial3: true,
        ),
        home: NewAssessmentPage()
        // home: BlocConsumer<LoginBloc, LoginState>(
        //   listener: (context, state) {
        //     if (state is LoginError) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text(state.error)),
        //       );
        //     }
        //   },
        //   builder: (context, state) {
        //     if (state is UserVerified) {
        //       return DashBoardPage();
        //     } else if (state is CheckingUser) {
        //       return const CircularProgressIndicator.adaptive();
        //     } else {
        //       return LoginPage();
        //     }
        //   },
        // ),
      ),
    );
  }
}



