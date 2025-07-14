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
import 'cubit/jobs/jobs_cubit.dart';
import 'cubit/login/login_cubit.dart';
import 'cubit/tech/tech_cubit.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => JobsCubit(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (_) => TechniciansCubit(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (_) => LoginCubit(),
        ),
      ],
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
              return MaterialPageRoute(
                builder: (context) => HomeAdmin(userRole: role),
              );
            } else if (role == 'technician') {
              return MaterialPageRoute(
                builder: (context) => HomeTech(
                  userRole: role,
                  technicianName: technicianName,
                ),
              );
            }
            break;

          case '/login':
            return MaterialPageRoute(
              builder: (context) => Login(),
            );

          case '/signup':
            return MaterialPageRoute(
              builder: (context) => SignUp(),
            );

          case '/forgetpassword':
            return MaterialPageRoute(
              builder: (context) => const ForgetPassword(),
            );

          default:
            return null;
        }
      },
    );
  }
}

