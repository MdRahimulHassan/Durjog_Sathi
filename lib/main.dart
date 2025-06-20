import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';



import 'firebase_options.dart';

import 'screens/HomeScreen.dart';

import 'screens/LoginPage.dart';

import 'screens/WelcomePage.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(const MyApp());

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Flood Rescue App',

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        useMaterial3: true,

      ),

      debugShowCheckedModeBanner: false,

      home: const AuthGate(),

    );

  }

}



class AuthGate extends StatelessWidget {

  const AuthGate({super.key});



  @override

  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {

          return const Scaffold(

            body: Center(child: CircularProgressIndicator()),

          );

        } else if (snapshot.hasData) {

          return const HomeScreen();

        } else {

          return const WelcomePage();

        }

      },

    );

  }

}