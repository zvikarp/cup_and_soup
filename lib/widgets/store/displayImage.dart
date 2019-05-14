import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImageWidget extends StatelessWidget {
  DisplayImageWidget({
    @required this.remoteImage,
    @required this.localImage,
  });

  final String remoteImage;
  final String localImage;

  Widget _noImage() {
    return Image.asset(
      'assets/images/loading.png',
      fit: BoxFit.contain,
    );
  }

  Widget _localImage() {
    return Image.file(
      File(localImage),
      fit: BoxFit.contain,
    );
  }

  Widget _remoteImage() {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.png',
      image: remoteImage,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (remoteImage == "no image")
      return _noImage();
    else if ((localImage != null) && (localImage != ""))
      return _localImage();
    else if ((remoteImage != null) && (remoteImage != ""))
      return _remoteImage();
    else
      return _noImage();
  }
}
