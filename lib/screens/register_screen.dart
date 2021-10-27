import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> _cities = [
    "Phnom Penh",
    "Battambang",
    "Kompong spue",
    "Koh Kong",
    "Kompot",
    "Posat"
  ];
  TextEditingController _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Icons.lock,
                      color: Color(0xff79808F),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        child: Text(
                      "We take privacy issues seriously. You can be sure that your data is securely protected.",
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
                      Text("Your Name"),
                      Container(
                        margin: EdgeInsets.only(top: 7),
                        height: 37,
                        child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle Number"),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                            margin: EdgeInsets.only(top: 7, right: 5),
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
                            margin: EdgeInsets.only(top: 7, right: 10),
                            height: 37,
                            child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
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
                      child: Text("Submit"),
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
