import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EscolhedorImagem extends StatefulWidget {
  final void Function(File f) pick_image;
  final String initial_value;

  EscolhedorImagem(this.pick_image, {this.initial_value});

  @override
  _EscolhedorImagemState createState() => _EscolhedorImagemState();
}

class _EscolhedorImagemState extends State<EscolhedorImagem> {
  File user_img;
  void pick_and_format_img() async {
    final picker = ImagePicker();
    final picked_img = await picker.getImage(source: ImageSource.camera);

    if (picked_img == null) {
      return;
    }

    File cropped_img = await crop_user_selected_img(picked_img.path);

    if (cropped_img == null) {
      return;
    }
    setState(() {
      user_img = cropped_img;
    });

    widget.pick_image(user_img);
  }

  Future<File> crop_user_selected_img(String path) async =>
      await ImageCropper.cropImage(
          maxHeight: 250,
          maxWidth: 250,
          compressQuality: 80,
          sourcePath: path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Recortar imagem',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Theme.of(context).accentColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: build_image(),
        ),
        ElevatedButton(
            onPressed: pick_and_format_img, child: Text('Escolher imagem'))
      ],
    );
  }

  ImageProvider build_image() {
    if (this.user_img != null) {
      return FileImage(this.user_img);
    } else if (widget.initial_value != '') {
      return NetworkImage(widget.initial_value);
    }

    return null;
  }
}
