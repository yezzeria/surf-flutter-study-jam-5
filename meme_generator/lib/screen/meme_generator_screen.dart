import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meme_generator/widgets/image/image_container.dart';
import 'package:meme_generator/widgets/text/text_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class MemeGeneratorScreen extends StatefulWidget {
  final int index;
  final String url;
  const MemeGeneratorScreen({Key? key, required this.index, required this.url})
      : super(key: key);

  @override
  State<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  final List _list = ['Демотиватор', 'Drake', 'Но я же'];
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? _imageBytes;

  final _decoration = BoxDecoration(
    border: Border.all(
      color: Colors.white,
      width: 2,
    ),
  );

  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        setState(() {
          _imageBytes = byteData.buffer.asUint8List();
        });
        await _saveAndShareImage();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _saveAndShareImage() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = await getTemporaryDirectory();
      final String path = '${directory.path}/my_cool_meme.png';
      await File(path).writeAsBytes(_imageBytes!);
      Share.shareXFiles([XFile(path)]);
    } else {
      print('Permission denied');
    }
  }

  Widget _buildChild() {
    if (widget.index == 0) {
      return ColoredBox(
        color: Colors.black,
        child: DecoratedBox(
          decoration: _decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ImageContainer(),
                SizedBox(
                  height: 15,
                ),
                TextContainer(mode: "light"),
              ],
            ),
          ),
        ),
      );
    } else if (widget.index == 1) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.url),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 155, left: 140, child: TextContainer(mode: "dark")),
            Positioned(top: 30, left: 140, child: TextContainer(mode: "dark")),
          ],
        ),
      );
    } else if (widget.index == 2) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.url),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Center(
            child: Container(
          color: Colors.grey,
          child: Text(
            "No time :( ⬊(me)",
            style: TextStyle(color: Colors.red, fontSize: 30),
          ),
        )),
        // child: Stack(
        //   children: [
        //     Positioned(top: 5, left: 20, child: TextContainer(mode: "dark")),
        //     Positioned(top: 30, left: 140, child: TextContainer(mode: "dark")),
        //     Positioned(top: 30, left: 140, child: TextContainer(mode: "dark")),
        //   ],
        // ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          _list[widget.index],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RepaintBoundary(
            key: _globalKey,
            child: _buildChild(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndShare,
        backgroundColor: Colors.white,
        child: Icon(Icons.share),
      ),
    );
  }
}
