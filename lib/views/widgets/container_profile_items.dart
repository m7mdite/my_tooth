import 'package:flutter/material.dart';

class ContainerProfileItems extends StatelessWidget {
  final Widget? child;
  const ContainerProfileItems({
    super.key, this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 5,
            blurRadius: 20,
          ),
        ],
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
      child: child,
    );
  }
}
