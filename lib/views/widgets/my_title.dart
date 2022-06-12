
import 'package:flutter/material.dart';

class MyTitle extends StatefulWidget {
  const MyTitle({
    Key? key, 
    required this.title, 
    required this.size
  }) : super(key: key);

  final String title;
  final double size;

  @override
  State<MyTitle> createState() => _MyTitleState();
}

class _MyTitleState extends State<MyTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: widget.size,
      ),
    );
  }
}