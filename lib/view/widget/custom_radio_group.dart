import 'package:flutter/material.dart';

class CustomradioGroup extends StatelessWidget {
  String title;
  List<String> items;

  CustomradioGroup({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, pos) => RadioListTile(
              title: Text(items[pos]),
              groupValue: title,
              onChanged: null,
              value: false,
              toggleable: true,
            ));
  }
}
