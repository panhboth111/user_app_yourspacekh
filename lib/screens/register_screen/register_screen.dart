import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/city_model.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserService _userService = UserService();
  //list of cities to choose from
  List<CityModel>? _cities = [];
  CityModel? _selectedCity;
  //text field controllers
  final TextEditingController _cityFieldController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  submitRegistration() async {
    final userDetail = {
      "plateNumber": {
        "cityId": _selectedCity!.id,
        "plateNumber": _plateNumberController.text
      }
    };
    final response = await _userService.registerInformation(
        _nameController.text, userDetail);

    if (response['success']) {
      _userService.getUserInformation().then((value) =>
          Provider.of<AuthProvider>(context, listen: false).initialize(value));

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userService.getCities().then((cities) => {
          setState(() {
            _cities = cities;
            _selectedCity = cities[0];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context);
    return Scaffold(
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
                        child: TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
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
                              flex: 2,
                              child: Container(
                                height: 37,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton(
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCity = _cities!.firstWhere(
                                            (CityModel city) =>
                                                city.id == value);
                                      });
                                    },
                                    value: _selectedCity!.id,
                                    items: _cities!
                                        .map((CityModel city) =>
                                            DropdownMenuItem(
                                              child: Text(city.name!),
                                              value: city.id,
                                            ))
                                        .toList()),
                              )),
                          // Flexible(
                          //     child: Container(
                          //   margin: const EdgeInsets.only(top: 7, right: 5),
                          //   height: 37,
                          //   child: DropdownSearch<CityModel>(
                          //       mode: Mode.MENU,
                          //       showSelectedItems: true,
                          //       onChanged: print,
                          //       selectedItem: _cities[0]),
                          // )),
                          Flexible(
                              flex: 2,
                              child: Container(
                                height: 37,
                                margin: const EdgeInsets.only(left: 10),
                                child: TextField(
                                    controller: _plateNumberController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
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
                    margin: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: const Text("Submit"),
                        onPressed: submitRegistration),
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
