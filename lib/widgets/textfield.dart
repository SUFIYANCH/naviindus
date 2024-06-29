import 'package:flutter/material.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';

class TextfieldWidget extends StatelessWidget {
  final String headText;
  final String? hinttext;
  final TextEditingController textcontroller;
  final TextInputType? keyboardtype;

  const TextfieldWidget({
    super.key,
    required this.headText,
    this.hinttext,
    required this.textcontroller,
    this.keyboardtype,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " $headText",
          style: TextStyle(fontSize: R.rw(16, context)),
        ),
        SizedBox(height: R.rh(6, context)),
        TextField(
            controller: textcontroller,
            keyboardType: keyboardtype,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(R.rw(12, context)),
                filled: true,
                fillColor: Color(0xffD9D9D9).withOpacity(0.25),
                hintText: hinttext,
                hintStyle: TextStyle(
                    fontSize: R.rw(14, context), fontWeight: FontWeight.w300),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(R.rw(8, context))))),
        SizedBox(height: R.rh(20, context)),
      ],
    );
  }
}
