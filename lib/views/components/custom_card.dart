import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key, required this.title,}) : super(key: key);

  final String title;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 33, 42, 43),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(widget.title, style: const TextStyle(
          color: Colors.white,
          fontSize: 25
        ),)
        ),
      ),
    );
  }
}