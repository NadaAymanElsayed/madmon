import 'package:flutter/material.dart';
import 'package:madmon/view/login.dart';
import '../constants/appAssets.dart';
import '../constants/appColors.dart';

class Splachscreen extends StatelessWidget {
  const Splachscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
    return Scaffold(
      backgroundColor: AppColors.basic,
      body: Center(
        child: Image.asset(
          AppAssets.logo,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
