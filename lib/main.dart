import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_bloc/login_bloc.dart';
import 'package:vamana_app/login/login_bloc/login_event.dart';
import 'package:vamana_app/login/login_bloc/login_state.dart';
import 'package:vamana_app/login/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
// const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // String supabaseUrl = dotenv.env["SUPABASE_URL"] ?? '';
  // String supabaseKey = dotenv.env["SUPABASE_KEY"] ?? '';

  // await Supabase.initialize(
  //   url: supabaseUrl,
  //   anonKey: supabaseKey,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()..add(UserLoggedIn())),
        // BlocProvider(create: (_) => DashBoardBloc())
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
              return DashBoardPage();
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



// Future<void> saveData() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   // Saving a String
//   await prefs.setString('stringKey', 'Hello, World!');

//   // Saving an int
//   await prefs.setInt('intKey', 42);

//   // Saving a bool
//   await prefs.setBool('boolKey', true);

//   // Saving a double
//   await prefs.setDouble('doubleKey', 3.14);

//   // Saving a List of Strings
//   await prefs.setStringList('listKey', ['Flutter', 'Dart']);
// }


// Future<void> retrieveData() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   // Retrieving a String
//   String? stringValue = prefs.getString('stringKey');
//   print('String value: $stringValue');

//   // Retrieving an int
//   int? intValue = prefs.getInt('intKey');
//   print('Int value: $intValue');

//   // Retrieving a bool
//   bool? boolValue = prefs.getBool('boolKey');
//   print('Bool value: $boolValue');

//   // Retrieving a double
//   double? doubleValue = prefs.getDouble('doubleKey');
//   print('Double value: $doubleValue');

//   // Retrieving a List of Strings
//   List<String>? listValue = prefs.getStringList('listKey');
//   print('List value: $listValue');
// }
