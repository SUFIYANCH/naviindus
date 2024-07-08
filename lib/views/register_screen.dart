import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naviindus/models/branch_model.dart' as branch_model;
import 'package:naviindus/models/register_model.dart';
import 'package:naviindus/models/treatment_model.dart';
import 'package:naviindus/services/api_service.dart';
import 'package:naviindus/services/select_notifier.dart';
import 'package:naviindus/utils/app_color.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';
import 'package:naviindus/utils/snackbar.dart';
import 'package:naviindus/widgets/button.dart';
import 'package:path/path.dart' as path;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:naviindus/widgets/textfield.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? selectedLocation;
  int? selectedHour;
  int? selectedMinute;
  int maleCount = 0;
  int femaleCount = 0;
  List<String> branchNames = [];
  List<Treatment> treatmentList = [];
  List<int> maleList = [];
  List<int> femaleList = [];
  String? selectedPayment = "Cash";
  DateTime? pickedDate = DateTime.now();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmtController = TextEditingController();
  final TextEditingController discountAmtController = TextEditingController();
  final TextEditingController advanceAmtController = TextEditingController();
  final TextEditingController balanceAmtController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    totalAmtController.dispose();
    discountAmtController.dispose();
    advanceAmtController.dispose();
    balanceAmtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    List<DropdownMenuItem<int>> hourItems = [];
    for (int i = 0; i <= 23; i++) {
      hourItems.add(
        DropdownMenuItem(value: i, child: Text(i.toString())),
      );
    }
    List<DropdownMenuItem<int>> minuteItems = [];
    for (int i = 0; i <= 59; i++) {
      minuteItems.add(
        DropdownMenuItem(value: i, child: Text(i.toString())),
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
          Icon(Icons.notifications_active_outlined, size: R.rw(28, context)),
          SizedBox(width: R.rw(10, context))
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
                    items: const [
                      DropdownMenuItem(
                          value: "Kottayam", child: Text("Kottayam")),
                      DropdownMenuItem(value: "Kochi", child: Text("Kochi")),
                      DropdownMenuItem(
                          value: "Kozhikode", child: Text("Kozhikode")),
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
                  Text(" Branch",
                      style: TextStyle(fontSize: R.rw(16, context))),
                  SizedBox(height: R.rh(6, context)),
                  FutureBuilder(
                      future: apiService.branchApi(),
                      builder: (context, snapshot) {
                        branch_model.BranchModel? data = snapshot.data;
                        return DropdownButtonFormField(
                          value: Provider.of<SelectedNotifier>(context)
                              .selectedBranch
                              ?.id,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: primaryColor,
                          ),
                          items: ((data?.branches) ?? [])
                              .map((e) => DropdownMenuItem(
                                  value: e.id, child: Text(e.name.toString())))
                              .toList(),
                          onChanged: (value) {
                            log(value!.toString());
                            for (var i in data!.branches!) {
                              if (i.id == value) {
                                Provider.of<SelectedNotifier>(context,
                                        listen: false)
                                    .selectBranch(i);
                              }
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(R.rw(12, context)),
                              filled: true,
                              fillColor:
                                  const Color(0xffD9D9D9).withOpacity(0.25),
                              hintText: "Select the branch",
                              hintStyle: TextStyle(
                                  fontSize: R.rw(14, context),
                                  fontWeight: FontWeight.w300),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(R.rw(8, context)))),
                        );
                      }),
                  SizedBox(height: R.rh(20, context)),
                  Text(" Treatments",
                      style: TextStyle(fontSize: R.rw(16, context))),
                  SizedBox(height: R.rh(6, context)),
                  treatmentsList(),
                  SizedBox(height: R.rh(10, context)),
                  addTreatments(context, apiService),
                  SizedBox(height: R.rh(20, context)),
                  TextfieldWidget(
                      keyboardtype: TextInputType.number,
                      headText: "Total Amount",
                      textcontroller: totalAmtController),
                  TextfieldWidget(
                      keyboardtype: TextInputType.number,
                      headText: "Discount Amount",
                      textcontroller: discountAmtController),
                  Text(" Payment Option",
                      style: TextStyle(fontSize: R.rw(16, context))),
                  SizedBox(height: R.rh(6, context)),
                  paymentOptions(context),
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
                  treatmentDate(context),
                  SizedBox(height: R.rh(20, context)),
                  Text(" Treatment Time",
                      style: TextStyle(fontSize: R.rw(16, context))),
                  SizedBox(height: R.rh(6, context)),
                  treatmentTime(hourItems, context, minuteItems),
                  SizedBox(height: R.rh(50, context)),
                  ButtonWidget(
                    text: "Save",
                    onpressed: () {
                      if (nameController.text.isNotEmpty &&
                          whatsappController.text.isNotEmpty &&
                          addressController.text.isNotEmpty &&
                          selectedLocation.toString().isNotEmpty &&
                          Provider.of<SelectedNotifier>(context, listen: false)
                                  .selectedBranch
                                  ?.id !=
                              null &&
                          treatmentList.isNotEmpty &&
                          totalAmtController.text.isNotEmpty &&
                          discountAmtController.text.isNotEmpty &&
                          advanceAmtController.text.isNotEmpty &&
                          balanceAmtController.text.isNotEmpty &&
                          selectedPayment.toString().isNotEmpty &&
                          pickedDate.toString().isNotEmpty &&
                          selectedHour.toString().isNotEmpty &&
                          selectedMinute.toString().isNotEmpty) {
                        apiService
                            .registerApi(RegisterModel(
                                name: nameController.text,
                                executive: selectedLocation.toString(),
                                payment: selectedPayment.toString(),
                                phone: whatsappController.text,
                                address: addressController.text,
                                totalAmount:
                                    double.parse(totalAmtController.text),
                                discountAmount:
                                    double.parse(discountAmtController.text),
                                advanceAmount:
                                    double.parse(advanceAmtController.text),
                                balanceAmount:
                                    double.parse(balanceAmtController.text),
                                dateNdTime:
                                    " ${pickedDate.toString().split(' ')}-${formatTime(selectedHour!, selectedMinute!)}",
                                id: '',
                                male: List.generate(treatmentList.length,
                                    (index) => treatmentList[index].id!),
                                female: List.generate(treatmentList.length,
                                    (index) => treatmentList[index].id!),
                                branch: Provider.of<SelectedNotifier>(context,
                                        listen: false)
                                    .selectedBranch!
                                    .id
                                    .toString(),
                                treatments: List.generate(treatmentList.length,
                                    (index) => treatmentList[index].id!)))
                            .then((value) {
                          snackbar("Created Successfully", context);
                          Navigator.pop(context);
                          createPDF(context);
                        });
                      } else {
                        snackbar("Please fill all the fields", context);
                      }
                    },
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

  ListView treatmentsList() {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: Color(0xffF1F1F1),
                borderRadius: BorderRadius.circular(R.rw(12, context))),
            child: Padding(
              padding: EdgeInsets.only(
                  left: R.rw(12, context),
                  right: R.rw(12, context),
                  top: R.rw(16, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${index + 1}.   ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: R.rw(18, context))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: R.rw(250, context),
                            child: Text(
                              treatmentList[index].name.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: R.rw(18, context)),
                            ),
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
                                          fontWeight: FontWeight.w400,
                                          fontSize: R.rw(16, context),
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
                                        borderRadius: BorderRadius.circular(
                                            R.rw(4, context))),
                                    child: Text(maleList[index].toString()),
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
                                          fontWeight: FontWeight.w400,
                                          fontSize: R.rw(16, context),
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
                                        borderRadius: BorderRadius.circular(
                                            R.rw(4, context))),
                                    child: Text(femaleList[index].toString()),
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
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            treatmentList.removeAt(index);
                            maleList.removeAt(index);
                            femaleList.removeAt(index);
                            totalAmtController.text = totalAmtFunc();
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      Icon(
                        Icons.edit,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: R.rh(6, context),
            ),
        itemCount: treatmentList.length);
  }

  ElevatedButton addTreatments(BuildContext context, ApiService service) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color.fromARGB(220, 148, 193, 173),
            fixedSize: Size(R.maxWidth(context), R.rh(50, context)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(R.rw(10, context)))),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder:
                  (BuildContext context, void Function(void Function()) state) {
                return Consumer(builder: (context, ref, child) {
                  return SimpleDialog(
                    contentPadding: EdgeInsets.all(R.rw(16, context)),
                    children: [
                      SizedBox(height: R.rh(30, context)),
                      Text(
                        " Choose Treatment",
                        style: TextStyle(fontSize: R.rw(16, context)),
                      ),
                      SizedBox(height: R.rh(6, context)),
                      FutureBuilder(
                          future: service.treatmentApi(),
                          builder: (context, snapshot) {
                            TreatmentModel? data = snapshot.data;
                            return DropdownButtonFormField(
                              isExpanded: true,
                              value: Provider.of<SelectedNotifier>(context)
                                  .selectedTreatment
                                  ?.id,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primaryColor,
                              ),
                              items: ((data?.treatments) ?? [])
                                  .map((e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.name.toString())))
                                  .toList(),
                              onChanged: (value) {
                                for (var i in data!.treatments!) {
                                  if (i.id == value) {
                                    Provider.of<SelectedNotifier>(context,
                                            listen: false)
                                        .selectTreatment(i);
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.all(R.rw(12, context)),
                                  filled: true,
                                  fillColor:
                                      const Color(0xffD9D9D9).withOpacity(0.25),
                                  hintText: "Select prefered treatment",
                                  hintStyle: TextStyle(
                                      fontSize: R.rw(14, context),
                                      fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          R.rw(8, context)))),
                            );
                          }),
                      SizedBox(height: R.rh(20, context)),
                      Text(
                        " Add Patients",
                        style: TextStyle(fontSize: R.rw(16, context)),
                      ),
                      SizedBox(height: R.rh(6, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: R.rh(45, context),
                            width: R.rw(90, context),
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.circular(R.rw(12, context))),
                            child: Text("Male"),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  state(() {
                                    if (maleCount > 0) {
                                      maleCount--;
                                    }
                                  });
                                },
                                child: Container(
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
                                child: Text(maleCount.toString()),
                              ),
                              SizedBox(width: R.rw(10, context)),
                              GestureDetector(
                                onTap: () {
                                  state(() {
                                    maleCount++;
                                  });
                                },
                                child: Container(
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
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: R.rh(20, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: R.rh(45, context),
                            width: R.rw(90, context),
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.circular(R.rw(12, context))),
                            child: Text("Female"),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  state(() {
                                    if (femaleCount > 0) {
                                      femaleCount--;
                                    }
                                  });
                                },
                                child: Container(
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
                                child: Text(femaleCount.toString()),
                              ),
                              SizedBox(width: R.rw(10, context)),
                              GestureDetector(
                                onTap: () {
                                  state(() {
                                    femaleCount++;
                                  });
                                },
                                child: Container(
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
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: R.rh(20, context)),
                      ButtonWidget(
                        text: "Save",
                        onpressed: () {
                          if (Provider.of<SelectedNotifier>(context,
                                      listen: false)
                                  .selectedTreatment !=
                              null) {
                            treatmentList.add(Provider.of<SelectedNotifier>(
                                    context,
                                    listen: false)
                                .selectedTreatment!);
                            maleList.add(maleCount);
                            femaleList.add(femaleCount);
                            Navigator.pop(context);
                            maleCount = 0;
                            femaleCount = 0;
                            Provider.of<SelectedNotifier>(context,
                                    listen: false)
                                .selectTreatment(null);
                            setState(() {
                              totalAmtController.text = totalAmtFunc();
                            });
                          }
                        },
                      ),
                      SizedBox(height: R.rh(30, context)),
                    ],
                  );
                });
              },
            ),
          );
        },
        child: Text(
          "+ Add Treatments",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: R.rw(17, context)),
        ));
  }

  Row treatmentTime(List<DropdownMenuItem<int>> hourItems, BuildContext context,
      List<DropdownMenuItem<int>> minuteItems) {
    return Row(
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
                selectedHour = value;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(R.rw(12, context)),
                filled: true,
                fillColor: Color(0xffD9D9D9).withOpacity(0.25),
                hintText: "Hour",
                hintStyle: TextStyle(
                    fontSize: R.rw(14, context), fontWeight: FontWeight.w300),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(R.rw(12, context)))),
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
                selectedMinute = value;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(R.rw(12, context)),
                filled: true,
                fillColor: Color(0xffD9D9D9).withOpacity(0.25),
                hintText: "Minutes",
                hintStyle: TextStyle(
                    fontSize: R.rw(14, context), fontWeight: FontWeight.w300),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(R.rw(12, context)))),
          ),
        ),
      ],
    );
  }

  ElevatedButton treatmentDate(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(R.maxWidth(context), R.rh(50, context)),
            elevation: 0,
            backgroundColor: Color(0xffD9D9D9).withOpacity(0.25),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(R.rw(8, context)))),
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
        ));
  }

  Row paymentOptions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
    ]);
  }

  createPDF(BuildContext con) async {
    var logo = (await rootBundle.load("assets/logo.png")).buffer.asUint8List();
    var sign = (await rootBundle.load("assets/sign.png")).buffer.asUint8List();

    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(fontSize: 16)),
        build: (pw.Context context) {
          return pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(pw.MemoryImage(logo), width: 85, height: 85),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                                Provider.of<SelectedNotifier>(con,
                                        listen: false)
                                    .selectedBranch!
                                    .name
                                    .toString()
                                    .toUpperCase(),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                Provider.of<SelectedNotifier>(con,
                                        listen: false)
                                    .selectedBranch!
                                    .address
                                    .toString(),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                "email: ${Provider.of<SelectedNotifier>(con, listen: false).selectedBranch!.mail}",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                "Mob: ${Provider.of<SelectedNotifier>(con, listen: false).selectedBranch!.phone}",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                "GST No: ${Provider.of<SelectedNotifier>(con, listen: false).selectedBranch!.gst}",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                            pw.SizedBox(height: 16)
                          ])
                    ]),
                pw.Divider(color: PdfColors.grey400),
                pw.SizedBox(height: 16),
                pw.Text("Patient Details",
                    style: pw.TextStyle(
                        color: PdfColor.fromInt(0xFF006837),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Name",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                            pw.SizedBox(height: 8),
                            pw.Text("Address",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                            pw.SizedBox(height: 8),
                            pw.Text("Whatsapp Number",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                          ]),
                      pw.SizedBox(width: 16),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(nameController.text,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 8),
                            pw.Text(addressController.text,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              whatsappController.text,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14,
                                  color: PdfColor.fromInt(0xff9A9A9A)),
                            ),
                          ]),
                      pw.Spacer(),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Booked On",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                            pw.SizedBox(height: 8),
                            pw.Text("Treatment Date",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                            pw.SizedBox(height: 8),
                            pw.Text("Treatment Time",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                          ]),
                      pw.SizedBox(width: 16),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(DateTime.now().toString().substring(0, 10),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 8),
                            pw.Text(
                                pickedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')
                                    .first,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                            pw.SizedBox(height: 8),
                            pw.Text(formatTime(selectedHour!, selectedMinute!),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                    color: PdfColor.fromInt(0xff9A9A9A))),
                          ]),
                    ]),
                pw.Divider(
                    color: PdfColors.grey400,
                    borderStyle: pw.BorderStyle.dotted),
                pw.SizedBox(
                  height: 16,
                ),
                pw.Table(
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 16),
                        child: pw.Text("Treatment",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF006837),
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 16),
                        child: pw.Text("Price",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF006837),
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 16),
                        child: pw.Text("Male",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF006837),
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 16),
                        child: pw.Text("Female",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF006837),
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 16),
                        child: pw.Text("Total",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF006837),
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ]),
                    for (int i = 0; i < treatmentList.length; i++)
                      pw.TableRow(children: [
                        pw.Text(treatmentList[i].name.toString(),
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff9A9A9A),
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 16)),
                        pw.Text("${treatmentList[i].price}",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff9A9A9A),
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 16)),
                        pw.Text(maleList[0].toString(),
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff9A9A9A),
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 16)),
                        pw.Text(femaleList[0].toString(),
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff9A9A9A),
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 16)),
                        pw.Text(
                            "${(femaleList[0] + maleList[0]) * int.parse(treatmentList[i].price!)}",
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff9A9A9A),
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 16)),
                      ]),
                  ],
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Divider(
                    color: PdfColors.grey400,
                    borderStyle: pw.BorderStyle.dotted),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Column(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceAround,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("Total Amount",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 16)),
                                  pw.SizedBox(
                                    height: 8,
                                  ),
                                  pw.Text("Discount",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 16)),
                                  pw.SizedBox(
                                    height: 8,
                                  ),
                                  pw.Text("Advance",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 16)),
                                  pw.SizedBox(
                                    height: 16,
                                  ),
                                  pw.Text("Balance",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 16)),
                                ]),
                            pw.SizedBox(
                              width: 40,
                            ),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text(totalAmtFunc(),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 16)),
                                  pw.SizedBox(
                                    height: 8,
                                  ),
                                  pw.Text(discountAmtController.text,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 16)),
                                  pw.SizedBox(
                                    height: 8,
                                  ),
                                  pw.Text(advanceAmtController.text,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 16)),
                                  pw.SizedBox(
                                    height: 16,
                                  ),
                                  pw.Text(
                                      "${(int.parse(totalAmtFunc()) - (int.parse(advanceAmtController.text) + int.parse(discountAmtController.text)))}",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 16)),
                                ]),
                          ]),
                      pw.SizedBox(
                        height: 50,
                      ),
                      pw.Text("Thank you for choosing us",
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFF006837),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18)),
                      pw.SizedBox(
                        height: 16,
                      ),
                      pw.Text(
                          "Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(0xff9A9A9A),
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10)),
                      pw.SizedBox(
                        height: 16,
                      ),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(right: 50),
                          child: pw.Image(pw.MemoryImage(sign),
                              width: 100, height: 45)),
                    ]),
                pw.Spacer(),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                    '"Booking amount is non-refundable, and its important to arrive on the allotted time for your treatment"',
                    style: pw.TextStyle(
                        color: PdfColor.fromInt(0xff9A9A9A),
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 10)),
              ]));
        }));
    final dir = await getTemporaryDirectory();
    const fileName = "sample.pdf";
    final savePath = path.join(dir.path, fileName);
    final file = File(savePath);
    await file.writeAsBytes(await doc.save());
    OpenFilex.open(file.path);
  }

  String totalAmtFunc() {
    int sum = 0;
    for (var i = 0; i < treatmentList.length; i++) {
      sum += (maleList[i] + femaleList[i]) * int.parse(treatmentList[i].price!);
    }
    return sum.toString();
  }

  String formatTime(int hours, int minutes) {
    int hour = hours;
    int minute = minutes;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    String formattedHour = hour.toString();
    log('$formattedHour:$minute  $period');
    return '$formattedHour:$minute  $period';
  }
}
