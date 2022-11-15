import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rcore/bloc/trainning/bloc_trainning.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-navigator/navigator.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/video.dart';
import '../../utils/r-snackbar/snackbar.dart';
import '../../utils/r-text/type.dart';

class RealEstateVideoScreen extends StatefulWidget {
  final User user;
  final TranningVideo video;
  const RealEstateVideoScreen({super.key, required this.user, required this.video});

  @override
  State<RealEstateVideoScreen> createState() => _RealEstateVideoScreenState();
}

class _RealEstateVideoScreenState extends State<RealEstateVideoScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form size
  Size formSize = const Size(0, 0);

  //* Form controller
  late YoutubePlayerController _youtubePlayerController;

  //* Load data
  bool _isLoadedVideo = false;
  List<TranningVideo> _listVideo = [];

  @override
  void initState() {
    _initVideo(widget.video.url);
    BlocProvider.of<BlocTrainning>(context).add(BlocTranningEventGetListVideoEvent(
      context: context,
      userInfo: widget.user,
    ));
    super.initState();
  }

  void _initVideo(String videoURL) {
    debugPrint('Video: $videoURL');
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: true,
        showLiveFullscreenButton: true,
        hideThumbnail: true,
        useHybridComposition: true,
        disableDragSeek: true,
        hideControls: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    formSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? Scaffold(
                body: Container(padding: const EdgeInsets.all(10), child: _buildVideoPlayer()),
              )
            : BlocListener<BlocTrainning, BlocTrainningState>(
                listener: (context, state) {
                  setState(() {
                    _isLoadedVideo = state is! BlocTrainningLoading;
                  });

                  if (state is BlocTrainningError) {
                    showRToast(message: state.message);
                  }

                  if (state is BlocTrainningGetListVideoSuccess) {
                    _listVideo = state.listVideo;
                  }
                },
                child: RSubLayout(
                  onRefresh: () async {
                    // setState(() {});
                  },
                  user: widget.user,
                  globalKey: globalKey,
                  extendBody: false,
                  bottomNavIndex: 4,
                  showBottomNavBar: true,
                  overlayLoading: !_isLoadedVideo,
                  enableAction: true,
                  contenPadding: EdgeInsets.zero,
                  backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
                  title: 'Video bất động sản',
                  body: _buildBody(formSize),
                ),
              );
      }),
    );
  }

  List<Widget> _buildBody(Size size) {
    return [
      Container(
        constraints: BoxConstraints(
          minHeight: size.height - 103.7 - size.width * .155,
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            _buildVideoPlayer(),
            RText(
              title: _youtubePlayerController.metadata.title.isEmpty ? widget.video.title : _youtubePlayerController.metadata.title,
              type: RTextType.subtitle,
            ),
            const Divider(),
            const RText(title: 'Video khác', type: RTextType.title, alignment: Alignment.centerLeft),
            ...List.generate(
              _listVideo.length,
              (index) => _buildListVideo(_listVideo[index]),
            ),
          ],
        ),
      ),
    ];
  }

  YoutubePlayer _buildVideoPlayer() {
    return YoutubePlayer(
      controller: _youtubePlayerController,
      showVideoProgressIndicator: true,
      // topActions: [
      //   const SizedBox(width: 8.0),
      //   Expanded(
      //     child: Text(
      //       _youtubePlayerController.metadata.title,
      //       style: const TextStyle(
      //         color: Colors.white,
      //         fontSize: 18.0,
      //       ),
      //       overflow: TextOverflow.ellipsis,
      //       maxLines: 1,
      //     ),
      //   ),
      // ],
    );
  }

  InkWell _buildListVideo(TranningVideo video) {
    return InkWell(
      onTap: () {
        replaceScreen(RealEstateVideoScreen(user: widget.user, video: video), context);
      },
      child: Row(
        children: [
          Container(
            width: formSize.width * .3,
            height: 70,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
              image: DecorationImage(
                image: NetworkImage('https://homeland.andin.io/upload-file/${video.imageUrl}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: RText(
              title: video.description,
              type: RTextType.subtitle,
              maxLines: 4,
              alignment: Alignment.topLeft,
            ),
          ),
        ],
      ),
    );
  }
}
