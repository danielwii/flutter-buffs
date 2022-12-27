import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quiver/strings.dart';

final cacheManager = DefaultCacheManager();
void checkMemory() {
  final imageCache = PaintingBinding.instance.imageCache;
  if (imageCache.currentSizeBytes >= 55 << 20) {
    logger.info('clear images...${imageCache.currentSizeBytes >> 20}m');
    imageCache.clear();
    imageCache.clearLiveImages();
  }
  logger.info(
      'pendingImageCount:${imageCache.pendingImageCount} / liveImageCount:${imageCache.liveImageCount} / currentSize:${imageCache.currentSize} / currentSizeBytes:${imageCache.currentSizeBytes >> 20}m');
}

class CachedImage extends StatelessWidget {
  final String urlPath;
  final BoxFit fit;
  final String? hash;
  final bool progress;
  final double? width;
  final double? height;
  final int? memCacheWidth;

  CachedImage(
    this.urlPath, {
    this.fit = BoxFit.fill,
    this.hash,
    this.progress = true,
    this.width,
    this.height,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    final url = AppContext.connection.resolveUrl(urlPath);
    // final headers = withHostHeader(urlPath);
    // logger.info('cache image $urlPath with headers $headers');
    // logger.info('url is $url');
    /*
    checkMemory();
    cacheManager.getFileFromMemory(url).then((info) {
      if (info != null) {
        logger.info('$url info is ${info.file.statSync().size >> 20}m');
      }
    });*/

    final size = MediaQuery.of(context).size;
    final memCacheWidthValue = width?.toInt() ?? size.width.toInt();
    return CachedNetworkImage(
      key: ValueKey(url),
      // httpHeaders: headers,
      // cacheManager: cacheManager,
      // memCacheWidth: (size.width * .6).toInt(),
      // maxWidthDiskCache: si,
      fit: fit,
      width: width,
      height: height,
      maxWidthDiskCache: size.width.toInt(),
      memCacheWidth: memCacheWidth ??
          (memCacheWidthValue < 100 ? 100 : memCacheWidthValue),
      // filterQuality: FilterQuality.high,
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
        // logger.finer('load image error: $error headers:$headers');
        return const Icon(Icons.image_not_supported);
      },
    );
  }
}

CachedNetworkImageProvider cachedNetworkImageProvider(String path) {
  final url = AppContext.connection.resolveAssets(path);
  /*
  checkMemory();
  cacheManager.getFileFromMemory(url).then((info) {
    if (info != null) {
      logger.info('$url info is ${info.file.statSync().size >> 20}m');
    }
  });*/
  return CachedNetworkImageProvider(url /*, headers: withHostHeader(path)*/);
}
