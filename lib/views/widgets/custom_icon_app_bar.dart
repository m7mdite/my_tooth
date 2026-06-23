import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/public_views/conversations_screen.dart';

class CustomIconAppBar extends StatelessWidget {
  final void Function()? onTap;
  final bool reverseColors;
  final IconData iconData;
  const CustomIconAppBar({
    super.key,
    this.onTap,
    this.reverseColors = false,
    this.iconData = Icons.chat,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Get.to(() => ConversationsScreen());
          },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: Colors.blue,
          color: reverseColors ? Colors.white : Colors.lightBlueAccent,
          // border: Border.all(
          //     color: reverseColors ? Colors.white : Colors.lightBlueAccent,
          //     width: 1,
          //     strokeAlign: 5),
          boxShadow: [
            BoxShadow(
              color: reverseColors ? Colors.lightBlueAccent : Colors.white,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // تغيير اتجاه الظل
            ),
            BoxShadow(
              color: reverseColors ? Colors.lightBlueAccent : Colors.white,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, -3), // تغيير اتجاه الظل
            ),
          ],
        ),
        child: Icon(
          iconData,
          color: reverseColors ? Colors.blue : Colors.white,
        ),
      ),
    );
  }
}
