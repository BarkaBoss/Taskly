
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget{
  double width;
  List<String> items;
  CustomDropDown({required this.width, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 30, 30, 1.0),
        borderRadius: BorderRadius.circular(10)
      ),
      child: DropdownButton(
        value: items.first,
        onChanged: (_){},
        items: items.map(
                (e) {
          return DropdownMenuItem(value: e, child: Text(e),);
        }).toList()
      ),
    );
  }
}