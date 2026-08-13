import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/requests_controllers/fill_request_controller.dart';
import 'package:gr_flutter/controllers/patient_controller/patient_request_controller.dart';
import 'package:gr_flutter/services/functions/show_tooth_location_map.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';
import 'package:gr_flutter/views/widgets/prediction_light_button.dart';
import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/colors_constant.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.1, vertical: Get.height * 0.1),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              AppImages.authBackground,
            ),
            fit: BoxFit.cover,
            opacity: 0.9,
            colorFilter: ColorFilter.linearToSrgbGamma()),
        color: const Color.fromARGB(0, 255, 255, 255),
        border: Border.all(
          color: AppColors.white,
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
                    child: SelectFromItemsMap(
                      items: patientRequestControllerImp.treatments,
                      selectedId: null,
                      title: "  إختر نوع المعالجة:   ",
                      onChanged: (value) {
                        controller.treatmentRequestModel.caseType!.sId = value;
                        controller.update();
                      },
                    ),
                  ),
                  BreakContainer(),

                  // ----- شدة الألم (1-10) مع أنيميشن AnimatedContainer -----
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "حدد شدة الألم :",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Obx(
                              () => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      controller.selectedPainSeverity.value >= 8
                                          ? AppColors.error.shade100
                                          : controller.selectedPainSeverity
                                                      .value >=
                                                  5
                                              ? AppColors.warning.shade100
                                              : AppColors.success.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'القيمة المختارة: ${controller.selectedPainSeverity.value}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color:
                                        controller.selectedPainSeverity.value >=
                                                8
                                            ? AppColors.error.shade700
                                            : controller.selectedPainSeverity
                                                        .value >=
                                                    5
                                                ? AppColors.warning.shade700
                                                : AppColors.success.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Obx(
                            () => RatingBar.builder(
                              initialRating: controller
                                  .selectedPainSeverity.value
                                  .toDouble(),
                              minRating: 1,
                              maxRating: 10,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 10,
                              itemSize: 20.0,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, index) {
                                final number = index + 1;
                                final isSelected =
                                    controller.selectedPainSeverity.value >=
                                        number;

                                // نفس تدرّج الألوان (أخضر → أحمر) المستخدم
                                // سابقاً، بس هلق منلوّن فيه أيقونة سن بدل
                                // الايموجي، بنفس روح OverseerManageRequest.
                                Color severityColor;
                                switch (number) {
                                  case 1:
                                    severityColor =
                                        AppColors.primary100; // أزرق فاتح
                                    break;
                                  case 2:
                                    severityColor =
                                        AppColors.primary300; // أزرق متوسط
                                    break;
                                  case 3:
                                    severityColor =
                                        AppColors.primary500; // أزرق غامق
                                    break;
                                  case 4:
                                    severityColor =
                                        AppColors.success.shade300; // أخضر فاتح
                                    break;
                                  case 5:
                                    severityColor =
                                        AppColors.success.shade500; // أخضر متوسط
                                    break;
                                  case 6:
                                    severityColor = AppColors.lightGreen
                                        .shade600; // أخضر مائل للأصفر
                                    break;
                                  case 7:
                                    severityColor = Colors
                                        .yellow.shade700; // أصفر (الانتقال)
                                    break;
                                  case 8:
                                    severityColor =
                                        AppColors.warning.shade400; // برتقالي
                                    break;
                                  case 9:
                                    severityColor =
                                        AppColors.error.shade400; // أحمر فاتح
                                    break;
                                  case 10:
                                    severityColor = AppColors.error
                                        .shade900; // أحمر غامق (الأشد خطورة)
                                    break;
                                  default:
                                    severityColor = Colors
                                        .green.shade400; // القيمة الافتراضية
                                }

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.elasticOut,
                                  transform: Matrix4.identity()
                                    ..scale(isSelected ? 1.5 : 0.85)
                                    ..rotateZ(isSelected ? 0.05 : 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? severityColor.withValues(
                                              alpha: 0.15)
                                          : AppColors.transparent,
                                      // border:  Border.all(
                                      //         color: severityColor, width: 2),
                                          
                                      boxShadow: [
                                              BoxShadow(
                                                color: severityColor.withValues(
                                                    alpha: 0.3),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              )
                                            ],
                                          
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.tooth,
                                            size: 26,
                                            color: isSelected
                                                ? severityColor
                                                : AppColors.grey.shade400,
                                          ),
                                          Positioned(
                                            top: 3,
                                            child: Text(
                                              '$number',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? AppColors.white
                                                    : AppColors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onRatingUpdate: (rating) {
                                final newValue = rating.round();
                                controller.selectedPainSeverity.value =
                                    newValue;
                                controller.treatmentRequestModel.requestion!
                                    .painSeverity = newValue;
                                controller.update();
                              },
                              updateOnDrag: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BreakContainer(),

                  if (controller
                          .treatmentRequestModel.requestion!.painSeverity !=
                      0) ...[
                    RowContainerWithTitle(
                      title: "متى يحصل الألم؟ ",
                      text:
                          controller.treatmentRequestModel.requestion!.painTime,
                      onChanged: (p0) {
                        controller.treatmentRequestModel.requestion!.painTime =
                            p0;
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
                            selectOption: controller
                                    .treatmentRequestModel.requestion!.gender ==
                                "male",
                            onTap: () {
                              controller.treatmentRequestModel.requestion!
                                  .gender = "male";
                              controller.update();
                            },
                          ),
                          SelectOneOption(
                            title: "أنثى",
                            selectOption: controller
                                    .treatmentRequestModel.requestion!.gender ==
                                "female",
                            onTap: () {
                              controller.treatmentRequestModel.requestion!
                                  .gender = "female";
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  BreakContainer(),
                  if (controller.treatmentRequestModel.requestion!.gender ==
                      "female") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("هل هي حامل؟ "),
                        Row(
                          children: [
                            BottonContainer(
                              body: "لا",
                              selected: controller.treatmentRequestModel
                                      .requestion!.isPregnant ==
                                  false,
                              onTap: () {
                                controller.treatmentRequestModel.requestion!
                                    .isPregnant = false;
                                controller.update();
                              },
                            ),
                            SizedBox(width: 20),
                            BottonContainer(
                              body: "نعم",
                              selected: controller.treatmentRequestModel
                                      .requestion!.isPregnant ==
                                  true,
                              onTap: () {
                                controller.treatmentRequestModel.requestion!
                                    .isPregnant = true;
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
                    text: controller.treatmentRequestModel.requestion!.age,
                    onChanged: (p0) {
                      controller.treatmentRequestModel.requestion!.age = p0;
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
                            FaIcon(FontAwesomeIcons.tooth, color: AppColors.primary),
                            Text("تلميح!",
                                style: TextStyle(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  RowContainerWithTitle(
                    title: "رقم السن :  ",
                    text: controller
                        .treatmentRequestModel.requestion!.toothLocation,
                    onChanged: (p0) {
                      controller
                          .treatmentRequestModel.requestion!.toothLocation = p0;
                    },
                  ),
                  BreakContainer(),
                  Text("ارفاق صورة للسن", textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: AppColors.white)),
                      child: InkWell(
                        onTap: () async {
                          await controller.uploadReguestPicture();
                          controller.update();
                        },
                        child: controller.treatmentRequestModel.requestion!
                                        .photo !=
                                    null &&
                                controller.treatmentRequestModel.requestion!
                                        .photo!.url !=
                                    ""
                            ? SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.network(
                                  controller.treatmentRequestModel.requestion!.photo!.url!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : controller.image == null
                                ? FaIcon(
                                    FontAwesomeIcons.tooth,
                                    color: AppColors.primary,
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
                    SizedBox(height: 20),
                    RowContainerWithTitle(
                      title: "اذكر اسم المرض  ",
                      onChanged: (p0) {
                        controller.treatmentRequestModel.requestion!
                            .chronicDiseases = p0;
                      },
                      text: controller
                          .treatmentRequestModel.requestion!.chronicDiseases,
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
                    SizedBox(height: 20),
                    ColumnContainerWithTitle(
                      title: "اذكر اسم الدواء او المكمل    ",
                      onChanged: (p0) {
                        controller.treatmentRequestModel.requestion!.medicines =
                            p0;
                      },
                      text: controller
                          .treatmentRequestModel.requestion!.medicines,
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
                          controller.treatmentRequestModel.requestion!
                              .previousTreatment = false;
                          controller.update();
                        },
                      ),
                      BottonContainer(
                        body: "نعم",
                        selected: controller.previousTreatment == true,
                        onTap: () {
                          controller.previousTreatment = true;
                          controller.treatmentRequestModel.requestion!
                              .previousTreatment = true;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  BreakContainer(),
                  ColumnContainerWithTitle(
                    title: "هل لديك ملاحظات تود إضافتها؟  ",
                    text: controller.treatmentRequestModel.requestion!.notes,
                    onChanged: (p0) {
                      controller.treatmentRequestModel.requestion!.notes = p0;
                    },
                  ),
                  BreakContainer(),

                  // ===== تحقق مبدئي اختياري بالذكاء الاصطناعي =====
                  // زرّين جنب بعض: إمكانية العلاج + نوع المعالجة المتوقع
                  Column(
                    children: [
                      const Text(
                        "تحقق مبدئي اختياري بمساعدة خوارزميات التعلم الآلي",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "غير ملزم — بيساعدك تاخد فكرة قبل الإرسال بس",
                        style: TextStyle(fontSize: 11, color: AppColors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => PredictionLightButton(
                              isLoading: controller.isPredicting.value,
                              onTap: controller.predictTreatment,
                              label: "هل يمكن علاجها؟",
                              color: AppColors.warning,
                              icon: Icons.lightbulb,
                            ),
                          ),
                          Obx(
                            () => PredictionLightButton(
                              isLoading: controller.isPredictingCaseType.value,
                              onTap: controller.predictCaseType,
                              label: "نوع المعالجة المتوقع",
                              color: AppColors.primary,
                              icon: FontAwesomeIcons.tooth,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===== باقي الويدجت المساعدة (RowContainerWithTitle, ColumnContainerWithTitle, SelectFromItems, SelectFromItemsMap, BreakContainer) =====

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
              fillColor: AppColors.white,
              focusColor: AppColors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.white),
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
        Text(title ?? "", textAlign: TextAlign.left),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            onChanged: onChanged,
            controller: TextEditingController(text: text),
            decoration: InputDecoration(
              fillColor: AppColors.white,
              focusColor: AppColors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===== SelectFromItems (للاستخدام في صفحات أخرى) =====
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
    final List<String> displayItems = ['', ...items];
    String? currentValue;
    if (value != null && value!.isNotEmpty && displayItems.contains(value)) {
      currentValue = value;
    } else {
      currentValue = null;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Text(title ?? "")),
        Flexible(
          child: DropdownButtonFormField<String>(
            dropdownColor: AppColors.white,
            focusColor: AppColors.white,
            alignment: Alignment.center,
            isExpanded: false,
            icon: FaIcon(FontAwesomeIcons.tooth, color: AppColors.primary),
            menuMaxHeight: Get.height * 0.5,
            borderRadius: BorderRadius.circular(30),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            value: currentValue,
            items: displayItems.map((String value) {
              return DropdownMenuItem<String>(
                alignment: Alignment.center,
                value: value,
                child: Text(
                  value.isEmpty ? 'اختر ...' : value,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (s) {
              onChanged!(s);
            },
          ),
        ),
      ],
    );
  }
}

// ===== SelectFromItemsMap (مع خيار فارغ) =====
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
            "لا توجد بيانات",
            style: TextStyle(color: AppColors.error),
          ),
        ),
      );
    }

    List<DropdownMenuItem<String?>> dropdownItems = [
      const DropdownMenuItem<String?>(
        value: null,
        child: Text('اختر نوع المعالجة'),
      ),
    ];

    for (var item in items) {
      String id = item['id'] ?? '';
      String treatmentCase = item['case_type'] ?? '';
      if (id.isNotEmpty && treatmentCase.isNotEmpty) {
        dropdownItems.add(
          DropdownMenuItem<String?>(
            value: id,
            child: Text(treatmentCase),
          ),
        );
      }
    }

    String? currentValue = selectedId;

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
          child: DropdownButtonFormField<String?>(
            value: currentValue,
            items: dropdownItems,
            onChanged: onChanged,
            dropdownColor: AppColors.white,
            isExpanded: true,
            icon: FaIcon(
              FontAwesomeIcons.tooth,
              color: AppColors.primary,
              size: 16,
            ),
            menuMaxHeight: Get.height * 0.5,
            borderRadius: BorderRadius.circular(30),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class BreakContainer extends StatelessWidget {
  const BreakContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.15),
      decoration: BoxDecoration(color: AppColors.primary, boxShadow: [
        BoxShadow(color: AppColors.white, blurRadius: 2, spreadRadius: 1)
      ]),
    );
  }
}
