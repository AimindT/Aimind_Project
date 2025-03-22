import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  final Widget widget;
  final String title;

  const EditItem({
    super.key,
    required this.widget,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 18, color: Colors.grey))),
        Expanded(flex: 5, child: widget)
      ],
    );
  }
}
