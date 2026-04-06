import 'package:flutter/material.dart';
import 'package:gr_flutter/views/patient_views/modified_request.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';

class DialogUpdateRequest extends StatelessWidget {
  final void Function()? update;
  final void Function()? cancel;
  const DialogUpdateRequest({super.key, this.update, this.cancel});

  @override
  Widget build(BuildContext context) {
    return ModifiedRequest(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          BottomContainer(body: "تعديل", onTap: (){update!();},paddingHorizontal: 20,paddingVertical: 5,),
          BottomContainer(
            body: "إلغاء",
            onTap: (){
              cancel!();
            },
            paddingHorizontal: 20,
            paddingVertical: 5,
          ),
        ],
      ),
    );
  }
}
