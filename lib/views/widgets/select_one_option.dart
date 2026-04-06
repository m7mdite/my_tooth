import 'package:flutter/material.dart';

class SelectOneOption extends StatelessWidget {
  final void Function()? onTap;
  final bool selectOption;
  final String title;
  const SelectOneOption(
      {super.key,
      
      this.title = "", this.onTap,  this.selectOption=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: selectOption
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(),
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              image: AssetImage("images/images_asnan/asnan6.jpeg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma()),
        ),
        child: Row(
          children: [
            Text(title),
            if (selectOption)
              Icon(
                Icons.check_circle,
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}
