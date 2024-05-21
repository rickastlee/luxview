import 'package:flutter/material.dart';

class ErrorHandler {
  static void toastUnimplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unimplemented')),
    );
  }
}
