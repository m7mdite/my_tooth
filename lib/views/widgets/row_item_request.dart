import 'package:flutter/material.dart';

class RowItemRequest extends StatelessWidget {
  final String keyItem;
  final String valueItem;
  final bool isUpdate;
  final TextEditingController? controller;
  const RowItemRequest({
    super.key,
    required this.keyItem,
    required this.valueItem,
    this.controller, this.isUpdate=false,
  });

  @override
  Widget build(BuildContext context) {
    // double  maxWidth=Get.width*0.5;
    // var textP = TextPainter(
    //     text: TextSpan(text: valueItem, style: TextStyle(fontSize: 14)),
    //     maxLines: 1,
    //     textDirection: TextDirection.ltr)
    //   ..layout();
    // double maxWidth = textP.size.width + 20;
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
                color: Colors.white54,
                
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
              ),
      child: Row(
        children: [
          Text(keyItem,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
              ),
              child: Text(valueItem,style: TextStyle(fontSize: 14),),
              // child: TextFormField(
                
              //   enabled: isUpdate,
              //   style: TextStyle(fontSize: 14,color: Colors.black),
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     constraints: BoxConstraints(
              //       maxWidth: maxWidth,
              //     ),
              //   ),
              //   controller: TextEditingController(text: valueItem),
              //   // valueItem,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
