import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_screen.dart';
import 'package:user_app_yourspacekh/screens/register_screen/register_screen.dart';
import 'package:user_app_yourspacekh/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _loginStage = 0;
  String? errorMsg = "";
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final UserService _userService = UserService();

  bool _phoneBtnEnabled = false;
  bool _pinBtnEnabled = false;

  void _onSubmitPhone() async {
    final response = await _userService.login(_phoneController.text);

    if (!response['success']) {
      setState(() {
        errorMsg = response["errors"].toString();
      });
      return;
    }
    setState(() {
      _loginStage = 1;
      errorMsg = "";
    });
  }

  void _onSubmitPin() async {
    final response = await _userService.verifyPhoneNumber(_pinController.text);
    if (!response['success']) {
      setState(() {
        errorMsg = response["errors"].toString();
      });
      return;
    }
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => response['body']['name'] == null
            ? const RegisterScreen()
            : const HomeScreen(),
      ),
    );
  }

  void _onPhoneTextChanged(value) {
    if (!_phoneBtnEnabled) {
      if (_phoneController.text.isNotEmpty) {
        setState(() {
          _phoneBtnEnabled = true;
        });
      }
    } else if (_phoneBtnEnabled) {
      if (_phoneController.text.isEmpty) {
        setState(() {
          _phoneBtnEnabled = false;
        });
      }
    }
  }

  void _onPinTextChanged(value) {
    if (!_pinBtnEnabled) {
      if (_pinController.text.length == 4) {
        setState(() {
          _pinBtnEnabled = true;
        });
      }
    } else if (_pinBtnEnabled) {
      if (_pinController.text.length < 4) {
        setState(() {
          _pinBtnEnabled = false;
          errorMsg = "";
        });
      }
    }
  }

  Widget _getPhoneScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Log In",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Phone Number"),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 40,
                  child: TextField(
                      onChanged: _onPhoneTextChanged,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.flag,
                            color: errorMsg!.isEmpty ? Colors.blue : Colors.red,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: errorMsg!.isEmpty
                                    ? Colors.blue
                                    : Colors.red,
                                width: 2.0),
                          ))),
                ),
              ],
            )),
        Container(
          child: Text(
            errorMsg!,
            style: const TextStyle(color: Colors.red),
          ),
          margin: const EdgeInsets.only(top: 10),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: const Text("Send Code"),
            onPressed: _phoneBtnEnabled ? _onSubmitPhone : null,
          ),
        )
      ],
    );
  }

  BoxDecoration get _pinPutDecoration {
    return const BoxDecoration(color: Color(0xfff2f2f7));
  }

  Widget _getPinScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Confirmation",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: PinPut(
            onChanged: _onPinTextChanged,
            eachFieldConstraints:
                const BoxConstraints(minHeight: 56.0, minWidth: 54),
            fieldsCount: 6,
            onSubmit: (value) {},
            controller: _pinController,
            submittedFieldDecoration: _pinPutDecoration.copyWith(
                border: Border.all(
                    color: errorMsg!.isEmpty ? Colors.blue : Colors.red,
                    width: 2)),
            selectedFieldDecoration: _pinPutDecoration,
            followingFieldDecoration: _pinPutDecoration.copyWith(),
          ),
        ),
        Container(
          child: Text(
            errorMsg!,
            style: const TextStyle(color: Colors.red),
          ),
          margin: const EdgeInsets.only(top: 5),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          child: Text(
            "Code expires in 90 seconds",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              child: const Text("Log in"),
              onPressed: _pinBtnEnabled ? _onSubmitPin : null),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (_loginStage == 0) {
                Navigator.pop(context);
                return;
              }
              setState(() {
                _loginStage = 0;
                errorMsg = "";
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          )),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
            child: _loginStage == 0
                ? _getPhoneScreen(context)
                : _getPinScreen(context)),
      ),
    );
  }
}
