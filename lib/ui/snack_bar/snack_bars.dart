import 'package:flutter/material.dart';

class SnackBars {
  // ignore: non_constant_identifier_names
  static SnackBarSuccess(BuildContext context, {required String content}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(content),
        ),
        duration: const Duration(milliseconds: 1800),
        backgroundColor: Colors.green,
        shape: const BeveledRectangleBorder(),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  static SnackBarError(BuildContext context, {required String content}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(content),
        ),
        duration: const Duration(milliseconds: 1800),
        backgroundColor: Colors.red,
        shape: const BeveledRectangleBorder(),
      ),
    );
  }
}
