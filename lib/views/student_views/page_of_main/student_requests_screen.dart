import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';
import 'package:gr_flutter/views/widgets/default_no_data.dart';

import '../../../controllers/student_controller/student_requests_controller.dart';
import '../../../utils/app_constants/tooth_constants.dart';
import '../../widgets/request_container.dart';

class StudentRequestsScreen extends StatelessWidget {
  final StudentRequestsControllerImp controller =
      Get.put(StudentRequestsControllerImp());
  StudentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentRequestsControllerImp>(builder: (_) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: controller.showMyRequest,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(width: 1,color: Colors.blue,strokeAlign: 10),
              borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
            
            boxShadow: [
              BoxShadow(
                color: Colors.white,blurRadius: 3,spreadRadius: 3,
              )
            ]
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [FaIcon(FontAwesomeIcons.tooth),Text("  طلباتي"),],),),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: ToothConstants.filterRequest.length,
                itemBuilder: (context, index) {
                  return BottomContainer(
                    body: ToothConstants.filterRequest[index],
                    onTap: () {
                      controller.updateFilterRequest(index);
                    },
                    selected: controller.filterRequest ==
                        ToothConstants.filterRequest[index],
                  );
                },
              ),
            ),
            SizedBox(
                // height: 10,
                ),
            // if (controller.filterExpanded != "")
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeIn,
              margin: EdgeInsets.all(10),
              height: 25,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: controller.listFilterExpanded.length,
                itemBuilder: (context, index) {
                  return BottomContainer(
                    body: controller.listFilterExpanded[index],
                    selected: controller.filterExpanded ==
                        controller.listFilterExpanded[index],
                    onTap: () {
                      controller.updateFilterExpaded(index);
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text("عدد الحالات الكلي: "),
                      Text(
                        controller.requestList.length.toString(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("عدد الحالات المفلترة: "),
                      Text(
                        controller.requestListFilter.length.toString(),
                      ),
                    ],
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     controller.fetchItems();
                  //   },
                  //   child: Icon(Icons.upload),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchItems();
                },

                child: controller.requestListFilter.isEmpty
                    ? DefaultNoData()
                    : ListView.builder(
                        itemCount: controller.requestListFilter.length,
                        itemBuilder: (context, index) {
                          return RequestContainer(
                            requestModel: controller.requestListFilter[index],
                            onTap: () {
                              controller.showRequest(index);
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
