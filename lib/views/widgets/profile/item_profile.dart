import 'package:flutter/material.dart';

class ItemProfile extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  const ItemProfile({
    super.key,
    this.title = "",
    this.value = "",
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.white, strokeAlign: 5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                icon,
                color: Colors.blue,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$title :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}
