import 'package:flutter/material.dart';

class ViewCoursesPage extends StatelessWidget {
  const ViewCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض المواد")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [],
      ),
    );
  }
}
