import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:user_app_yourspacekh/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _loginStage = 0;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _pinController = TextEditingController();

  bool _phoneBtnEnabled = false;
  bool _pinBtnEnabled = false;

  void _onSubmitPhone() {
    setState(() {
      _loginStage = 1;
    });
  }

  void _onSubmitPin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => RegisterScreen(),
      ),
    );
  }

  void _onPhoneTextChanged(value) {
    if (!_phoneBtnEnabled) {
      if (_phoneController.text.length > 0) {
        setState(() {
          _phoneBtnEnabled = true;
        });
      }
    } else if (_phoneBtnEnabled) {
      if (_phoneController.text.length == 0) {
        setState(() {
          _phoneBtnEnabled = false;
        });
      }
    }
  }

  void _onPinTextChanged(value) {
    print("triggered");
    if (!_pinBtnEnabled) {
      if (_pinController.text.length > 0) {
        setState(() {
          _pinBtnEnabled = true;
        });
      }
    } else if (_pinBtnEnabled) {
      if (_pinController.text.length == 0) {
        setState(() {
          _pinBtnEnabled = false;
        });
      }
    }
  }

  Widget _getPhoneScreen(BuildContext context) {
    return Column(
      children: [
        Text(
          "Log In",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone Number"),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 40,
                  child: TextField(
                      onChanged: _onPhoneTextChanged,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      )),
                ),
              ],
            )),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: Text("Send Code"),
            onPressed: _phoneBtnEnabled ? _onSubmitPhone : null,
          ),
        )
      ],
    );
  }

  Widget _getPinScreen() {
    return Column(
      children: [
        Text(
          "Confirmation",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: EdgeInsets.only(top: 40),
            child: PinCodeTextField(
              keyboardType: TextInputType.number,
              controller: _pinController,
              length: 6,
              appContext: context,
              onChanged: _onPinTextChanged,
              enableActiveFill: true,
              pinTheme: PinTheme(
                  fieldWidth: 50,
                  shape: PinCodeFieldShape.box,
                  activeFillColor: Color(0xffF2F2F7),
                  selectedFillColor: Color(0xffF2F2F7),
                  selectedColor: Color(0xffF2F2F7),
                  activeColor: Color(0xffF2F2F7),
                  inactiveColor: Color(0xffF2F2F7),
                  inactiveFillColor: Color(0xffF2F2F7)),
            )),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            "Code expires in 90 seconds",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              child: Text("Log in"),
              onPressed: _pinBtnEnabled ? _onSubmitPin : null),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_loginStage == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                _loginStage = 0;
              });
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 15, right: 15, top: 25),
            child:
                _loginStage == 0 ? _getPhoneScreen(context) : _getPinScreen()),
      ),
    );
  }
}
