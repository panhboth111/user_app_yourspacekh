import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmBookingScreen extends StatefulWidget {
  const ConfirmBookingScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  late DateTime selectedDate;
  final TextEditingController _datePickerFieldController =
      TextEditingController();
  final TextEditingController _timePickerFieldController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _datePickerFieldController.dispose();
    _timePickerFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Text(
                appLocal!.basic_info,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                color: const Color(0xffF0F2F4),
                child: Row(
                  children: const [
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
              margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Space Name"),
                      Container(
                        margin: const EdgeInsets.only(top: 7),
                        height: 37,
                        child: const TextField(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Choose Preferred Date"),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 37,
                              child: Row(
                                children: [
                                  Flexible(
                                      child: DateTimeField(
                                          controller:
                                              _datePickerFieldController,
                                          onChanged: (value) {},
                                          format: DateFormat("yyyy-MM-dd"),
                                          onShowPicker:
                                              (context, currentValue) {
                                            return showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: (DateTime(2022)));
                                          })),
                                  const SizedBox(
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
                            const SizedBox(
                              height: 100,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.white,
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                    child: const Text("Confirm Booking"),
                                    onPressed: () {},
                                  ),
                                )
                              ],
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
