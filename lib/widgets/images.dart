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
      {this.fit = BoxFit.fill, this.hash, this.progress = true, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final url = AppContext.connection.resolveUrl(urlPath);
    // final headers = withHostHeader(urlPath);
    // logger.info('cache image $urlPath with headers $headers');
    logger.finest('url is $url');
    return CachedNetworkImage(
        key: ValueKey(urlPath),
        // httpHeaders: headers,
        fit: fit,
        width: width,
        height: height,
        filterQuality: FilterQuality.high,
        imageUrl: url,
        progressIndicatorBuilder: progress
            ? (context, url, downloadProgress) => Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress, color: Colors.white))
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
          logger.finer('load image error: $error url: $url');
          // logger.finer('load image error: $error headers:$headers');
          return const Icon(Icons.image_not_supported);
        });
  }
}

CachedNetworkImageProvider cachedNetworkImageProvider(String path) =>
    CachedNetworkImageProvider(
      AppContext.connection.resolveAssets(path),
      headers: withHostHeader(path),
    );
