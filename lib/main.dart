import 'package:dlala_group/auth/main_page.dart';
import 'package:dlala_group/firebase_options.dart';
import 'package:dlala_group/model/lift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LiftsViewModel()),
          StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(),
            initialData: null,
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'socials',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const  MainPage(),
    );
  }
}
