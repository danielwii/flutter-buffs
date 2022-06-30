import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quiver/strings.dart';

class CachedImage extends StatelessWidget {
  final String urlPath;
  final BoxFit fit;
  final String? hash;
  final bool progress;
  final double? width;
  final double? height;

  CachedImage(this.urlPath,
      {this.fit = BoxFit.fill,
      this.hash,
      this.progress = true,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    final url = AppContext.connection.resolveUrl(urlPath);

    final size = MediaQuery.of(context).size;
    final memCacheWidth = width?.toInt() ?? size.width.toInt();
    return CachedNetworkImage(
      key: ValueKey(url),
      fit: fit,
      width: width,
      height: height,
      maxWidthDiskCache: size.width.toInt(),
      memCacheWidth: memCacheWidth < 100 ? 100 : memCacheWidth,
      imageUrl: url,
      progressIndicatorBuilder: progress
          ? (context, url, downloadProgress) => Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: Colors.white,
                ),
              )
          : null,
      placeholder: !progress
          ? (context, url) => isNotBlank(hash)
              ? SizedBox.shrink(child: BlurHash(hash: hash!))
              : Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                    SpinKitFadingCircle(color: Colors.white)
                  ])))
          : null,
      errorWidget: (context, url, error) {
        logger.warning('load image error: $error url: $url');
        return const Icon(Icons.image_not_supported);
      },
    );
  }
}

CachedNetworkImageProvider cachedNetworkImageProvider(String path) {
  final url = AppContext.connection.resolveAssets(path);
  return CachedNetworkImageProvider(url);
}
