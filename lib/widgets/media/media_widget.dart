import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/media.dart';
import 'package:shop/widgets/media/media_cubit.dart';

class MediaWidget extends StatelessWidget {
  final int? mediaId;
  final Function? onChange;
  Media? media;
  double width;
  double height;

  MediaWidget(
      {Key? key,
      this.mediaId,
      this.onChange,
      this.media,
      this.width = 0,
      this.height = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Mediacubit cubit = context.read<Mediacubit>();
    cubit.addMedia(mediaId ?? 0);
    return media != null
        ? ImageWidget(
            media: media!,
            onChange: onChange,
            width: width,
            height: height,
          )
        : BlocConsumer<Mediacubit, MediaState>(
            listener: (context, state) {},
            builder: (context, state) {
              // if (state.isLoading) {
              //   return const SizedBox(
              //       width: 50, height: 20, child: CircularProgressIndicator());
              // }
              if (state.isSuccessful) {
                if (state.mediaList.isNotEmpty &&
                    state.mediaList.any((element) => element.id == mediaId)) {
                  media = state.mediaList
                      .where((element) => element.id == mediaId)
                      .map((e) => e)
                      .first;
                  return state.mediaList
                      .where((element) => element.id == mediaId)
                      .map((e) => ImageWidget(
                            media: e,
                            onChange: onChange,
                            width: width,
                            height: height,
                          ))
                      .first;
                } else {
                  return const SizedBox(
                    height: 10,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              } else {
                return const SizedBox(
                  height: 10,
                  width: 50,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );

    //      return FutureBuilder<Media?>(
    // future: MediaService.getMedia(mediaId),
    // builder: (BuildContext context, AsyncSnapshot<Media?> snapshot) {
    //   return snapshot.hasData
    //       ? ImageWidget(
    //           media: snapshot.data!,
    //           onChange: onChange,
    //           width: width,
    //           height: height,
    //         )
    //       : const CircularProgressIndicator();
    // });
  }
}

class ImageWidget extends StatefulWidget {
  final Media media;
  final Function? onChange;
  double width;
  double height;
  ImageWidget(
      {Key? key,
      required this.media,
      this.onChange,
      this.width = 0,
      this.height = 0})
      : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  onChange() {
    widget.onChange!();
  }

  @override
  Widget build(BuildContext context) {
    bool noWidthHeight = true;

    if (widget.width > 0 && widget.height > 0) {
      noWidthHeight = false;
    }

    return InkWell(
      onTap: onChange,
      child: widget.media.img != null && widget.media.img!.isNotEmpty
          ? SizedBox(
              width: widget.width > 0 ? widget.width : null,
              height: widget.height > 0 ? widget.height : null,
              child: Image.memory(
                Uint8List.fromList(widget.media.img!),
                fit: noWidthHeight
                    ? BoxFit.fill
                    : ((widget.width > widget.height)
                        ? BoxFit.fitWidth
                        : BoxFit.fitHeight),
                gaplessPlayback: true,
              ),
            )
          : widget.media.url != null && widget.media.url!.isNotEmpty
              ? SizedBox(
                  width: widget.width > 0 ? widget.width : null,
                  height: widget.height > 0 ? widget.height : null,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: widget.media.url!,
                    fit: noWidthHeight
                        ? BoxFit.fill
                        : ((widget.width > widget.height)
                            ? BoxFit.fitWidth
                            : BoxFit.fitHeight),
                  ),
                )
              : Container(),
    );
  }
}




// return ClipRRect(
//       borderRadius: const BorderRadius.all(
//         Radius.circular(10.0),
//       ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: InkWell(
//           onTap: onChange,
//           child: widget.media!.img != null
//               ? Image.memory(
//                   Uint8List.fromList(widget.media!.img!),
//                   fit: BoxFit.fill,
//                   height: 150,
//                   width: 200,
//                 )
//               : Container(),
//         ),
//       ),
//     );