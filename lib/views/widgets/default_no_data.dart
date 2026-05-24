import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultNoData extends StatelessWidget {
  const DefaultNoData({super.key});

  @override
  Widget build(BuildContext context) {
    // bool i=true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("لا يوجد بيانات هنا  "),
              FaIcon(
                FontAwesomeIcons.sadTear,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
