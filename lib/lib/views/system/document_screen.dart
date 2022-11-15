import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rcore/bloc/trainning/bloc_trainning.dart';
import 'package:rcore/models/file.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-button/text_button.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-text/title.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-snackbar/snackbar.dart';

class DocumentScreen extends StatefulWidget {
  final User user;
  final TranningFile file;
  const DocumentScreen({super.key, required this.user, required this.file});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form size
  Size formSize = const Size(0, 0);

  //* Load data
  bool _isLoadedVideo = false;
  List<TranningFile> _listFile = [];

  @override
  void initState() {
    BlocProvider.of<BlocTrainning>(context).add(BlocTranningEventGetListFileEvent(
      context: context,
      userInfo: widget.user,
    ));
    super.initState();
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
        }
      },
      child: RSubLayout(
        user: widget.user,
        globalKey: globalKey,
        bottomNavIndex: 4,
        enableAction: true,
        overlayLoading: !_isLoadedVideo,
        contenPadding: EdgeInsets.zero,
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
            RText(
              title: widget.file.title,
              type: RTextType.title,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: (size.width - 40) * 297.3 / 210,
              child: SfPdfViewer.network(
                'https://homeland.andin.io/upload-file/${widget.file.id}/${widget.file.url}',
                onDocumentLoaded: (details) {
                  debugPrint('https://homeland.andin.io/upload-file/${widget.file.id}/${widget.file.url} loaded');
                },
              ),
            ),
            RTextButton(
              icon: Icons.download_for_offline_rounded,
              text: 'Tải xuống tài liệu',
              color: const Color.fromRGBO(0, 120, 170, 1),
              alignment: MainAxisAlignment.end,
              onPressed: () async {
                final url = 'https://homeland.andin.io/upload-file/${widget.file.id}/${widget.file.url}';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            const Divider(),
            const RText(title: 'Tài liệu khác', type: RTextType.title, alignment: Alignment.centerLeft),
            ...List.generate(
              _listFile.length,
              (index) => _buildFileItem(index, _listFile[index]),
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
