import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider<Object> menuImageProvider(String path) {
  if (path.startsWith('assets/')) return AssetImage(path);
  return FileImage(File(path));
}
