import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:odometer/odometer.dart';
import 'package:rcore/controller/service_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:rcore/bloc/customer/bloc_customer.dart';
import 'package:rcore/bloc/user/bloc_user.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/views/rose/rose_screen.dart';

import '../../utils/color/theme.dart';
import '../../utils/r-button/type.dart';
import '../../utils/r-dialog/notification_dialog.dart';
import '../../utils/r-drawer/bottom_nav_bar.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-styled_label/style_label.dart';
import '../../utils/r-text/icon_text.dart';
import '../../utils/r-text/title.dart';
import '../../utils/r-text/title_and_text.dart';
import '../../utils/r-text/type.dart';
import '../../utils/r-textfield/textfield.dart';
import '../../utils/r-textfield/type.dart';
import 'pie_chart.dart';

class MainStatisticalScreen extends StatefulWidget {
  final User user;

  const MainStatisticalScreen({
    super.key,
    required this.user,
  });

  @override
  State<MainStatisticalScreen> createState() => _MainStatisticalScreenState();
}

class _MainStatisticalScreenState extends State<MainStatisticalScreen> with TickerProviderStateMixin {
  //* Animation controller
  AnimationController? animationRoseController;
  AnimationController? animationCoinController;
  late Animation<OdometerNumber> animationCoin;
  late Animation<OdometerNumber> animationRose;

  //* Form controller
  final ScrollController _scrollController = ScrollController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  int currentPage = 1;

  @override
  void dispose() {
    animationRoseController?.dispose();
    animationCoinController?.dispose();
    super.dispose();
  }

  //* Loaded Balance
  int coin = 0;
  int rose = 0;
  bool _loadUserRoseAndCoin = false;
  bool showBalance = false;

  //* Statistical data
  Map<String, dynamic> statisticalData = {};
  bool _loadedStatisticalData = false;

  //* Shink Appbar
  bool _isShink = false;

