part of 'bloc_trainning.dart';

abstract class BlocTrainningEvent {
  const BlocTrainningEvent();
}

class BlocTranningEventGetListVideoEvent extends BlocTrainningEvent {
  final BuildContext context;
  final User userInfo;
  BlocTranningEventGetListVideoEvent({
    required this.context,
    required this.userInfo,
  });
}

class BlocTranningEventGetListFileEvent extends BlocTrainningEvent {
  final BuildContext context;
  final User userInfo;
  BlocTranningEventGetListFileEvent({
    required this.context,
    required this.userInfo,
  });
}
