import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmBookingScreen extends StatefulWidget {
  ConfirmBookingScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  late DateTime selectedDate;
  TextEditingController _datePickerFieldController = TextEditingController();
  TextEditingController _timePickerFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _datePickerFieldController.dispose();
    _timePickerFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                "Basic Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(20),
                color: Color(0xffF0F2F4),
                child: Row(
                  children: [
                    Icon(
                      Icons.car_repair,
                      color: Color(0xff79808F),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        child: Text(
                      "After confirm booking, it may take a little while for space owner to confirm and reserve a spot.",
                    ))
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Space Name"),
                      Container(
                        margin: EdgeInsets.only(top: 7),
                        height: 37,
                        child: TextField(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Choose Preferred Date"),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 37,
                              child: Row(
                                children: [
                                  Flexible(
                                      child: DateTimeField(
                                          controller:
                                              _datePickerFieldController,
                                          onChanged: (value) {
                                            print(_datePickerFieldController
                                                .text);
                                          },
                                          format: DateFormat("yyyy-MM-dd"),
                                          onShowPicker:
                                              (context, currentValue) {
                                            return showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: (DateTime(2022)));
                                          })),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: DateTimeField(
                                      controller: _timePickerFieldController,
                                      format: DateFormat("HH:mm a"),
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                        );
                                        return DateTimeField.convert(time);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.white,
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5)),
                                      onPressed: () {},
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).primaryColor),
                                      child: Text("Confirm Booking"),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                            )
                            // Container(
                            //   width: double.infinity,
                            //   height: 37,
                            //   color: Colors.red,
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //         primary: Theme.of(context).primaryColor),
                            //     child: Text("Confirm Booking"),
                            //     onPressed: () {
                            //       Navigator.pop(context);
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
