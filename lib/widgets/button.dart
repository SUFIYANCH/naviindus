import 'package:flutter/material.dart';
import 'package:naviindus/utils/app_color.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onpressed;
  const ButtonWidget({
    super.key,
    required this.text,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            fixedSize: Size(R.maxWidth(context), R.rh(50, context)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(R.rw(10, context)))),
        onPressed: onpressed,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: R.rw(17, context)),
        ));
  }
}
