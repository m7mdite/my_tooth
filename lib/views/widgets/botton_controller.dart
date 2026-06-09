import 'package:flutter/material.dart';

class BottonContainer extends StatelessWidget {
  final String body;
  final void Function()? onTap;
  final bool selected;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? fontSize;
  final Color? color;
  const BottonContainer(
      {super.key,
      required this.body,
      this.onTap,
      this.selected = true,
      this.paddingHorizontal = 3,
      this.paddingVertical = 1,
      this.fontSize = 16,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal!, vertical: paddingVertical!),
        decoration: BoxDecoration(
          image: selected
              ? DecorationImage(
                  image: AssetImage(
                      "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg"),
                  fit: BoxFit.cover,
                )
              : null,
          color: selected ? Colors.white : Colors.grey,
          border: Border.all(
            color: !selected ? Colors.greenAccent : Colors.blueAccent,
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(87, 0, 0, 0),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          body,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
      ),
    );
  }
}
