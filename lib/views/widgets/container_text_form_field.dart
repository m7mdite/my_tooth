
import 'package:flutter/material.dart';

class ContainerTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines ;
  // final int minLines ;
  final String? hintText;
  const ContainerTextFormField({
    super.key,  this.controller,this.validator, this.hintText, this.maxLines=1,  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.blueAccent),
          right: BorderSide(color: Colors.blueAccent),
          top: BorderSide(color: Colors.blueAccent),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
      ),
      child: TextFormField(
        // minLines: minLines,
        validator: validator,
        controller: controller,
        maxLines: maxLines,
      ),
    );
  }
}
