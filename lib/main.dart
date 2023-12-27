import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trenning/firebase_auth/check_account.dart';
import 'package:trenning/models/workmanager.dart';
import 'package:trenning/screens/accountScreen.dart';
import 'package:trenning/screens/createAccount.dart';
import 'package:trenning/screens/history.dart';
import 'package:trenning/screens/home_page.dart';
import 'package:trenning/screens/settings.dart';
import 'package:trenning/screens/sign_in.dart';
import 'package:trenning/screens/sign_up.dart';
import 'package:trenning/theme/theme_provider.dart';

//import 'package:workmanager/workmanager.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WorkmanagerServices workmanager = WorkmanagerServices();

  //Workmanager().initialize(callbackDispatchers);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCxz0yscalvwB7oR8jfKJn8RCmh4vTIE9g",
      appId: "1:644557048870:android:6403611638f38bfbc16ae7",
      messagingSenderId: "644557048870",
      projectId: "mony-box-24cb3",
      storageBucket: 'mony-box-24cb3.appspot.com',
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/checkScreens',
      routes: {
        '/settings': (context) => const Settings(),
        '/checkScreens': (context) => const CheckAccount(),
        '/': (context) => const MyHomePage(),
        '/history': (context) => const HistoryList(),
        '/sign_in': (context) => const signIn(),
        '/sign_up': (context) => const signUp(),
        '/createAccount': (context) => const CreateAccount(),
        '/accountScreen': (context) => const AccountScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
