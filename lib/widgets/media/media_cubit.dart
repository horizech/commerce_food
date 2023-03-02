import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/media.dart';
import 'package:shop/widgets/media/media_service.dart';

part 'media_state.dart';

class Mediacubit extends Cubit<MediaState> {
  Mediacubit() : super(MediaState());

  void reset() {
    emit(MediaState());
  }

  void addMedia(int mediaId) async {
    // setMediaStart(state.mediaList);

    if (state.mediaList.isNotEmpty &&
        state.mediaList.any((element) => element.id == mediaId)) {
      setMediaSuccess(state.mediaList);
    } else {
      try {
        Media? media = await MediaService.getMedia(mediaId);
        if (media != null) {
          List<Media> mediaList = [];
          for (var element in state.mediaList) {
            mediaList.add(element);
          }

          mediaList.add(media);
          setMediaSuccess(mediaList);
        } else {
          setMediaError("Media not found!");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void getMedia(List<int> mediaList) async {
    List<Media> media = await MediaService.getMediaByList(mediaList);
    if (media != [] && media.isNotEmpty) {
      setMediaSuccess(media);
    }
  }

  void setMediaStart() {
    emit(MediaState(
      isLoading: true,
    ));
  }

  void setMediaSuccess(List<Media> mediaList) {
    emit(MediaState(
      isSuccessful: true,
      mediaList: mediaList,
    ));
  }

  void setMediaError(String? error) {
    emit(MediaState(
      isError: true,
      error: error,
    ));
  }
}
