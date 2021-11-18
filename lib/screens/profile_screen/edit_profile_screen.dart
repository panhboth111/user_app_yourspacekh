import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/models/user_model.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _telegramController = TextEditingController();

  Widget _getTextField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            margin: const EdgeInsets.only(top: 7),
            height: 37,
            child: TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                )),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserModel user = Provider.of<AuthProvider>(context, listen: false).user!;
    _nameController.text = user.name!;
    _phoneController.text = user.phoneNumber!;
    _telegramController.text = user.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        width: double.infinity,
        child: Column(
          children: [
            Text(
              appLocal!.edit_profile,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  _getTextField(appLocal.your_name, _nameController),
                  _getTextField(appLocal.phone, _phoneController),
                  _getTextField("Telegram", _telegramController),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50),
              height: 41,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("Update"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
