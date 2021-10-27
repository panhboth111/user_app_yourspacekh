import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/language_provider.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen.dart';
import 'package:user_app_yourspacekh/screens/login_screen.dart';
import 'package:user_app_yourspacekh/services/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserService userService = UserService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userService
        .getUserInformation()
        .then((user) =>
            Provider.of<AuthProvider>(context, listen: false).initialize(user))
        .then((value) => Provider.of<LanguageProvider>(context, listen: false)
            .setLocale(new Locale(
                Provider.of<AuthProvider>(context, listen: false)
                    .user!
                    .language)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xff3277D8)),
      debugShowCheckedModeBanner: false,
      locale: Provider.of<LanguageProvider>(context, listen: false).locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: SafeArea(
        child: HomeScreen(),
      ),
    );
  }
}
