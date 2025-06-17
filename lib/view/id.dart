import 'package:flutter/material.dart';
import 'package:madmon/constants/appAssets.dart';
import 'package:madmon/constants/appColors.dart';

class ID extends StatelessWidget {
  const ID({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basic,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.logo),
            Text(
              'من فضلك اختر نوع الحساب',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.build),
              label: Text(' فني'),
              onPressed: () {
                Navigator.pushNamed(context, '/login', arguments: 'technician');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.admin_panel_settings),
              label: Text('إداري'),
              onPressed: () {
                Navigator.pushNamed(context, '/login', arguments: 'admin');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
