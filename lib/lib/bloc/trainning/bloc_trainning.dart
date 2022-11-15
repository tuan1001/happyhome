import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:rcore/models/file.dart';

import '../../controller/training_controller.dart';
import '../../models/user.dart';
import '../../models/video.dart';

part 'bloc_trainning_event.dart';
part 'bloc_trainning_state.dart';

class BlocTrainning extends Bloc<BlocTrainningEvent, BlocTrainningState> {
  BuildContext context;

  BlocTrainning({required this.context}) : super(const BlocTrainningInitial()) {
    on<BlocTranningEventGetListVideoEvent>((event, emit) async {
      emit(const BlocTrainningInitial());
      Map<String, dynamic>? data = await getListTranningVideo(
        context: event.context,
        userInfo: event.userInfo,
      );

      if (data != null) {
        List<TranningVideo> videos = [];
        for (var element in data['data'] as List) {
          videos.add(TranningVideo.fromMap(element));
        }
        emit(BlocTrainningGetListVideoSuccess(listVideo: videos, page: data['perPage'], maxPage: data['metaPage']));
      }

      emit(const BlocTrainningInitial());
    });

    on<BlocTranningEventGetListFileEvent>((event, emit) async {
      emit(const BlocTrainningInitial());
      Map<String, dynamic>? data = await getListTranningFile(
        context: event.context,
        userInfo: event.userInfo,
      );

      if (data != null) {
        List<TranningFile> files = [];
        for (var element in data['data'] as List) {
          files.add(TranningFile.fromMap(element));
        }
        emit(BlocTrainningGetListFileSuccess(listFile: files, page: data['perPage'], maxPage: data['metaPage']));
      }

      emit(const BlocTrainningInitial());
    });
  }
}
