import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomPhotoAppBar extends StatelessWidget {
  final String role;
  const CustomPhotoAppBar({
    super.key,
    required this.pic,
    this.role = "student",
  });

  final String pic;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent, width: 1, strokeAlign: 2),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // تغيير اتجاه الظل
            ),
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, -3), // تغيير اتجاه الظل
            )
          ]),
      child: CircleAvatar(
        backgroundImage:
            pic.isNotEmpty ? NetworkImage("$pic") : null,
        backgroundColor: Colors.blue,
        child: pic.isEmpty
            ? (role == "student"
                ? FaIcon(FontAwesomeIcons.userGraduate, color: Colors.white)
                : role == "patient"
                    ? FaIcon(FontAwesomeIcons.user, color: Colors.white)
                    : FaIcon(FontAwesomeIcons.userTie, color: Colors.white))
            : null,
      ),
    );
  }
}
