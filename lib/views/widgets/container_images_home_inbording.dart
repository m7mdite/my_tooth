
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ContainerImagesHomeInbording extends StatelessWidget {
  final String image;
  const ContainerImagesHomeInbording({
    super.key, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.width * 0.4,
      width: Get.width * 0.4,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(100, 10),
          bottomLeft: Radius.elliptical(10, 100),
          topRight: Radius.elliptical(10, 100),
          bottomRight: Radius.elliptical(100, 10),
        ),
        image: DecorationImage(
          image: AssetImage("images/images_asnan/$image"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}