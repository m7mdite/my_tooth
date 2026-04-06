import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitDialog extends StatelessWidget {
  final String title;
  final String question;
  final void Function()? onTapSubmit;

  const SubmitDialog(
      {super.key,
      this.title = "العنوان",
      this.question = "هل انت متأكد؟",
      this.onTapSubmit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Container(
          width: Get.width * 0.7,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 255, 255, 255),
            border: Border.all(width: 3.5, color: Colors.white),
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
                    "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.linearToSrgbGamma(),
                  opacity: 0.8,),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10,),
                Text(
                  
                  title,
                  style: TextStyle(
                    
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20,top: 10),
                  height: 2,
                  color: Colors.white,
                  width: 200,
                ),
                Flexible(
                  child: Text(
                    
                    question,
                    // maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  height: 2,
                  color: Colors.white,
                  width: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1.5, color: Colors.red),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(100, 10),
                            bottomLeft: Radius.elliptical(10, 100),
                            topRight: Radius.elliptical(10, 100),
                            bottomRight: Radius.elliptical(100, 10),
                          ),
                        ),
                        child: Text(
                          "إلغاء",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onTapSubmit,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1.5, color: Colors.green),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(100, 10),
                            bottomLeft: Radius.elliptical(10, 100),
                            topRight: Radius.elliptical(10, 100),
                            bottomRight: Radius.elliptical(100, 10),
                          ),
                        ),
                        child: Text(
                          "تأكيد",
                          style: TextStyle(color: Colors.green),
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
