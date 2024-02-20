import 'package:flutter/material.dart';

class InputTextDialogue extends StatefulWidget {
  final String text;
  const InputTextDialogue({super.key, required this.text});

  @override
  State<InputTextDialogue> createState() => _InputTextDialogueState();
}

class _InputTextDialogueState extends State<InputTextDialogue> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: widget.text);

    return AlertDialog(
      backgroundColor: Colors.grey[800],
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  Navigator.pop(context, value);
                },
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8.0),
                  border: InputBorder.none,
                  hintText: 'Введите текст',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
