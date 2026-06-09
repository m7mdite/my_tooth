import 'package:flutter/material.dart';
import 'package:gr_flutter/views/request_views/modified_request.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';

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
          
          BottonContainer(body: "إرسال", onTap: (){send!();},paddingHorizontal: 20,paddingVertical: 5,),
          BottonContainer(
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
