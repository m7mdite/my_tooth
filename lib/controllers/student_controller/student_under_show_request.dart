import 'package:flutter/material.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';

class StudentUnderShowRequest extends StatelessWidget {
  final void Function()? onAgreeTap;
  const StudentUnderShowRequest({
    super.key, this.onAgreeTap,
    // this.onUpdateTap,
    // this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomContainer(
            paddingVertical: 5,
            paddingHorizontal: 15,
            body: "المطالبة بالحالة",
            onTap: () {
              onAgreeTap!();
            },
          ),
          
        ],
      ),
    );
  }
}
