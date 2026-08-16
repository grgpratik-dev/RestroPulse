// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// Directory path: assets/icons/navigation
  $AssetsIconsNavigationGen get navigation => const $AssetsIconsNavigationGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/demo_image.png
  AssetGenImage get demoImage =>
      const AssetGenImage('assets/images/demo_image.png');

  /// File path: assets/images/google_logo.png
  AssetGenImage get googleLogo =>
      const AssetGenImage('assets/images/google_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [demoImage, googleLogo];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/applogo.png
  AssetGenImage get applogo => const AssetGenImage('assets/logo/applogo.png');

  /// File path: assets/logo/restro_logo.jpg
  AssetGenImage get restroLogo =>
      const AssetGenImage('assets/logo/restro_logo.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [applogo, restroLogo];
}

class $AssetsOnboardingGen {
  const $AssetsOnboardingGen();

  /// File path: assets/onboarding/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/onboarding/onboarding1.png');

  /// File path: assets/onboarding/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/onboarding/onboarding2.png');

  /// File path: assets/onboarding/onboarding3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/onboarding/onboarding3.png');

  /// List of all assets
  List<AssetGenImage> get values => [onboarding1, onboarding2, onboarding3];
}

class $AssetsIconsNavigationGen {
  const $AssetsIconsNavigationGen();

  /// File path: assets/icons/navigation/SOURCE.md
  String get source => 'assets/icons/navigation/SOURCE.md';

  /// File path: assets/icons/navigation/dashboard_filled.svg
  String get dashboardFilled => 'assets/icons/navigation/dashboard_filled.svg';

  /// File path: assets/icons/navigation/dashboard_outlined.svg
  String get dashboardOutlined =>
      'assets/icons/navigation/dashboard_outlined.svg';

  /// File path: assets/icons/navigation/expenses_filled.svg
  String get expensesFilled => 'assets/icons/navigation/expenses_filled.svg';

  /// File path: assets/icons/navigation/expenses_outlined.svg
  String get expensesOutlined =>
      'assets/icons/navigation/expenses_outlined.svg';

  /// File path: assets/icons/navigation/menu_filled.svg
  String get menuFilled => 'assets/icons/navigation/menu_filled.svg';

  /// File path: assets/icons/navigation/menu_outlined.svg
  String get menuOutlined => 'assets/icons/navigation/menu_outlined.svg';

  /// File path: assets/icons/navigation/reports_filled.svg
  String get reportsFilled => 'assets/icons/navigation/reports_filled.svg';

  /// File path: assets/icons/navigation/reports_outlined.svg
  String get reportsOutlined => 'assets/icons/navigation/reports_outlined.svg';

  /// File path: assets/icons/navigation/sales_filled.svg
  String get salesFilled => 'assets/icons/navigation/sales_filled.svg';

  /// File path: assets/icons/navigation/sales_outlined.svg
  String get salesOutlined => 'assets/icons/navigation/sales_outlined.svg';

  /// List of all assets
  List<String> get values => [
    source,
    dashboardFilled,
    dashboardOutlined,
    expensesFilled,
    expensesOutlined,
    menuFilled,
    menuOutlined,
    reportsFilled,
    reportsOutlined,
    salesFilled,
    salesOutlined,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
  static const $AssetsOnboardingGen onboarding = $AssetsOnboardingGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
