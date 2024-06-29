import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naviindus/models/branch_model.dart';
import 'package:naviindus/services/api_service.dart';
import 'package:naviindus/utils/app_color.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';
import 'package:naviindus/widgets/button.dart';
import 'package:naviindus/widgets/textfield.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  String? selectedLocation;
  String? selectedHour;
  String? selectedMinute;
  Branch? selectedBranch;
  List<String> branchNames = [];

  List<String> treatmentList = [];
  List<int> maleList = [];
  List<int> femaleList = [];
  String? selectedPayment = "Cash";
  DateTime? pickedDate = DateTime.now();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController totalAmtController = TextEditingController();
  final TextEditingController discountAmtController = TextEditingController();
  final TextEditingController advanceAmtController = TextEditingController();
  final TextEditingController balanceAmtController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> hourItems = [];
    for (int i = 0; i <= 23; i++) {
      hourItems.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Text(i.toString()),
        ),
      );
    }
    List<DropdownMenuItem<String>> minuteItems = [];
    for (int i = 0; i <= 59; i++) {
      minuteItems.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Text(i.toString()),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Register",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: R.rw(24, context)),
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.notifications_active_outlined,
            size: R.rw(28, context),
          ),
          SizedBox(
            width: R.rw(10, context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: EdgeInsets.all(R.rw(16, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextfieldWidget(
                      headText: "Name",
                      hinttext: "Enter your full name",
                      textcontroller: nameController),
                  TextfieldWidget(
                      headText: "Whatsapp Number",
                      hinttext: "Enter your whatsapp number",
                      textcontroller: whatsappController),
                  TextfieldWidget(
                      headText: "Address",
                      hinttext: "Enter your full address",
                      textcontroller: addressController),
                  Text(
                    " Location",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(height: R.rh(6, context)),
                  DropdownButtonFormField(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: primaryColor,
                    ),
                    items: [
                      DropdownMenuItem(
                          child: Text("Kottayam"), value: "Kottayam"),
                      DropdownMenuItem(child: Text("Kochi"), value: "Kochi"),
                      DropdownMenuItem(
                          child: Text("Kozhikode"), value: "Kozhikode"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value.toString();
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(R.rw(12, context)),
                        filled: true,
                        fillColor: const Color(0xffD9D9D9).withOpacity(0.25),
                        hintText: "Choose your location",
                        hintStyle: TextStyle(
                            fontSize: R.rw(14, context),
                            fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(R.rw(8, context)))),
                  ),
                  SizedBox(height: R.rh(20, context)),
                  Text(
                    " Branch",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(height: R.rh(6, context)),
                  ref.watch(branchListProvider).when(
                        data: (data) {
                          return DropdownButtonFormField(
                            value: selectedBranch,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: primaryColor,
                            ),
                            items: ((data?.branches) ?? [])
                                .map((e) => DropdownMenuItem<Branch>(
                                    value: e, child: Text(e.name.toString())))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedBranch = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.all(R.rw(12, context)),
                                filled: true,
                                fillColor:
                                    const Color(0xffD9D9D9).withOpacity(0.25),
                                hintText: "Select the branch",
                                hintStyle: TextStyle(
                                    fontSize: R.rw(14, context),
                                    fontWeight: FontWeight.w300),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        R.rw(8, context)))),
                          );
                        },
                        error: (error, stackTrace) => Center(
                          child: Text(e.toString()),
                        ),
                        loading: () => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  SizedBox(height: R.rh(20, context)),
                  Text(
                    " Treatments",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(height: R.rh(6, context)),
                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Color(0xffF1F1F1),
                              borderRadius:
                                  BorderRadius.circular(R.rw(12, context))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: R.rw(12, context),
                                right: R.rw(12, context),
                                top: R.rw(16, context)),
                            child: Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${index + 1}.   ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: R.rw(18, context))),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Treatment Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: R.rw(18, context)),
                                      ),
                                      SizedBox(
                                        height: R.rh(2, context),
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Male",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          R.rw(16, context),
                                                      color: primaryColor)),
                                              SizedBox(
                                                width: R.rw(8, context),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: R.rh(25, context),
                                                width: R.rw(40, context),
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            R.rw(4, context))),
                                                child: Text('2'),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: R.rw(24, context),
                                          ),
                                          Row(
                                            children: [
                                              Text("Female",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          R.rw(16, context),
                                                      color: primaryColor)),
                                              SizedBox(
                                                width: R.rw(8, context),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: R.rh(25, context),
                                                width: R.rw(40, context),
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            R.rw(4, context))),
                                                child: Text('2'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: R.rh(6, context),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      Icon(
                                        Icons.edit,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: R.rh(6, context),
                          ),
                      itemCount: 1),
                  SizedBox(height: R.rh(10, context)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Color.fromARGB(220, 148, 193, 173),
                          fixedSize:
                              Size(R.maxWidth(context), R.rh(50, context)),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(R.rw(10, context)))),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            contentPadding: EdgeInsets.all(R.rw(16, context)),
                            children: [
                              SizedBox(height: R.rh(30, context)),
                              Text(
                                " Choose Treatment",
                                style: TextStyle(fontSize: R.rw(16, context)),
                              ),
                              SizedBox(height: R.rh(6, context)),
                              DropdownButtonFormField(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: primaryColor,
                                ),
                                items: [],
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.all(R.rw(12, context)),
                                    filled: true,
                                    fillColor: const Color(0xffD9D9D9)
                                        .withOpacity(0.25),
                                    hintText: "Select prefered treatment",
                                    hintStyle: TextStyle(
                                        fontSize: R.rw(14, context),
                                        fontWeight: FontWeight.w300),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            R.rw(8, context)))),
                              ),
                              SizedBox(height: R.rh(20, context)),
                              Text(
                                " Add Patients",
                                style: TextStyle(fontSize: R.rw(16, context)),
                              ),
                              SizedBox(height: R.rh(6, context)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: R.rh(45, context),
                                    width: R.rw(90, context),
                                    decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(
                                            R.rw(12, context))),
                                    child: Text("Male"),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: R.rh(40, context),
                                        width: R.rw(40, context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: R.rw(24, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: R.rw(10, context)),
                                      Container(
                                        alignment: Alignment.center,
                                        height: R.rh(45, context),
                                        width: R.rw(45, context),
                                        decoration: BoxDecoration(
                                            color: Color(0xffD9D9D9),
                                            border: Border.all(),
                                            borderRadius: BorderRadius.circular(
                                                R.rw(12, context))),
                                        child: Text("0"),
                                      ),
                                      SizedBox(width: R.rw(10, context)),
                                      Container(
                                        alignment: Alignment.center,
                                        height: R.rh(40, context),
                                        width: R.rw(40, context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: R.rw(24, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: R.rh(20, context)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: R.rh(45, context),
                                    width: R.rw(90, context),
                                    decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(
                                            R.rw(12, context))),
                                    child: Text("Female"),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: R.rh(40, context),
                                        width: R.rw(40, context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: R.rw(24, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: R.rw(10, context)),
                                      Container(
                                        alignment: Alignment.center,
                                        height: R.rh(45, context),
                                        width: R.rw(45, context),
                                        decoration: BoxDecoration(
                                            color: Color(0xffD9D9D9),
                                            border: Border.all(),
                                            borderRadius: BorderRadius.circular(
                                                R.rw(12, context))),
                                        child: Text("0"),
                                      ),
                                      SizedBox(width: R.rw(10, context)),
                                      Container(
                                        alignment: Alignment.center,
                                        height: R.rh(40, context),
                                        width: R.rw(40, context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: R.rw(24, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: R.rh(20, context)),
                              ButtonWidget(
                                text: "Save",
                                onpressed: () {},
                              ),
                              SizedBox(height: R.rh(30, context)),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "+ Add Treatments",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: R.rw(17, context)),
                      )),
                  SizedBox(height: R.rh(20, context)),
                  TextfieldWidget(
                      keyboardtype: TextInputType.number,
                      headText: "Total Amount",
                      textcontroller: totalAmtController),
                  TextfieldWidget(
                      keyboardtype: TextInputType.number,
                      headText: "Discount Amount",
                      textcontroller: discountAmtController),
                  Text(
                    " Payment Option",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(height: R.rh(6, context)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Cash',
                                groupValue: selectedPayment,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPayment = value.toString();
                                  });
                                },
                              ),
                              Text(
                                'Cash',
                                style: TextStyle(fontSize: R.rw(16, context)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Card',
                                groupValue: selectedPayment,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPayment = value.toString();
                                  });
                                },
                              ),
                              Text(
                                'Card',
                                style: TextStyle(fontSize: R.rw(16, context)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'UPI',
                                groupValue: selectedPayment,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPayment = value.toString();
                                  });
                                },
                              ),
                              Text(
                                'UPI',
                                style: TextStyle(fontSize: R.rw(16, context)),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  SizedBox(height: R.rh(20, context)),
                  TextfieldWidget(
                      keyboardtype: TextInputType.number,
                      headText: "Advance Amount",
                      textcontroller: advanceAmtController),
                  TextfieldWidget(
                      keyboardtype: TextInputType.number,
                      headText: "Balance Amount",
                      textcontroller: balanceAmtController),
                  Text(
                    " Treatment Date",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(height: R.rh(6, context)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(R.maxWidth(context), R.rh(50, context)),
                          elevation: 0,
                          backgroundColor: Color(0xffD9D9D9).withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black54),
                              borderRadius:
                                  BorderRadius.circular(R.rw(8, context)))),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900, 8),
                          lastDate: DateTime(2060),
                        );
                        setState(() {
                          if (picked != null) {
                            pickedDate = picked;
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pickedDate.toString().substring(0, 10),
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.calendar_month,
                            color: primaryColor,
                          ),
                        ],
                      )),
                  SizedBox(height: R.rh(20, context)),
                  Text(
                    " Treatment Time",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(height: R.rh(6, context)),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: primaryColor,
                          ),
                          items: hourItems,
                          onChanged: (value) {
                            setState(() {
                              selectedHour = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(R.rw(12, context)),
                              filled: true,
                              fillColor: Color(0xffD9D9D9).withOpacity(0.25),
                              hintText: "Hour",
                              hintStyle: TextStyle(
                                  fontSize: R.rw(14, context),
                                  fontWeight: FontWeight.w300),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      R.rw(12, context)))),
                        ),
                      ),
                      SizedBox(
                        width: R.rw(10, context),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: primaryColor,
                          ),
                          items: minuteItems,
                          onChanged: (value) {
                            setState(() {
                              selectedMinute = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(R.rw(12, context)),
                              filled: true,
                              fillColor: Color(0xffD9D9D9).withOpacity(0.25),
                              hintText: "Minutes",
                              hintStyle: TextStyle(
                                  fontSize: R.rw(14, context),
                                  fontWeight: FontWeight.w300),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      R.rw(12, context)))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: R.rh(50, context)),
                  ButtonWidget(
                    text: "Save",
                    onpressed: () {},
                  ),
                  SizedBox(height: R.rh(40, context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
