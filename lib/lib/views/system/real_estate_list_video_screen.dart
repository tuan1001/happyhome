import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rcore/bloc/trainning/bloc_trainning.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/models/video.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/views/system/real_estate_video_screen.dart';

import '../../utils/color/theme.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-text/type.dart';

class RealEstateListVideoScreen extends StatefulWidget {
  final User user;
  const RealEstateListVideoScreen({super.key, required this.user});

  @override
  State<RealEstateListVideoScreen> createState() => _RealEstateListVideoScreenState();
}

class _RealEstateListVideoScreenState extends State<RealEstateListVideoScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form size
  Size formSize = const Size(0, 0);

  //* Form navigation
  int pageIndex = 1;
  int pageMaxSize = 1;

  //* Load data
  bool _isLoadedVideo = false;
  List<TranningVideo> _listVideo = [];

  @override
  void initState() {
    _loadFormData();
    super.initState();
  }

  void _loadFormData() {
    BlocProvider.of<BlocTrainning>(context).add(BlocTranningEventGetListVideoEvent(
      context: context,
      userInfo: widget.user,
    ));
  }

  @override
  Widget build(BuildContext context) {
    formSize = MediaQuery.of(context).size;
    return BlocListener<BlocTrainning, BlocTrainningState>(
      listener: (context, state) {
        setState(() {
          _isLoadedVideo = state is! BlocTrainningLoading;
        });

        if (state is BlocTrainningError) {
          showRToast(message: state.message);
        }

        if (state is BlocTrainningGetListVideoSuccess) {
          _listVideo = state.listVideo;
          pageIndex = state.page;
          pageMaxSize = state.maxPage;
        }
      },
      child: RSubLayout(
        user: widget.user,
        globalKey: globalKey,
        bottomNavIndex: 4,
        enableAction: true,
        onRefresh: () async {
          pageIndex = 1;
          _loadFormData();
        },
        overlayLoading: !_isLoadedVideo,
        contenPadding: EdgeInsets.zero,
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        title: 'Video bất động sản',
        body: _buildBody(formSize),
      ),
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
            ...List.generate(
              _listVideo.length,
              (index) => _buildListVideo(_listVideo[index]),
            ),
            if (pageMaxSize > 1)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (pageIndex > 1) {
                          pageIndex--;
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: (pageIndex > 1) ? textColor : Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: buttonPrimaryColorActive,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(30))),
                        child: Text('$pageIndex'),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (pageIndex < pageMaxSize) pageIndex++;
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      color: (pageIndex < pageMaxSize) ? textColor : Colors.transparent,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ];
  }

  InkWell _buildListVideo(TranningVideo video) {
    return InkWell(
      onTap: () {
        toScreen(RealEstateVideoScreen(user: widget.user, video: video), context);
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
