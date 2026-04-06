import 'package:flutter/material.dart';
import 'package:gr_flutter/views/patient_views/modified_request.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';

class DialogSendRequest extends StatelessWidget {
  final void Function()? send;
  final void Function()? cancel;
  const DialogSendRequest({super.key, this.send, this.cancel});

  @override
  Widget build(BuildContext context) {
    return ModifiedRequest(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          BottomContainer(body: "إرسال", onTap: (){send!();},paddingHorizontal: 20,paddingVertical: 5,),
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
