import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_screen.dart';
import 'package:user_app_yourspacekh/screens/profile_screen/change_language_screen.dart';

import 'package:user_app_yourspacekh/screens/profile_screen/faq_screen.dart';
import 'package:user_app_yourspacekh/screens/profile_screen/parking_history.dart';
import 'package:user_app_yourspacekh/screens/profile_screen/edit_profile_screen.dart';
import 'package:user_app_yourspacekh/screens/profile_screen/terms_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:user_app_yourspacekh/services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final UserService _userService = UserService();
  Widget _getHomeAction(
      BuildContext context, String title, IconData icon, Widget screen) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe0e0e0)))),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10, left: 30, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocal!.welcome,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  ),
                  Text(
                    Provider.of<AuthProvider>(context, listen: false)
                        .user!
                        .name!,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 35),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 40),
              child: Column(
                children: [
                  _getHomeAction(context, appLocal.edit_profile, Icons.person,
                      const EditProfileScreen()),
                  _getHomeAction(context, appLocal.parking_history,
                      Icons.folder, const ParkingHistoryScreen()),
                  _getHomeAction(context, appLocal.change_language,
                      Icons.language, const ChangeLanguageScreen()),
                  _getHomeAction(
                      context, appLocal.faq, Icons.message, const FAQScreen()),
                  _getHomeAction(context, appLocal.terms_and_condition,
                      Icons.article, const TermsScreen()),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 40),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: Text(appLocal.back_home),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text(appLocal.logout),
                        onPressed: () async {
                          await _userService.logout();
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                          Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const HomeScreen()),
                          );
                        }),
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
