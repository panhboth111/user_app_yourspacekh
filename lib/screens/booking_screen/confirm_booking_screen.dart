import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/parking_model.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
import 'package:user_app_yourspacekh/providers/parking_provider.dart';
import 'package:user_app_yourspacekh/services/parking_service.dart';
import 'package:user_app_yourspacekh/services/space_service.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final SpaceModel? activeSpace;
  const ConfirmBookingScreen({Key? key, this.activeSpace}) : super(key: key);

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  ParkingService _parkingService = ParkingService();
  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime(2022);
  String errorMsg = "";
  bool isMonthly = false;
  final TextEditingController _datePickerFieldController =
      TextEditingController();
  final TextEditingController _timePickerFieldController =
      TextEditingController();

  createParking() async {
    String preferredDate = _datePickerFieldController.text +
        "T" +
        _timePickerFieldController.text.split(" ")[0];
    ParkingModel parking = ParkingModel(
        spaceId: widget.activeSpace!.id.toString(),
        preferredDate: preferredDate,
        interval: "DAILY");
    var response = await _parkingService.createParking(parking);

    if (response['success']) {
      Navigator.pop(context);
      Provider.of<ParkingProvider>(context, listen: false).setBottomCardType(2);
    }
    setState(() {
      errorMsg = response['errors'].toString();
    });
  }

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
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
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isMonthly = false;
                    });
                  },
                  child: Text(
                    "Day",
                    style: TextStyle(
                        color: isMonthly
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      primary: isMonthly
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isMonthly = true;
                    });
                  },
                  child: Text(
                    "Monthly",
                    style: TextStyle(
                        color: isMonthly
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      primary: isMonthly
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
              ],
            ),
            isMonthly
                ? Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("space name"),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              height: 37,
                              child: TextField(
                                enabled: false,
                                controller: TextEditingController(
                                    text: widget.activeSpace!.name),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Please note that:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                      " • You will receive a phone call from our team after you confirm the booking"),
                                  const Text(
                                      " • You have to pay for the fee in advance."),
                                  Text(
                                    errorMsg,
                                    style: TextStyle(color: Colors.red),
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
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1.5)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor),
                                          child: const Text("Contact Us"),
                                          onPressed: createParking,
                                        ),
                                      )
                                    ],
                                  ),

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
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("space name"),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              height: 37,
                              child: TextField(
                                enabled: false,
                                controller: TextEditingController(
                                    text: widget.activeSpace!.name),
                              ),
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
                                                format:
                                                    DateFormat("yyyy-MM-dd"),
                                                onShowPicker:
                                                    (context, currentValue) {
                                                  return showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate:
                                                          (DateTime(2022)));
                                                })),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: DateTimeField(
                                            controller:
                                                _timePickerFieldController,
                                            format: DateFormat("HH:mm a"),
                                            onShowPicker:
                                                (context, currentValue) async {
                                              final time = await showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        currentValue ??
                                                            DateTime.now()),
                                              );
                                              return DateTimeField.convert(
                                                  time);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    errorMsg,
                                    style: const TextStyle(color: Colors.red),
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
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1.5)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor),
                                          child: const Text("Confirm Booking"),
                                          onPressed: createParking,
                                        ),
                                      )
                                    ],
                                  ),

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
