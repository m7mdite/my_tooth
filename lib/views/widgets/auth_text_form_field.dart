import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool isPassword;
  final Widget? suffix;
   final   bool showPassword ;
 
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AuthTextFormField({
    super.key,
    required this.label,
    required this.textEditingController,
    this.isPassword = false,
    this.suffix,
    this.onChanged,
    this.validator,  this.showPassword= false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("images/asnan3.jpg"),fit: BoxFit.cover),
        color: const Color.fromARGB(255, 255, 254, 254),
        border: Border(
            right: BorderSide(
              color: Colors.blueAccent,
            ),
            bottom: BorderSide(
              color: Colors.blueAccent,
            )),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
      ),
      child: TextFormField(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isPassword,
        onChanged: onChanged,
        controller: textEditingController,
        decoration: InputDecoration(
          suffix: suffix ,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                      color: Colors.blueAccent,
                    ),
                    left: BorderSide(
                      color: Colors.blueAccent,
                    )),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
                color: Colors.white,
              ),
              child: Text(
                label,
                style: TextStyle(fontSize: 15),
              )),
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
