import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:webrtc_in_flutter/API/meeting_api.dart';
import 'package:webrtc_in_flutter/models/meeting_details.dart';
import 'package:webrtc_in_flutter/pages/meeting_page.dart';

class JoinScreen extends StatefulWidget {
  final String? meetingId;
  final MeetingDetail? meetingDetail;
  const JoinScreen({super.key, this.meetingId, this.meetingDetail});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: globalKey,
        child: formUI(context),
      ),
    );
  }

  Widget formUI(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "userId",
              "Enter User Name",
              (val) {
                if (val.isEmpty) {
                  return "Name can't be empty";
                }
                return null;
              },
              (onSaved) {
                userName = onSaved ?? '';
              },
              borderRadius: 10,
              borderFocusColor: Colors.redAccent,
              borderColor: Colors.redAccent,
              hintColor: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: FormHelper.submitButton(
                    "Join Meeting",
                    () {
                      if (validateAndSave()) {
                        // validateMeeting(widget.meetingId ?? '');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MeetingPage(
                              meetingId: widget.meetingDetail!.id,
                              name: userName,
                              meetingDetail: widget.meetingDetail!,

                            );
                          }),
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> validateMeeting(String meetingId) async {
    try {
      http.Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);

      goToJoinScreen(meetingDetails);
    } catch (error) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid meeting ID", "OK", () {
        Navigator.of(context).pop();
      });
    }
  }

  void goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(
          meetingDetail: meetingDetail,
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
