import 'dart:io';

import 'package:background_task/background_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/geoloc.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundTask.instance.setBackgroundHandler(backgroundHandler);

  await initializeDateFormatting('ja_JP');

  final Directory dir = await getApplicationSupportDirectory();

  // ignore: always_specify_types
  final Isar isar = await Isar.open([GeolocSchema], directory: dir.path);

  await SystemChrome.setPreferredOrientations(
          <DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(ProviderScope(child: MyApp(isar: isar))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('ja'),
      ],
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.kiwiMaru(textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
        ),
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark),
        fontFamily: 'KiwiMaru',
      ),
      themeMode: ThemeMode.dark,
      title: 'invest note',
      debugShowCheckedModeBanner: false,
      home: GestureDetector(onTap: () => primaryFocus?.unfocus(), child: HomeScreen(isar: isar)),
    );
  }
}
