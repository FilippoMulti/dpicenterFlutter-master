import 'package:flutter/material.dart';

///da utilizzare quando MediaQuery non disponibile
///
var pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

//Size in physical pixels
var physicalScreenSize = WidgetsBinding.instance.window.physicalSize;
var physicalWidth = physicalScreenSize.width;
var physicalHeight = physicalScreenSize.height;

//Size in logical pixels
var logicalScreenSize =
    WidgetsBinding.instance.window.physicalSize / pixelRatio;
var logicalWidth = logicalScreenSize.width;
var logicalHeight = logicalScreenSize.height;

//Padding in physical pixels8
var padding = WidgetsBinding.instance.window.padding;

//Safe area paddings in logical pixels
var paddingLeft = WidgetsBinding.instance.window.padding.left /
    WidgetsBinding.instance.window.devicePixelRatio;
var paddingRight = WidgetsBinding.instance.window.padding.right /
    WidgetsBinding.instance.window.devicePixelRatio;
var paddingTop = WidgetsBinding.instance.window.padding.top /
    WidgetsBinding.instance.window.devicePixelRatio;
var paddingBottom = WidgetsBinding.instance.window.padding.bottom /
    WidgetsBinding.instance.window.devicePixelRatio;

//Safe area in logical pixels
var safeWidth = logicalWidth - paddingLeft - paddingRight;
var safeHeight = logicalHeight - paddingTop - paddingBottom;
