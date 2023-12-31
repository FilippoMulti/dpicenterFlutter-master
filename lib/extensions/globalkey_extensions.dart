import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }

  Offset? get globalOffset {
    final renderObject = currentContext?.findRenderObject();
    RenderBox? currentBox = renderObject as RenderBox?;
    return currentBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }
}
