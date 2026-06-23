
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gr_flutter/controllers/requests_controllers/fill_request_controller.dart';
import 'package:gr_flutter/controllers/patient_controller/patient_request_controller.dart';
import 'package:gr_flutter/services/functions/show_tooth_location_map.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';

// import '../../controllers/patient_controller/submitting_request_patient_controller.dart';
import '../../utils/app_constants/tooth_constants.dart';
import '../widgets/select_one_option.dart';

class ModifiedRequest extends StatelessWidget {
  final FillRequestControllerImp controller =
      Get.put(FillRequestControllerImp());
  final PatientRequestControllerImp patientRequestControllerImp =
      Get.find<PatientRequestControllerImp>();
  final Widget? bottomNavigationBar;
  ModifiedRequest({
    super.key,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    // ادوية او مكملااات
    // bool medicines = false;
    // // امراض مزمنة
    // bool chronicDiseases = false;
    // bool? previousTreatment   = controller.requestSendModel.moreDetails!.previousTreatment;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.1, vertical: Get.height * 0.1),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              AppConstants.defaultBackgroundImage,
            ),
            fit: BoxFit.cover,
            opacity: 0.9,
            colorFilter: ColorFilter.linearToSrgbGamma()),
        color: const Color.fromARGB(0, 255, 255, 255),
        border: Border.all(
          color: Colors.white,
          width: 2,
          strokeAlign: 10,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 1),
          bottomLeft: Radius.elliptical(1, 100),
          bottomRight: Radius.elliptical(100, 1),
          topRight: Radius.elliptical(1, 100),
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        // bottomNavigationBar: Container(
        //   padding: EdgeInsets.only(top: 6),
        //   height: 60,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(AppConstants.defaultBackgroundImage),
        //         fit: BoxFit.cover),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey,
        //         blurRadius: 5,
        //       ),
        //     ],
        //     border: Border(
        //       top: BorderSide(
        //         color: Colors.white,
        //         width: 1.5,
        //       ),
        //     ),
        //     color: Colors.white,
        //   ),
        //   child: controller.bottomNavigationBar,
        // ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: GetBuilder<FillRequestControllerImp>(
          init: controller,
          builder: (_) {
            return Form(
              key: controller.formState,
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    // child: SelectFromItemsMap(
                    //   items: patientRequestControllerImp.treatments,
                    //   selectedId: patientRequestControllerImp.treatments[0]['id'],
                    //   title: "  إختر نوع المعالجة:   ",
                    //   onChanged: (value) {
                    //     controller.requestSendModel.caseType = value!;
                    //     controller.update();
                    //   },
                    // ),
                    child: SelectFromItemsMap(
                      items: patientRequestControllerImp.treatments,
                      selectedId:
                          patientRequestControllerImp.treatments.isNotEmpty
                              ? patientRequestControllerImp.treatments[0]['id']
                              : null,
                      title: "  إختر نوع المعالجة:   ",
                      onChanged: (value) {
                        controller.pendingRequestModel.caseType!.sId = value;
                        controller.update();
                      },
                    ),
                  ),
                  BreakContainer(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: SelectFromItems(
                      items: ToothConstants.painSeverityList,
                      value:
                          controller.pendingRequestModel.requestion!.painSeverity!.toString(),
                      title: "  حدد شدة الألم  :   ",
                      onChanged: (value) {
                        controller.pendingRequestModel.requestion!.painSeverity =
                            int.tryParse(value!)!;
                        controller.update();
                      },
                    ),
                  ),
                  BreakContainer(),
                  if (controller.pendingRequestModel.requestion!.painSeverity != 0) ...[
                    RowContainerWithTitle(
                      title: "متى يحصل الألم؟ ",
                      text: controller.pendingRequestModel.requestion!.painTime,
                      onChanged: (p0) {
                        controller.pendingRequestModel.requestion!.painTime = p0;

                        // controller.update();
                      },
                    ),
                    BreakContainer(),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("حدد الجنس : "),
                      Row(
                        children: [
                          SelectOneOption(
                            title: "ذكر",
                            selectOption:
                                controller.pendingRequestModel.requestion!.gender == "male",
                            onTap: () {
                              controller.pendingRequestModel.requestion!.gender = "male";
                              controller.update();
                            },
                          ),
                          SelectOneOption(
                            title: "أنثى",
                            selectOption:
                                controller.pendingRequestModel.requestion!.gender == "female",
                            onTap: () {
                              controller.pendingRequestModel.requestion!.gender = "female";
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  BreakContainer(),
                  if (controller.pendingRequestModel.requestion!.gender == "female") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("هل هي حامل؟ "),
                        Row(
                          children: [
                            BottonContainer(
                              body: "لا",
                              selected:
                                  controller.pendingRequestModel.requestion!.isPregnant ==
                                      false,
                              onTap: () {
                                controller.pendingRequestModel.requestion!.isPregnant  = false;
                                controller.update();
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            BottonContainer(
                              body: "نعم",
                              selected:
                                  controller.pendingRequestModel.requestion!.isPregnant ==
                                      true,
                              onTap: () {
                                controller.pendingRequestModel.requestion!.isPregnant = true;
                                controller.update();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    BreakContainer(),
                  ],
                  RowContainerWithTitle(
                    title: "ادخل عمر المريض : ",
                    text: controller.pendingRequestModel.requestion!.age,
                    onChanged: (p0) {
                      controller.pendingRequestModel.requestion!.age = p0;
                      // controller.update();
                    },
                  ),
                  BreakContainer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("اختر السن المراد معالجته من هنا"),
                      InkWell(
                        onTap: () {
                          showToothLocationMap();
                        },
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.tooth,
                              color: Colors.blue,
                            ),
                            Text(
                              "تلميح!",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RowContainerWithTitle(
                    title: "رقم السن :  ",
                    text: controller.pendingRequestModel.requestion!.toothLocation,
                    onChanged: (p0) {
                      controller.pendingRequestModel.requestion!.toothLocation = p0;
                      // controller.update();
                    },
                  ),
                  BreakContainer(),
                  Text(
                    "ارفاق صورة للسن",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white)),
                      child: InkWell(
                        onTap: () async {
                          await controller.uploadReguestPicture();
                          controller.update();
                        },
                        child: controller.pendingRequestModel.requestion!.photo != null &&
                                controller.pendingRequestModel.requestion!.photo!.url != ""
                            ? SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.network(
                                  "${controller.pendingRequestModel.requestion!.photo!.url!}",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : controller.image == null
                                ? FaIcon(
                                    FontAwesomeIcons.tooth,
                                    color: Colors.blue,
                                    size: 80,
                                  )
                                : SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Image.file(
                                      controller.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  BreakContainer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("هل تعاني من أمراض مزمنة؟  "),
                      BottonContainer(
                        body: "نعم",
                        selected: controller.chronicDiseases == true,
                        onTap: () {
                          controller.chronicDiseases = true;
                          controller.update();
                        },
                      ),
                      BottonContainer(
                        body: "لا",
                        selected: controller.chronicDiseases == false,
                        onTap: () {
                          controller.chronicDiseases = false;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  if (controller.chronicDiseases == true) ...[
                    SizedBox(
                      height: 20,
                    ),
                    RowContainerWithTitle(
                      title: "اذكر اسم المرض  ",
                      onChanged: (p0) {
                        controller
                            .pendingRequestModel.requestion!.moreDetails!.chronicDiseases = p0;
                      },
                      text: controller
                          .pendingRequestModel.requestion!.moreDetails!.chronicDiseases,
                    ),
                  ],
                  BreakContainer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("هل تتناول أدوية أو مكملات؟"),
                      BottonContainer(
                        body: "لا",
                        selected: controller.medicines == false,
                        onTap: () {
                          controller.medicines = false;
                          controller.update();
                        },
                      ),
                      BottonContainer(
                        body: "نعم",
                        selected: controller.medicines == true,
                        onTap: () {
                          controller.medicines = true;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  if (controller.medicines == true) ...[
                    SizedBox(
                      height: 20,
                    ),
                    ColumnContainerWithTitle(
                      title: "اذكر اسم الدواء او المكمل    ",
                      onChanged: (p0) {
                        controller.pendingRequestModel.requestion!.moreDetails!.medicines = p0;
                      },
                      text: controller.pendingRequestModel.requestion!.moreDetails!.medicines,
                    ),
                  ],
                  BreakContainer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("      هل تمت معالجته سابقًا؟"),
                      BottonContainer(
                        body: "لا",
                        selected: controller.previousTreatment == false,
                        onTap: () {
                          controller.previousTreatment = false;
                          controller.pendingRequestModel.requestion!.moreDetails!
                              .previousTreatment = false;
                          controller.update();
                        },
                      ),
                      BottonContainer(
                        body: "نعم",
                        selected: controller.previousTreatment == true,
                        onTap: () {
                          controller.previousTreatment = true;
                          controller.pendingRequestModel.requestion!.moreDetails!
                              .previousTreatment = true;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  BreakContainer(),
                  ColumnContainerWithTitle(
                    title: "هل لديك ملاحظات تود إضافتها؟  ",
                    text: controller.pendingRequestModel.requestion!.moreDetails!.notes,
                    onChanged: (p0) {
                      controller.pendingRequestModel.requestion!.moreDetails!.notes = p0;
                      // controller.update();
                    },
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RowContainerWithTitle extends StatelessWidget {
  final String? title;
  final String? text;
  final void Function(String)? onChanged;

  const RowContainerWithTitle({
    super.key,
    this.title,
    this.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title ?? ""),
        Flexible(
          child: TextFormField(
            onChanged: onChanged,
            controller: TextEditingController(text: text),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ColumnContainerWithTitle extends StatelessWidget {
  final String? title;
  final String? text;
  final void Function(String)? onChanged;

  const ColumnContainerWithTitle({
    super.key,
    this.title,
    this.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            onChanged: onChanged,
            controller: TextEditingController(text: text),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectFromItems extends StatelessWidget {
  final String? value;
  final String? title;
  final List<String> items;
  final void Function(String?)? onChanged;
  const SelectFromItems({
    super.key,
    this.value,
    this.title,
    this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Text(title ?? "")),
        Flexible(
          child: DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            focusColor: Colors.white,
            alignment: Alignment.center,
            isExpanded: false,
            icon: FaIcon(
              FontAwesomeIcons.tooth,
              color: Colors.blue,
            ),
            menuMaxHeight: Get.height * 0.5,
            borderRadius: BorderRadius.circular(30),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            value: value,
            items: items
                .map(
                  (String value) => DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (s) {
              onChanged!(s);
            },
          ),
        ),
      ],
    );
  }
}

// class SelectFromItemsMap extends StatelessWidget {
//   final String? selectedId; // ✅ التغيير: نستخدم ID بدلاً من value
//   final String? title;
//   final List<Map<String, String>> items; // ✅ التغيير: قائمة من الخرائط {id, treatment_case}
//   final void Function(String?)? onChanged; // ✅ سيرسل ID

//   const SelectFromItemsMap({
//     super.key,
//     this.selectedId,
//     this.title,
//     this.onChanged,
//     required this.items,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // ✅ استخراج القائمة المعروضة للمستخدم
//     final displayItems = items.map((item) => item['treatment_case'] ?? '').toList();

//     // ✅ البحث عن العنصر المحدد
//     String? selectedDisplayValue;
//     if (selectedId != null) {
//       final selectedItem = items.firstWhere(
//         (item) => item['id'] == selectedId,
//         orElse: () => {},
//       );
//       selectedDisplayValue = selectedItem['treatment_case'];
//     }

//     if (items.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Text(
//             "لا توجد معالجات متاحة",
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//       );
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Flexible(
//           flex: 1,
//           child: Text(
//             title ?? "",
//             style: const TextStyle(fontSize: 14),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Flexible(
//           flex: 2,
//           child: DropdownButtonFormField<String>(
//             dropdownColor: Colors.white,
//             focusColor: Colors.white,
//             alignment: Alignment.center,
//             isExpanded: true,
//             icon: FaIcon(
//               FontAwesomeIcons.tooth,
//               color: Colors.blue,
//               size: 16,
//             ),
//             menuMaxHeight: Get.height * 0.5,
//             borderRadius: BorderRadius.circular(30),
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               border: OutlineInputBorder(
//                 gapPadding: 10,
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             value: selectedDisplayValue,
//             items: displayItems.map((String displayValue) {
//               return DropdownMenuItem<String>(
//                 alignment: Alignment.center,
//                 value: displayValue,
//                 child: Text(
//                   displayValue,
//                   style: const TextStyle(fontSize: 14),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               );
//             }).toList(),
//             onChanged: (selectedDisplayValue) {
//               if (onChanged != null && selectedDisplayValue != null) {
//                 // ✅ إرجاع الـ ID المناسب للعنصر المختار
//                 final selectedItem = items.firstWhere(
//                   (item) => item['treatment_case'] == selectedDisplayValue,
//                   orElse: () => {},
//                 );
//                 onChanged!(selectedItem['id']);
//               }
//             },
//             hint: const Text('اختر نوع المعالجة'),
//           ),
//         ),
//       ],
//     );
//   }
// }
class SelectFromItemsMap extends StatelessWidget {
  final String? selectedId;
  final String? title;
  final List<Map<String, String>> items;
  final void Function(String?)? onChanged;

  const SelectFromItemsMap({
    super.key,
    this.selectedId,
    this.title,
    this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "لا توجد  بيانات",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // ✅ بناء DropdownMenuItem باستخدام ID كقيمة
    List<DropdownMenuItem<String>> dropdownItems = [];
    String? currentValue;
    
    for (var item in items) {
      String id = item['id'] ?? '';
      String treatmentCase = item['case_type'] ?? '';
      
      if (id.isNotEmpty && treatmentCase.isNotEmpty) {
        dropdownItems.add(
          DropdownMenuItem<String>(
            value: id,  // ✅ استخدام الـ ID كقيمة
            child: Text(treatmentCase),
          ),
        );
        
        // ✅ تعيين القيمة الحالية إذا تطابق الـ ID
        if (selectedId == id) {
          currentValue = id;
        }
      }
    }

    // ✅ إذا لم يتم العثور على تطابق، استخدم أول عنصر كقيمة افتراضية
    if (currentValue == null && dropdownItems.isNotEmpty) {
      currentValue = dropdownItems.first.value;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            title ?? "",
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: currentValue,  // ✅ الآن القيمة هي ID وليس null
            items: dropdownItems,
            onChanged: onChanged,
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: FaIcon(
              FontAwesomeIcons.tooth,
              color: Colors.blue,
              size: 16,
            ),
            menuMaxHeight: Get.height * 0.5,
            borderRadius: BorderRadius.circular(30),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            hint: const Text('اختر نوع المعالجة'),
          ),
        ),
      ],
    );
  }
}

class BreakContainer extends StatelessWidget {
  const BreakContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.15),
      decoration: BoxDecoration(color: Colors.blue, boxShadow: [
        BoxShadow(color: Colors.white, blurRadius: 2, spreadRadius: 1)
      ]),
    );
  }
}
