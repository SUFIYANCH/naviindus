import 'package:flutter/material.dart';
import 'package:naviindus/services/api_service.dart';
import 'package:naviindus/utils/app_color.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';
import 'package:naviindus/views/register_screen.dart';
import 'package:naviindus/widgets/button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(R.rw(16, context)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.black45),
                            contentPadding: EdgeInsets.all(R.rw(10, context)),
                            hintText: "Search for treatments",
                            hintStyle: TextStyle(
                                fontSize: R.rw(14, context),
                                fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(R.rw(8, context))))),
                  ),
                  SizedBox(width: R.rw(8, context)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(R.rw(6, context)))),
                      onPressed: () {},
                      child: const Text("Search")),
                ],
              ),
            ),
            SizedBox(height: R.rh(8, context)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: R.rw(16, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sort by :",
                    style: TextStyle(fontSize: R.rw(16, context)),
                  ),
                  SizedBox(width: R.rw(8, context)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: const BorderSide(color: Colors.black54)),
                      onPressed: () {},
                      child: Row(
                        children: [
                          const Text(
                            "Date",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: R.rw(16, context),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: primaryColor,
                          )
                        ],
                      ))
                ],
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: apiService.patientListApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text("Patient List is empty!!!"),
                  );
                } else {
                  final data = snapshot.data!;
                  return Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: R.rw(16, context),
                          vertical: R.rh(8, context)),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffF1F1F1),
                              borderRadius:
                                  BorderRadius.circular(R.rw(12, context))),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: R.rw(12, context),
                                    right: R.rw(12, context),
                                    top: R.rw(16, context)),
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
                                          data.patient![index].name.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: R.rw(18, context)),
                                        ),
                                        SizedBox(height: R.rh(2, context)),
                                        SizedBox(
                                          width: R.rw(250, context),
                                          child: Text(
                                              data
                                                  .patient![index]
                                                  .patientdetailsSet![0]
                                                  .treatmentName
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: R.rw(16, context))),
                                        ),
                                        SizedBox(height: R.rh(10, context)),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: Colors.red,
                                                    size: R.rw(18, context)),
                                                SizedBox(
                                                    width: R.rw(4, context)),
                                                if (data.patient![index]
                                                        .dateNdTime !=
                                                    null)
                                                  Text(data.patient![index]
                                                      .dateNdTime!
                                                      .split("T")[0]),
                                                if (data.patient![index]
                                                        .dateNdTime ==
                                                    null)
                                                  Text(data.patient![index]
                                                      .createdAt!
                                                      .split("T")[0])
                                              ],
                                            ),
                                            SizedBox(width: R.rw(24, context)),
                                            Row(
                                              children: [
                                                Icon(Icons.group_outlined,
                                                    color: Colors.red,
                                                    size: R.rw(18, context)),
                                                SizedBox(
                                                    width: R.rw(4, context)),
                                                const Text("Jithesh",
                                                    style: TextStyle(
                                                        color: Colors.black54))
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: R.rh(4, context)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("View Booking details",
                                      style: TextStyle(
                                          fontSize: R.rw(16, context),
                                          fontWeight: FontWeight.w400)),
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      size: R.rw(20, context),
                                      color: primaryColor)
                                ],
                              ),
                              SizedBox(height: R.rh(8, context))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: R.rh(10, context),
                      ),
                      itemCount: data.patient!.length,
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(R.rw(16, context)),
              child: ButtonWidget(
                onpressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ));
                },
                text: "Register Now",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
