import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/parking_provider.dart';
import 'package:user_app_yourspacekh/providers/language_provider.dart';
import 'package:user_app_yourspacekh/providers/space_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_screen.dart';
import 'package:user_app_yourspacekh/services/parking_service.dart';

import 'package:user_app_yourspacekh/services/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => ParkingProvider()),
      ChangeNotifierProvider(create: (_) => SpaceProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserService userService = UserService();
  ParkingService parkingService = ParkingService();
  @override
  void initState() {
    super.initState();

    userService
        .getUserInformation()
        .then((user) =>
            Provider.of<AuthProvider>(context, listen: false).initialize(user))
        .then((value) => Provider.of<LanguageProvider>(context, listen: false)
            .setLocale(Locale(Provider.of<AuthProvider>(context, listen: false)
                .user!
                .language!)));
    parkingService.getCurrentParking().then((response) {
      print(response);
      // if (response['body']['data'].length == 0) {
      //   Provider.of<ParkingProvider>(context, listen: false)
      //       .setBottomCardType(0);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AuthProvider>(
      builder: (languageContext, authContext, model, child) {
        print("build main");
        return MaterialApp(
          theme: ThemeData(
              primaryColor: const Color(0xff3277D8),
              inputDecorationTheme:
                  const InputDecorationTheme(border: OutlineInputBorder())),
          debugShowCheckedModeBanner: false,
          locale: Provider.of<LanguageProvider>(context, listen: false).locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          home: const SafeArea(
            child: HomeScreen(),
          ),
        );
      },
    );
  }
}
