import 'package:flutter/material.dart';

import '../constants/appColors.dart';
Widget customTextField({
  required String labelText,
  required TextEditingController? controller,
  required TextInputType keyboardType,
  Icon? prefixIcon,
  Widget? suffixIcon,
  bool obscureText = false,
  String? Function(String?)? validator,
  String? hintText,
  TextStyle? style,
  void Function(String)? onChanged,  // مهم جداً هنا
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
    style: style,
    onChanged: onChanged,  // هنا فقط تمرر الدالة اللي تستقبل القيمة
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(color: AppColors.black),
      labelStyle: TextStyle(color: AppColors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: AppColors.basic, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      errorStyle: TextStyle(color: Colors.red),
    ),
  );
}