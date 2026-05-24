// import 'package:flutter/material.dart';
// import 'package:gr_flutter/views/widgets/bottom_controller.dart';

// class PatientUnderShowRequest extends StatelessWidget {
//   final void Function()? onUpdateTap;
//   final void Function()? onDeleteTap;
//   final void Function()? onSendUpdateTap;
//   final void Function()? onCancelUpdateTap;
//   final bool updateMode;
//   const PatientUnderShowRequest({super.key,  this.onUpdateTap, this.onDeleteTap, this.updateMode = false, this.onSendUpdateTap, this.onCancelUpdateTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           BottomContainer(body:updateMode?" إلغاء التعديل ": "حذف",onTap: (){
//             updateMode?onCancelUpdateTap!():  onDeleteTap!();
            
//           },),
      
//           BottomContainer(body:updateMode?" حفظ التعديل ": "تعديل",onTap:  
//             updateMode?onSendUpdateTap: onUpdateTap
//           ),
      
//         ],
//       ),
//     );
//   }
// }