import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/patient_profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_constants/app_constants.dart';
import '../widgets/profile/item_profile.dart';

class PatientShowProfile extends StatelessWidget {
  final PatientProfileControllerImp controller = Get.find();
  
  PatientShowProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي"),
        actions: [
          IconButton(
            icon: Icon(Icons.upgrade_outlined),
            onPressed: () => controller.toUpdateProfile(),
          ),
        ],
      ),
      body: GetBuilder<PatientProfileControllerImp>(builder: (_) {
        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: ListView(
            children: [
              Center(
                child: InkWell(
                  onLongPress: () async {
                    File? image;
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      image = File(pickedFile.path);
                      await controller.uploadProfilePicture(image);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.all(5),
                    height: Get.width * 0.5,
                    width: Get.width * 0.5,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 1,
                        )
                      ],
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: controller.profilePicture.isEmpty
                            ? AssetImage(AppConstants.defaultBackgroundImage)
                            : NetworkImage(
                                "http://localhost:5000${controller.profilePicture}",
                              ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              ItemProfile(
                value: controller.fullName,
                icon: Icons.person_2_outlined,
                title: "الاسم",
              ),
              ItemProfile(
                value: controller.emailController.text,
                icon: Icons.email_outlined,
                title: "البريد الإلكتروني",
              ),
              ItemProfile(
                value: controller.phoneNumberController.text,
                icon: Icons.phone_outlined,
                title: "رقم الجوال",
              ),
              ItemProfile(
                value: controller.genderController.text,
                icon: Icons.gesture_rounded,
                title: "الجنس",
              ),
              ItemProfile(
                value: controller.ageController.text,
                icon: Icons.cake_outlined,
                title: "العمر",
              ),
              SizedBox(height: 60),
            ],
          ),
        );
      }),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/patient_controller/patient_profile_controller.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../utils/app_constants/app_constants.dart';
// import '../widgets/profile/item_profile.dart';

// class PatientShowProfile extends StatelessWidget {
//   final PatientProfileControllerImp controller = Get.find();
//   PatientShowProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: GetBuilder<PatientProfileControllerImp>(builder: (_) {
//         return RefreshIndicator(onRefresh: () {
          
//         },
//           child: ListView(
//             children: [
//               Center(
//                 child: InkWell(
//                   onLongPress: () async {
//                     File? image;
//                     final pickedFile = await ImagePicker()
//                         .pickImage(source: ImageSource.gallery);
//                     if (pickedFile != null) {
//                       image = File(pickedFile.path);
//                       await controller.uploadProfilePicture(image);
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 30),
//                     padding: EdgeInsets.all(5),
//                     height: Get.width * 0.5,
//                     width: Get.width * 0.5,
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.blue, blurRadius: 20, spreadRadius: 1)
//                       ],
//                       borderRadius: BorderRadius.circular(100),
//                       image: DecorationImage(
//                         image: controller.profilePicture == ""
//                             ? AssetImage(AppConstants.defaultBackgroundImage)
//                             : NetworkImage(
//                                 "http://localhost:5000${controller.profilePicture}",
//                               ),
//                         fit: BoxFit.cover,
//                       ),
//                       border: Border.all(
//                         color: Colors.white,
//                         strokeAlign: 5,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ItemProfile(
//                 value: controller.profileModel?.firstName ?? controller.name.text,
//                 icon: Icons.person_2_outlined,
//                 title: "الاسم",
//               ),
//               ItemProfile(
//                 value: controller.profileModel?.id ??  controller.data['_id'],
//                 icon: Icons.perm_identity_rounded,
//                 title: " id ",
//               ),
              
//               // ItemProfile(
//               //   value: controller.profileModel?.age.toString() ?? controller.age.text,
//               //   icon: Icons.airline_seat_legroom_reduced,
//               //   title: "العمر",
//               // ),
//               ItemProfile(
//                 value: controller.profileModel?.gender ?? "",
//                 icon: Icons.gesture_rounded,
//                 title: "الجنس",
//               ),
//               ItemProfile(
//                 value: controller.profileModel?.email ?? controller.email.text,
//                 icon: Icons.email_outlined,
//                 title: "البريد الإلكتروني",
//               ),
//               ItemProfile(
//                 value: controller.profileModel?.phoneNumber ?? controller.phoneNumber.text,
//                 icon: Icons.near_me_outlined,
//                 title: "رقم الجوال",
//               ),
//               ItemProfile(
//                 value: controller.profileModel?.id ??  controller.data['_id'],
//                 icon: Icons.perm_identity_rounded,
//                 title: " id ",
//               ),
//               SizedBox(
//                 height: 60,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
