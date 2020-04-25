import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:habit/common/I18N.dart';
import 'package:image_crop/image_crop.dart';

class CropImagePage extends StatefulWidget {
  CropImagePage(this._image);

  final File _image; //原始图片路径
  @override
  _CropImagePageState createState() {
    // TODO: implement createState
    return _CropImagePageState();
  }
}

class _CropImagePageState extends State<CropImagePage> {
  double baseLeft; //图片左上角的x坐标
  double baseTop; //图片左上角的y坐标
  double imageWidth; //图片宽度，缩放后会变化
  double imageScale = 1; //图片缩放比例
  Image imageView;

  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("裁剪图片")),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        color: Theme.of(context).canvasColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Crop.file(
                widget._image,
                key: cropKey,
                aspectRatio: 1,
                alwaysShowGrid: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.content_cut),
        onPressed: () async {
          File result = await ImageCrop.cropImage(
              file: widget._image, area: cropKey.currentState.area, scale: 1);
          List<int> out = await FlutterImageCompress.compressWithList(
            (await result.readAsBytes()).toList(),
            minWidth: 200,
            minHeight: 200,
            quality: 95,
          );
          Navigator.of(context).pop(out);
        },
      ),
    );
  }
}