  @override
  void initState() {
    _getStatistical();
    fromDateController.text = DateFormat('MM/yyyy').format(DateTime.utc(DateTime.now().year, DateTime.now().month));
    toDateController.text = DateFormat('MM/yyyy').format(DateTime.utc(DateTime.now().year, DateTime.now().month));

    //* Check app update
    Future.delayed(Duration.zero, () {
      _checkUpdateApp();
    });

    //* Animation
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
        setState(() {
          _isShink = false;
        });
      } else {
        _isShink = true;
        // _showInfo = false;
        setState(() {});
      }
    });

    //* Money change animation :)
    animationRoseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animationCoinController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<BlocCustomer, BlocCustomerState>(
          listener: (context, state) {
            setState(() {
              _loadUserRoseAndCoin = state is! BlocCustomerLoading;
            });

            if (state is BlocCustomerError) {
              showRNotificationDialog(context, 'Thông báo', state.message);
            }

            if (state is BlocCustomerLoadCoinSuccess) {
              coin = state.coin;
              rose = state.rose;
              animationCoin = OdometerTween(begin: OdometerNumber(coin), end: OdometerNumber(999999999)).animate(
                CurvedAnimation(curve: Curves.bounceIn, parent: animationCoinController!),
              );
              animationRose = OdometerTween(begin: OdometerNumber(rose), end: OdometerNumber(999999999)).animate(
                CurvedAnimation(curve: Curves.bounceIn, parent: animationRoseController!),
              );
            }
          },
        ),
        BlocListener<BlocUser, BlocUserState>(
          listener: (context, state) {
            setState(() {
              _loadedStatisticalData = state is! BlocUserLoading;
            });

            if (state is BlocUserStatisticalLoaded) {
              statisticalData = state.data;
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            appBar: _buildAppBar(context, size),
            bottomNavigationBar: BottomNavBar(user: widget.user),
            body: _buildBody(context, size),
          ),
          if (_loadUserRoseAndCoin == false || _loadedStatisticalData == false)
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context, Size size) {
    return PreferredSize(
      preferredSize: Size.fromHeight(_isShink ? 80 : 260),
      child: Wrap(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: _isShink ? 80 : 230,
            onEnd: () {
              // setState(() {
              //   _showInfo = true;
              // });
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  child: Image.asset(
                    'lib/assets/images/main-background.jpg',
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                AppBar(
                  foregroundColor: Colors.black,
                  title: const Text('TỔNG QUAN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  leading: InkWell(
                    onTap: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AboutUsScreen(userInfo: widget.userInfo)));
                    },
                    child: Container(padding: const EdgeInsets.all(6), child: Image.asset('lib/assets/images/main-logo.png')),
                  ),
                  actions: const [
                    // IconButton(
                    // icon: const Icon(FontAwesomeIcons.solidBell),
                    // onPressed: () async {
                    // final urlImg = 'https://picsum.photos/200/300';
                    // final response = await http.get(Uri.parse(urlImg));
                    // // final response = await Dio().get(urlImg);
                    // final bytes = response.bodyBytes;
                    // final temp = await getTemporaryDirectory();
                    // final path = '${temp.path}/image.jpg';
                    // File(path).writeAsBytesSync(bytes);
                    // await Share.shareFiles([path], text: 'Share image');
                    // await Share.share('This is test share feature\r\nhttps://picsum.photos/200/300');
                    // },
                    // ),
                    SizedBox(width: 40),
                  ],
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: themeColor),
                ),
                if (!_isShink)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 90, 20, 0),
                    // padding: const EdgeInsets.fromLTRB(20, 35, 20, 15),
                    height: 140,
                    constraints: const BoxConstraints(minHeight: 150, maxHeight: 170),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(size.width - 40, 140),
                          painter: InfoPaint(),
                        ),
                        Center(
                          heightFactor: 0.6,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: (size.width * 0.15) / 2 + 3,
                            backgroundImage: widget.user.profileImageUrl == null
                                ? null
                                : NetworkImage('https://homeland.andin.io/images/${widget.user.profileImageUrl}'),
                            onBackgroundImageError: (o, s) {},
                            child: widget.user.profileImageUrl != null
                                ? null
                                : Icon(
                                    FontAwesomeIcons.solidCircleUser,
                                    size: size.width * 0.15 + 1,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: widget.user.active == 'Chờ xác minh' ? 53 : 55),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RIconText(
                                  title: widget.user.name ?? '',
                                  icon: FontAwesomeIcons.solidUser,
                                  iconSize: 12,
                                  type: RTextType.subtitle,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 10),
                                RIconText(
                                  title: widget.user.phone ?? '',
                                  icon: FontAwesomeIcons.phone,
                                  iconSize: 12,
                                  type: RTextType.subtitle,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            Container(
                              margin: widget.user.active == 'Chờ xác minh' ? const EdgeInsets.only(bottom: 1) : const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  widget.user.active == 'Chờ xác minh' ? _getUserLabel() : const RText(title: 'Tổng hoa hồng và xu hiện có trong ví'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                showBalance
                                    ? InkWell(
                                        onTap: () {
                                          replaceScreen(RoseScreen(user: widget.user), context);
                                        },
                                        child: Row(
                                          children: [
                                            if (showBalance) const Icon(FontAwesomeIcons.dollarSign, size: 12, color: Colors.black),
                                            SlideOdometerTransition(
                                              verticalOffset: 1,
                                              groupSeparator: const Text(','),
                                              letterWidth: 10,
                                              odometerAnimation: animationRose,
                                              numberTextStyle: const TextStyle(fontSize: 13),
                                            ),
                                            const SizedBox(width: 8),
                                            if (showBalance) const Icon(FontAwesomeIcons.coins, size: 12, color: Colors.black),
                                            const SizedBox(width: 3),
                                            SlideOdometerTransition(
                                              verticalOffset: 1,
                                              groupSeparator: const Text(','),
                                              letterWidth: 10,
                                              odometerAnimation: animationCoin,
                                              numberTextStyle: const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const RText(
                                        title: '* * * * * * * * *',
                                      ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    if (!showBalance) {
                                      _animationRose();
                                      _animationCoin();
                                      showBalance = true;
                                      setState(() {});
                                    } else {
                                      animationCoinController!.reverse();
                                      animationRoseController!.reverse();
                                      showBalance = false;
                                      // afterDelay = false;
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(!showBalance ? FontAwesomeIcons.solidEyeSlash : FontAwesomeIcons.solidEye, size: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  RefreshIndicator _buildBody(BuildContext context, Size size) {
    return RefreshIndicator(
      onRefresh: () async {
        _getStatistical();
      },
      child: ListView(
        shrinkWrap: true,
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 15),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 45,
                      child: RTextField(
                        label: 'Từ tháng',
                        prefixIcon: FontAwesomeIcons.calendarDays,
                        controller: fromDateController,
                        type: RTextFieldType.date,
                        customDateFormat: 'MM/yyyy',
                        datePickerType: DateRangePickerView.year,
                        onDateConfirm: _getStatistical,
                        onDateRemove: _getStatistical,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 45,
                      child: RTextField(
                        label: 'Đến tháng',
                        prefixIcon: FontAwesomeIcons.calendarDays,
                        controller: toDateController,
                        type: RTextFieldType.date,
                        datePickerType: DateRangePickerView.year,
                        customDateFormat: 'MM/yyyy',
                        onDateConfirm: _getStatistical,
                        onDateRemove: _getStatistical,
                      ),
                    ),
                  ],
                ),
                CustomerStatisticalPieChart(
                  statisticalData: statisticalData,
                  fromDate: fromDateController.text.isEmpty ? fromDateController.text : ' từ ${fromDateController.text}',
                  toDate: toDateController.text.isEmpty ? toDateController.text : ' đến ${toDateController.text}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                fromDateController.text.isEmpty && toDateController.text.isEmpty
                    ? Text('Thống kê thu nhập tháng ${DateTime.now().month}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                    : const Text('Thống kê thu nhập', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                RTitleAndText(
                    title: 'Hoa hồng',
                    text: '${numberFormatCurrency(statisticalData['hoa_hong'] ?? 0)} Triệu',
                    underline: true,
                    titleType: RTextType.title,
                    textType: RTextType.subtitle),
                RTitleAndText(
                    title: 'Tổng xu',
                    text: '${numberFormatCurrency(statisticalData['tong_xu'] ?? 0)} Xu',
                    titleType: RTextType.title,
                    textType: RTextType.subtitle),
                RTitleAndText(
                    title: 'Xu đã rút',
                    text: '${numberFormatCurrency(statisticalData['rut_tien'] ?? 0)} Xu',
                    titleType: RTextType.title,
                    textType: RTextType.subtitle),
                RTitleAndText(
                    title: 'Xu còn lại',
                    text: '${numberFormatCurrency(statisticalData['vi_dien_tu'] ?? 0)} Xu',
                    titleType: RTextType.title,
                    textType: RTextType.subtitle),
              ],
            ),
          ),
          SizedBox(height: _getBottomSize(size)),
        ],
      ),
    );
  }

  double _getBottomSize(Size size) {
    double bottomSize = statisticalData.isEmpty ? size.height - 649.5 - size.width * 0.155 : size.height - 783.5 - size.width * 0.155;

    return bottomSize < 0 ? 0 : bottomSize;
  }

  _checkUpdateApp() async {
    const appleId = '1642248524'; // If this value is null, its packagename will be considered
    const playStoreId = 'andin.ctvhappyhome.io'; // If this value is null, its packagename will be considered
    const country = 'vn'; // If this value is null 'us' will be the default value
    await AppVersionUpdate.checkForUpdates(appleId: appleId, playStoreId: playStoreId, country: country).then((data) async {
      debugPrint(data.storeUrl);
      debugPrint(data.storeVersion);
      if (data.canUpdate!) {
        AppVersionUpdate.showAlertUpdate(
          appVersionResult: data,
          context: context,
          title: 'Cập nhật phiên bản mới',
          content: 'Phiên bản mới đã có sẵn, xin vui lòng cập nhật phiên bản mới?',
          cancelButtonText: 'Để sau',
          updateButtonText: 'Cập nhật',
        );
      }
    });
  }

  void _getStatistical() {
    BlocProvider.of<BlocCustomer>(context).add(BlocCustomerLoadCoinEvent(
      userInfo: widget.user,
    ));

    BlocProvider.of<BlocUser>(context).add(BlocLoadUserStatisticalEvent(
      user: widget.user,
      fromDate: fromDateController.text,
      toDate: toDateController.text,
    ));
  }

  _animationCoin() async {
    await animationCoinController!.forward();
    animationCoinController!.reverse();
  }

  _animationRose() async {
    await animationRoseController!.forward();
    animationRoseController!.reverse();
  }

  Widget _getUserLabel() {
    switch (widget.user.active) {
      case 'Chờ xác minh':
        return SizedBox(
          width: 120,
          child: RStyledLabel(
            text: 'Chờ xác minh',
            color: rButtonBackground(RButtonType.warning),
            icon: FontAwesomeIcons.circleXmark,
          ),
        );
      default:
        // return const RStyledLabel(text: 'Chung', color: Colors.grey, icon: FontAwesomeIcons.circleDot);
        return Container();
    }
  }
}

class InfoPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(0, 30)
      ..quadraticBezierTo(size.width * 0.2, 0, size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.4, 0, size.width * 0.4, 20)
      ..arcToPoint(Offset(size.width * 0.6, 20), radius: const Radius.circular(10.0), clockwise: false)
      ..quadraticBezierTo(size.width * 0.6, 0, size.width * 0.65, 0)
      ..quadraticBezierTo(size.width * 0.8, 0, size.width, 30)
      ..lineTo(size.width, size.height - 10)
      ..quadraticBezierTo(size.width, size.height, size.width - 10, size.height)
      ..lineTo(10, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 10)
      ..close();
    canvas.drawShadow(path, Colors.white, 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
