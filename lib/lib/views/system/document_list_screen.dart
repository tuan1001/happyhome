import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rcore/bloc/trainning/bloc_trainning.dart';
import 'package:rcore/models/file.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/views/system/document_screen.dart';

import '../../utils/color/theme.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-snackbar/snackbar.dart';
import '../../utils/r-text/type.dart';

class DocumentListScreen extends StatefulWidget {
  final User user;
  const DocumentListScreen({super.key, required this.user});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form size
  Size formSize = const Size(0, 0);

  //* Page navigation
  int pageIndex = 1;
  int pageMaxSize = 1;

  //* Load data
  bool _isLoadedVideo = false;
  List<TranningFile> _listFile = [];

  @override
  void initState() {
    _loadFormData();
    super.initState();
  }

  void _loadFormData() {
    BlocProvider.of<BlocTrainning>(context).add(BlocTranningEventGetListFileEvent(
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

        if (state is BlocTrainningGetListFileSuccess) {
          _listFile = state.listFile;
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
        contenPadding: EdgeInsets.zero,
        overlayLoading: !_isLoadedVideo,
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        title: 'Tài liệu bất động sản',
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
              _listFile.length,
              (index) => _buildFileItem(index, _listFile[index]),
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

  InkWell _buildFileItem(int index, TranningFile file) {
    return InkWell(
      onTap: () {
        toScreen(DocumentScreen(user: widget.user, file: file), context);
      },
      child: Row(
        children: [
          Container(
            width: formSize.width * .18,
            height: 70,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset('lib/assets/icons/pdf.svg'),
          ),
          Expanded(
            child: RText(
              title: _listFile[index].title,
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
