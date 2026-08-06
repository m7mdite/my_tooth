import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_images_constant.dart';

import '../../../utils/app_constants/colors_constant.dart';

class SubmitDialog extends StatelessWidget {
  final String title;
  final String question;
  final String cancelBottonTitle;
  final String agreeBottontitle;
  final void Function()? onTapSubmit;
  final void Function()? onTapCansel;
  final List<Widget>? children;

  const SubmitDialog({
    super.key,
    this.children = const <Widget>[],
    this.title = "العنوان",
    this.question = "",
    this.onTapSubmit,
    this.onTapCansel,
    this.cancelBottonTitle = "إلغاء",
    this.agreeBottontitle = "تأكيد",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.transparent,
        child: Container(
          width: Get.width * 0.7,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(width: 3.5, color: AppColors.borderColor),
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
          ),
          child: Container(
            // color: const Color.fromARGB(90, 255, 255, 255),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppImages.authBackground,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
                opacity: 0.8,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 10),
                  height: 2,
                  color: AppColors.white,
                  width: 200,
                ),
                if(question!="") Flexible(
                  child: Text(
                    question,
                    // maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                ...children!,
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  height: 2,
                  color: AppColors.white,
                  width: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        if(onTapCansel!=null) onTapCansel!();
                        // Get.back();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(width: 1.5, color: AppColors.error),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(100, 10),
                            bottomLeft: Radius.elliptical(10, 100),
                            topRight: Radius.elliptical(10, 100),
                            bottomRight: Radius.elliptical(100, 10),
                          ),
                        ),
                        child: Text(
                          cancelBottonTitle,
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onTapSubmit,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(width: 1.5, color: AppColors.success),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(100, 10),
                            bottomLeft: Radius.elliptical(10, 100),
                            topRight: Radius.elliptical(10, 100),
                            bottomRight: Radius.elliptical(100, 10),
                          ),
                        ),
                        child: Text(
                          agreeBottontitle,
                          style: TextStyle(color: AppColors.success),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
