import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double padding;
  final double margin;

  const MyButton({Key? key, this.onTap, required this.text, required this.padding, required this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8)
        ),
        child:  Center(
          child: Text(text,
              style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )
          ),
        ),
      ),
    );
  }
}
