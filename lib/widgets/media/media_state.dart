part of 'media_cubit.dart';

class MediaState {
  final bool isLoading;
  final bool isSuccessful;
  final bool isError;
  final String? error;
  final List<Media> mediaList;

  MediaState({
    this.isLoading = false,
    this.isSuccessful = false,
    this.isError = false,
    this.error,
    this.mediaList = const [],
  });
}
