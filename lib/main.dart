import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_app_yourspacekh/l10n/l10n.dart';
import 'package:user_app_yourspacekh/models/parking_model.dart';
import 'package:user_app_yourspacekh/models/space_model.dart';
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
      var responseBodyData = response['body']['data'];

      if (responseBodyData.length == 0) {
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(0);
      } else if (responseBodyData[0]['status'] == 'BOOKING') {
        SpaceModel space = SpaceModel(
            id: responseBodyData[0]['space']['id'],
            name: responseBodyData[0]['space']['name'],
            price: responseBodyData[0]['space']['price'],
            address: responseBodyData[0]['space']['address'],
            openTime: responseBodyData[0]['space']['openTime'],
            closeTime: responseBodyData[0]['space']['closeTime'],
            coordinate: LatLng(responseBodyData[0]['space']['coordinate']['x'],
                responseBodyData[0]['space']['coordinate']['y']));
        ParkingModel parking = ParkingModel(
            id: responseBodyData[0]['id'].toString(),
            spaceId: responseBodyData[0]['spaceId'].toString());
        Provider.of<ParkingProvider>(context, listen: false)
            .setCurrentParking(parking);
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(2);
      } else if (responseBodyData[0]['status'] == 'ACCEPTED') {
        SpaceModel space = SpaceModel(
            id: responseBodyData[0]['space']['id'],
            name: responseBodyData[0]['space']['name'],
            price: responseBodyData[0]['space']['price'],
            address: responseBodyData[0]['space']['address'],
            openTime: responseBodyData[0]['space']['openTime'],
            closeTime: responseBodyData[0]['space']['closeTime'],
            coordinate: LatLng(responseBodyData[0]['space']['coordinate']['x'],
                responseBodyData[0]['space']['coordinate']['y']));
        ParkingModel parking = ParkingModel(
            id: responseBodyData[0]['id'].toString(),
            spaceId: responseBodyData[0]['spaceId'].toString());
        Provider.of<ParkingProvider>(context, listen: false)
            .setCurrentParking(parking);
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(3);
        Provider.of<SpaceProvider>(context, listen: false)
            .setActiveSpace(space);
      } else if (responseBodyData[0]['status'] == 'PARKING') {
        SpaceModel space = SpaceModel(
            id: responseBodyData[0]['space']['id'],
            name: responseBodyData[0]['space']['name'],
            price: responseBodyData[0]['space']['price'],
            address: responseBodyData[0]['space']['address'],
            openTime: responseBodyData[0]['space']['openTime'],
            closeTime: responseBodyData[0]['space']['closeTime'],
            coordinate: LatLng(responseBodyData[0]['space']['coordinate']['x'],
                responseBodyData[0]['space']['coordinate']['y']));
        ParkingModel parking = ParkingModel(
            id: responseBodyData[0]['id'].toString(),
            spaceId: responseBodyData[0]['spaceId'].toString());
        Provider.of<ParkingProvider>(context, listen: false)
            .setCurrentParking(parking);
        Provider.of<ParkingProvider>(context, listen: false)
            .setBottomCardType(4);
        Provider.of<SpaceProvider>(context, listen: false)
            .setActiveSpace(space);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AuthProvider>(
      builder: (languageContext, authContext, model, child) {
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
