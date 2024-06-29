import 'package:flutter/material.dart';

void snackbar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
    ),
  );
}

void progressbar(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => const Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: Color(0xff98c1d9),
      ),
    ),
  );
}
