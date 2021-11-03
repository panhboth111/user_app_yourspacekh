import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';
import 'package:user_app_yourspacekh/providers/auth_provider.dart';
import 'package:user_app_yourspacekh/providers/bottom_card_provider.dart';
import 'package:user_app_yourspacekh/providers/language_provider.dart';
import 'package:user_app_yourspacekh/providers/location_provider.dart';
import 'package:user_app_yourspacekh/screens/home_screen/home_screen.dart';

import 'package:user_app_yourspacekh/services/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => BottomCardProvider()),
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
    return Consumer<LanguageProvider>(
      builder: (consumerContext, model, child) {
        return MaterialApp(
          theme: ThemeData(
              primaryColor: Color(0xff3277D8),
              inputDecorationTheme:
                  InputDecorationTheme(border: OutlineInputBorder())),
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
      },
    );
  }
}
