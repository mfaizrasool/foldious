import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foldious/app_bindings.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/features/splash_screen/splash_screen.dart';
import 'package:foldious/firebase_options.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:get/get.dart';

import 'utils/theme/app_dark_theme.dart';
import 'utils/theme/app_light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferencesController appPreferencesController =
      Get.put(AppPreferencesController());

  ThemeMode themeMode = ThemeMode.system;


  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {

    String? savedTheme = await appPreferencesController.getString(
        key: AppPreferenceLabels.userTheme);

    setState(() {
      themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Foldious',
      debugShowCheckedModeBanner: false,
      initialBinding: createBindings(context),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
