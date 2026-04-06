// import 'package:flutter/material.dart';

// class BackgoundContainerDialog extends StatelessWidget {
//   final List<Widget>? children;
//   final String title;
//   final Color color;
//   const BackgoundContainerDialog(
//       {super.key,
//       this.children,
//       required this.title,
//       this.color = Colors.white});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage(
//               "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg",
//             ),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.linearToSrgbGamma()),

//         // color: Colors.white,
//         border: Border(
//           bottom: BorderSide(color: color),
//           right: BorderSide(color: color),
//           // top: BorderSide(color: Colors.blueAccent),
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.elliptical(100, 10),
//           bottomLeft: Radius.elliptical(10, 100),
//           topRight: Radius.elliptical(10, 100),
//           bottomRight: Radius.elliptical(100, 10),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(87, 0, 0, 0),
//             spreadRadius: 1,
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(title),
//           title == ""
//               ? SizedBox()
//               : SizedBox(
//                   height: 20,
//                 ),
//           ...?children
//         ],
//       ),
//     );
//   }
// }
