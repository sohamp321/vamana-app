import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "chatushprakara_shuddhi_state.dart";
import 'chatushprakara_shuddhi_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ChatushprakaraShuddhiBloc extends Bloc<ChatushprakaraShuddhiEvent, ChatushprakaraShuddhiState> {
  ChatushprakaraShuddhiBloc() : super(ChatushprakaraShuddhiInitial()) {
    on<CreateChatushprakaraShuddhi>(_createChatushprakaraShuddhi);
    on<GetChatushprakaraShuddhi>(_getChatushprakaraShuddhi);
    on<Day0ChatushprakaraShuddhi>(_firstPost);
  }

  void _firstPost(
      Day0ChatushprakaraShuddhi event, Emitter<ChatushprakaraShuddhiState> emit) async {
    emit(CreatingChatushprakaraShuddhi());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "ChatushprakaraShuddhi",
          "day": "0",
          "id": assessmentID,
          "data": {}
        };

        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: jsonEncode(aamaLakshanReq),
        );

        if (response.statusCode == 200) {
          emit(ChatushprakaraShuddhiInitial());
        }
      } catch (e) {
        emit(ChatushprakaraShuddhiError(error: e.toString()));
      }
    } else {
      emit(ChatushprakaraShuddhiError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createChatushprakaraShuddhi(
      CreateChatushprakaraShuddhi event, Emitter<ChatushprakaraShuddhiState> emit) async {
    emit(CreatingChatushprakaraShuddhi());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating ChatushprakaraShuddhi: ${json.encode(event.ChatushprakaraShuddhiData)}");

    if (userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: jsonEncode(event.ChatushprakaraShuddhiData),
        );

        if (response.statusCode == 200) {
          dev.log("Create ChatushprakaraShuddhi Response: ${response.body}");

          emit(ChatushprakaraShuddhiCreated());
        }
      } catch (e) {
        emit(ChatushprakaraShuddhiError(error: e.toString()));
      }
    } else {
      emit(ChatushprakaraShuddhiError(error: "User not logged in"));
    }
  }

  void _getChatushprakaraShuddhi(
      GetChatushprakaraShuddhi event, Emitter<ChatushprakaraShuddhiState> emit) async {
    emit(ChatushprakaraShuddhiLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting ChatushprakaraShuddhi assessment ID: $assessmentID");
    dev.log("Getting ChatushprakaraShuddhi user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "ChatushprakaraShuddhi",
          "day": event.dayNumber
        };
        var _fetchBody = jsonEncode(fetchBody);

        dev.log(_fetchBody);

        dev.log("Sending request to : $url");
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: _fetchBody,
        );
        if (response.statusCode == 200) {
          dev.log("ChatushprakaraShuddhi Response: ${response.body}");
          if (response.body == "") {
            emit(ChatushprakaraShuddhiLoaded(ChatushprakaraShuddhiDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(ChatushprakaraShuddhiLoaded(ChatushprakaraShuddhiDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(ChatushprakaraShuddhiError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(ChatushprakaraShuddhiError(error: e.toString()));
      }
    }
  }
}
