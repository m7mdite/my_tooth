
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';

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
        borderRadius: AppThemeConstants.borderRadius,
        image: DecorationImage(
          image: AssetImage("images/images_asnan/$image"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}