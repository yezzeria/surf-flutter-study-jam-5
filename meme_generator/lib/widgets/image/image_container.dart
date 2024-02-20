import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme_generator/widgets/image/select_image_dialogue.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({super.key});

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

enum imageType {
  none,
  url,
  gallery,
}

class _ImageContainerState extends State<ImageContainer> {
  // enum to determine is image selected and how is it done
  imageType _currentImageType = imageType.none;
  String _imageUrl = '';
  File? _image;

  // zoom and position of picture variables
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;

  double _previousScale = 1.0;
  Offset _previousOffset = Offset.zero;

  void resetPositionAndScale() {
    _scale = 1.0;
    _offset = Offset.zero;
    _initialFocalPoint = Offset.zero;

    _previousScale = 1.0;
    _previousOffset = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );
    return GestureDetector(
      onTap: () async {
        var result = await showDialog(
            context: context,
            builder: (context) {
              return SelectImageDialogue();
            });
        if (result == null) {
          _currentImageType = imageType.none;
        } else {
          if (result is String?) {
            setState(() {
              _currentImageType = imageType.url;
              _imageUrl = result!;
              resetPositionAndScale();
            });
          } else {
            setState(() {
              _currentImageType = imageType.gallery;
              _image = result;
              resetPositionAndScale();
            });
          }
        }
      },
      onScaleStart: (details) {
        _initialFocalPoint = details.localFocalPoint;
        _previousScale = _scale;
        _previousOffset = _offset;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_previousScale * details.scale).clamp(1.0, 10.0);
          _offset =
              _previousOffset + details.localFocalPoint - _initialFocalPoint;
        });
      },
      onScaleEnd: (_) {
        _initialFocalPoint = Offset.zero;
      },
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _currentImageType == imageType.none
                ? Center(
                    child: Text(
                      "Выберите картинку",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(_offset.dx, _offset.dy)
                        ..scale(_scale),
                      alignment: FractionalOffset.center,
                      child: _currentImageType == imageType.url
                          ? Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
