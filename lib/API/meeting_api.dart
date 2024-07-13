import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/user.dart';


String MEETNG_API_URL = "http://10.0.2.2:4000/api/meeting";
var client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String,String> requestHeaders = {'Content-type': 'application/json'};

  var userId = await loadUserId();

  var response = await client.post(
    Uri.parse('$MEETNG_API_URL/start'),
    headers: requestHeaders,
    body: jsonEncode(
      {'hostId': userId, 'hostName': ''}
  ),
  );

  if (response.statusCode == 200) {
    return response;
  }else {
    return null;
  }
}

Future<http.Response> joinMeeting(String meetingId) async {
  var response = await http.get(Uri.parse('$MEETNG_API_URL/join?meetingId=$meetingId'));

  if(response.statusCode >= 200 && response.statusCode <400) {
    return response;
  }

  throw UnsupportedError('not a valid meeting');
}