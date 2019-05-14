import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget({
    @required this.currantImage,
    @required this.onImageChanged,
  });

  final String currantImage;
  final Function(File, String) onImageChanged;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File _newImage;
  String _status = "no change";
  String _placehoder = 'assets/images/loading.png';

  Widget _noImage() {
    return Image.asset(
      _placehoder,
      fit: BoxFit.contain,
    );
  }

  Widget _imageUrl() {
    return FadeInImage.assetNetwork(
      placeholder: _placehoder,
      image: widget.currantImage,
      fit: BoxFit.contain,
    );
  }

  Widget _imageFile() {
    return Image.file(
      _newImage,
      fit: BoxFit.contain,
    );
  }

  void _removeImage() async {
    if (widget.currantImage != "no image")
      _status = "deleted";
    else {
      _status = "noChange";
      _newImage = null;
    }
    widget.onImageChanged(_newImage, _status);
  }

  void _getImage() async {
    var newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("sfdsfsdfsdfsdf" + newImage.toString());
    if (newImage == null) return;
    if (widget.currantImage != "no image")
      _status = "changed";
    else
      _status = "added";
    _newImage = newImage;
    widget.onImageChanged(_newImage, _status);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
              margin: EdgeInsets.all(36),
              height: 230,
              child: (_newImage != null)
                  ? _imageFile()
                  : (_status == "deleted") ||
                          (widget.currantImage == "no image")
                      ? _noImage()
                      : _imageUrl()),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black,
                ),
                child: IconButton(
                  iconSize: 36,
                  color: Colors.white,
                  icon: Icon(Icons.camera_alt),
                  onPressed: _getImage,
                ),
              ),
              SizedBox(height: 16),
              (_status == "deleted") || (widget.currantImage == "no image")
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                      child: IconButton(
                        iconSize: 36,
                        color: Colors.white,
                        icon: Icon(Icons.cancel),
                        onPressed: _removeImage,
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
