import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingImage extends StatelessWidget {
  final BoxFit? fit;

  const LoadingImage({
    super.key,
    required this.imageUrl,
    this.fit,
  });
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.fill,
      fadeOutDuration: const Duration(milliseconds: 0),
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutCurve: Curves.linear,
      fadeInCurve: Curves.linear,
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      ),
      progressIndicatorBuilder: (context, child, loadingProgress) {
        return Center(
          child: SpinKitSpinningLines(
            color: appTheme.colorScheme.secondaryContainer,
            size: 20.0,
          ),
        );
      },
    );
  }
}
