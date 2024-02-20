import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:meme_generator/widgets/text/input_text_dialogue.dart';

class TextContainer extends StatefulWidget {
  final String mode;
  const TextContainer({super.key, required this.mode});

  @override
  State<TextContainer> createState() => _TextContainerState();
}

class _TextContainerState extends State<TextContainer> {
  bool _textInserted = false;
  String _textInput = '';
  @override
  Widget build(BuildContext context) {
    Color color = widget.mode == 'light' ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: () async {
        String? result = await showDialog(
            context: context,
            builder: (context) {
              return InputTextDialogue(
                text: _textInput,
              );
            });

        if (result == null) {
          _textInserted = false;
        } else {
          setState(() {
            _textInserted = true;
            _textInput = result;
          });
        }
      },
      child: Container(
        //width: double.infinity,
        decoration: BoxDecoration(
            border: _textInserted
                ? Border.all(width: 0, color: Colors.transparent)
                : Border.all(color: color, width: 1.0),
            borderRadius: BorderRadius.circular(10.0)),
        child: _textInserted == true
            ? Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: widget.mode == "light" ? 300.0 : 230.0,
                    maxWidth: widget.mode == "light" ? 300.0 : 230.0,
                    minHeight: widget.mode == "light" ? 30.0 : 30.0,
                    maxHeight: widget.mode == "light" ? 100.0 : 120.0,
                  ),
                  child: AutoSizeText(
                    _textInput,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Impact',
                      color: color,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Введите текст",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Impact',
                    fontSize: 20,
                    color: color,
                  ),
                ),
              ),
      ),
    );
  }
}
