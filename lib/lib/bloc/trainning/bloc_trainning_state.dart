part of 'bloc_trainning.dart';

abstract class BlocTrainningState {
  const BlocTrainningState();
}

class BlocTrainningInitial extends BlocTrainningState {
  const BlocTrainningInitial();
}

class BlocTrainningLoading extends BlocTrainningState {
  const BlocTrainningLoading();
}

class BlocTrainningError extends BlocTrainningState {
  final String message;
  const BlocTrainningError({
    required this.message,
  });
}

class BlocTrainningGetListVideoSuccess extends BlocTrainningState {
  final List<TranningVideo> listVideo;
  final int page;
  final int maxPage;
  const BlocTrainningGetListVideoSuccess({
    required this.listVideo,
    required this.page,
    required this.maxPage,
  });
}

class BlocTrainningGetListFileSuccess extends BlocTrainningState {
  final List<TranningFile> listFile;
  final int page;
  final int maxPage;
  const BlocTrainningGetListFileSuccess({
    required this.listFile,
    required this.page,
    required this.maxPage,
  });
}
