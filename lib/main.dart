import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/view/fotgetPassword.dart';
import 'package:madmon/view/homePageAdmin.dart';
import 'package:madmon/view/homeTech.dart';
import 'package:madmon/view/login.dart';
import 'package:madmon/view/signup.dart';
import 'package:madmon/view/splachScreen.dart';
import 'cubit/home/home_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (_) => JobsCubit(FirebaseFirestore.instance),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      theme: ThemeData(
        fontFamily: 'droid',
      ),
      home: const Splachscreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              final args = settings.arguments as Map<String, String>;
              final role = args['role']!;
              final technicianName = args['technicianName'] ?? '';

              if (role == 'admin') {
                return MaterialPageRoute(builder: (_) => HomeAdmin(userRole: role));
              } else if (role == 'technician') {
                return MaterialPageRoute(
                  builder: (_) => HomeTech(
                    userRole: role,
                    technicianName: technicianName,
                  ),
                );
              }
              break;

            case '/login':
              return MaterialPageRoute(builder: (_) => Login());

            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUp());

            case '/forgetpassword':
              return MaterialPageRoute(builder: (_) => const ForgetPassword());

            default:
              return null;
          }
        }

    );
  }
}