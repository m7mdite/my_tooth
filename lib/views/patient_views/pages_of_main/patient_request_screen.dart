import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/patient_request_controller.dart';
import 'package:gr_flutter/controllers/requests_controllers/fill_request_controller.dart';
import 'package:gr_flutter/views/patient_views/dialog_request/dialog_send_request.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';
import 'package:gr_flutter/views/widgets/requests/card_request_processing.dart';

import '../../widgets/requests/request_container.dart';

// import 'request_details_screen.dart';
// import 'requests_list_screen.dart';

class PatientRequestScreen extends StatelessWidget {
  final PatientRequestControllerImp controller =
      Get.put(PatientRequestControllerImp());
  final FillRequestControllerImp controllerr =
      Get.put(FillRequestControllerImp());

  PatientRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Get.dialog(
              DialogSendRequest(
                send: () {
                  controller.sendRequest();
                },
                cancel: () {
                  controller.cancelSendRequest();
                },
              ),
            );
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "images/images_asnan/afeb34f1-66ab-49ac-a13a-e92af739f8e3.jpeg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.linearToSrgbGamma()),
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(100, 10),
                bottomLeft: Radius.elliptical(10, 100),
                topRight: Radius.elliptical(10, 100),
                bottomRight: Radius.elliptical(100, 10),
              ),
              border: Border(
                  right: BorderSide(
                    color: Colors.green,
                  ),
                  bottom: BorderSide(
                    color: Colors.green,
                  )),
            ),
            child: Center(
              child: Text(
                "تقديم طلب",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // BottomContainer(
        //   body: "تقديم طلب",
        //   paddingHorizontal: 20,
        //   onTap: () {
        //     controllerr.showDialog("send");
        //   },
        // ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("طلباتي"),
            InkWell(
              onTap: () {
                controller.refreshData();
              },
              child: Icon(
                Icons.refresh_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          width: Get.width * 0.75,
          color: Colors.blue,
        ),
        SizedBox(
          height: 10,
        ),
        GetBuilder<PatientRequestControllerImp>(builder: (_) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  controller.toPageView(0);
                },
                child: Text(
                  "قيد الإنتظار",
                  style: TextStyle(
                    color: controller.currentPageFilter == 0
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.toPageView(1);
                },
                child: Text(
                  "قيد المعالجة ",
                  style: TextStyle(
                    color: controller.currentPageFilter == 1
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.toPageView(2);
                },
                child: Text(
                  "الطلبات المعالجة",
                  style: TextStyle(
                    color: controller.currentPageFilter == 2
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
            ],
          );
        }),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: 3,
            onPageChanged: (value) {
              controller.currentPageFilter = value;
              controller.update();
            },
            itemBuilder: (context, indexPage) {
              return GetBuilder<PatientRequestControllerImp>(
                builder: (_) {
                  return controller.getListRequest().isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.getListRequest().length,
                          itemBuilder: (context, index) {
                            return controller.currentPageFilter == 0
                                ? RequestContainer(
                                    onTap: () {
                                      controller.showRequest(controller
                                          .requestListPending[index]);
                                    },
                                    requestModel:
                                        controller.getListRequest()[index],
                                  )
                                : controller.currentPageFilter == 1
                                    ? CardRequestProcessing(
                                        requestModel: controller
                                            .requestListProcessing[index],
                                        onTap: () {
                                          controller.showProcessingRequest(controller
                                            .requestListProcessing[index]);
                                        },
                                      )
                                    : CardRequestProcessing(
                                        requestModel: controller
                                            .requestListCompleted[index],
                                        onTap: () {},
                                      );
                          },
                        )
                      : DefaultNoData();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
