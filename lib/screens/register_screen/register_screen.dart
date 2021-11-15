import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> _cities = [
    "Phnom Penh",
    "Battambang",
    "Kompong spue",
    "Koh Kong",
    "Kompot",
    "Posat"
  ];
  final TextEditingController _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
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
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Color(0xff79808F),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        child: Text(
                      appLocal.basic_info_desc,
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
                      Text(appLocal.your_name),
                      Container(
                        margin: const EdgeInsets.only(top: 7),
                        height: 37,
                        child: const TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocal.vehicle_number),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                            margin: const EdgeInsets.only(top: 7, right: 5),
                            height: 37,
                            child: DropdownSearch<String>(
                                mode: Mode.MENU,
                                showSelectedItems: true,
                                items: _cities,
                                onChanged: print,
                                selectedItem: _cities[0]),
                          )),
                          Flexible(
                              child: Container(
                            margin: const EdgeInsets.only(top: 7, right: 10),
                            height: 37,
                            child: const TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                )),
                          )),
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 41,
                    margin: EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: const Text("Submit"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
