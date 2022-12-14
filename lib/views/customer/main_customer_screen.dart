import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odometer/odometer.dart';
import 'package:rcore/bloc/customer/bloc/bloc_customer.dart';
import 'package:rcore/models/customer.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-snackbar/snackbar.dart';
import 'package:rcore/views/customer/customer_detail_screen.dart';
import 'package:rcore/views/rose/rose_screen.dart';
import '../../utils/color/theme.dart';
import '../../utils/r-button/round_button.dart';
import '../../utils/r-button/text_button.dart';
import '../../utils/r-button/type.dart';
import '../../utils/r-dialog/dialog.dart';
import '../../utils/r-dialog/notification_dialog.dart';
import '../../utils/r-dialog/yes_no_dialog.dart';
import '../../utils/r-drawer/bottom_nav_bar.dart';
import '../../utils/r-navigator/navigator.dart';
import '../../utils/r-styled_label/style_label.dart';
import '../../utils/r-text/icon_text.dart';
import '../../utils/r-text/title.dart';
import '../../utils/r-text/type.dart';
import '../../utils/r-textfield/textfield.dart';
import '../../utils/r-textfield/type.dart';

class MainCustomerScreen extends StatefulWidget {
  final User user;

  const MainCustomerScreen({
    super.key,
    required this.user,
  });

  @override
  State<MainCustomerScreen> createState() => _MainCustomerScreenState();
}

class _MainCustomerScreenState extends State<MainCustomerScreen> with SingleTickerProviderStateMixin {
  //* Form list data
  List<Customer> listKhachhang = [];
  bool loadedKhachHang = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  //* Animation controller
  AnimationController? animationController;
  late Animation<OdometerNumber> animation;

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  //* Loaded Balance
  int balance = 0;
  bool loadedBalance = false;
  bool showBalance = false;

  //* Shink Appbar
  bool _isShink = false;

  @override
  void initState() {
    //* Load from data
    BlocProvider.of<BlocCustomer>(context).add(BlocCustomerLoadListEvent(
      userInfo: widget.user,
      page: currentPage,
    ));
    BlocProvider.of<BlocCustomer>(context).add(BlocCustomerLoadCoinEvent(
      userInfo: widget.user,
    ));

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
    animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener<BlocCustomer, BlocCustomerState>(
      listener: (context, state) {
        setState(() {
          loadedKhachHang = state is! BlocCustomerLoading;
          loadedBalance = state is! BlocCustomerLoading;
        });

        if (state is BlocCustomerError) {
          showRNotificationDialog(context, 'Th??ng b??o', state.message);
        }

        if (state is BlocCustomerLoadListSuccess) {
          listKhachhang = state.listCustomer;
        }

        if (state is BlocCustomerLoadCoinSuccess) {
          balance = state.coin;
          animation = OdometerTween(begin: OdometerNumber(balance), end: OdometerNumber(999999999)).animate(
            CurvedAnimation(curve: Curves.bounceIn, parent: animationController!),
          );
        }

        if (state is BlocCustomerCreateSuccess) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          _loadRemainingFormData();
        }

        if (state is BlocCustomerLoadDetailsSuccess) {
          toScreen(CustomerDetailScreen(loadedData: state.customerData, customerInfo: state.customer), context);
          _loadRemainingFormData();
        }

        if (state is BlocCustomerUpdateSuccess) {
          showRToast(message: state.message);
          Navigator.of(context, rootNavigator: false).pop();
          Navigator.of(context, rootNavigator: false).pop();
          _loadFormData();
        }

        if (state is BlocCustomerDeleteSuccess) {
          showRToast(message: state.message);
          _loadFormData();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context, size),
            bottomNavigationBar: BottomNavBar(user: widget.user),
            body: _buildBody(context, size),
          ),
          if (loadedBalance == false || loadedKhachHang == false)
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
            height: _isShink ? 80 : 250,
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
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                AppBar(
                  foregroundColor: Colors.black,
                  title: RTextField(
                    label: 'T??m ki???m kh??ch h??ng',
                    prefixIcon: FontAwesomeIcons.magnifyingGlass,
                    controller: _searchController,
                    backColor: Colors.white.withOpacity(0.6),
                    color: Colors.white,
                    borderRadius: 30,
                    onChanged: _loadRemainingFormData,
                    onTextChange: (value) {
                      if (value.isEmpty) {
                        _loadRemainingFormData();
                      }
                    },
                  ),
                  leading: InkWell(
                    onTap: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AboutUsScreen(userInfo: widget.userInfo)));
                    },
                    child: Container(padding: const EdgeInsets.all(6), child: Image.asset('lib/assets/images/main-logo.png')),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.solidBell),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Statistical(userInfo: widget.userInfo)));
                      },
                    ),
                  ],
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: themeColor),
                ),
                if (!_isShink)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 110, 20, 0),
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
                            SizedBox(height: widget.user.active == 'Ch??? x??c minh' ? 53 : 55),
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
                              margin: widget.user.active == 'Ch??? x??c minh' ? const EdgeInsets.only(bottom: 1) : const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  widget.user.active == 'Ch??? x??c minh' ? _getUserLabel() : const RText(title: 'T???ng hoa h???ng v?? xu hi???n c?? trong v??'),
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
                                              odometerAnimation: animation,
                                              numberTextStyle: const TextStyle(fontSize: 13),
                                            ),
                                            const SizedBox(width: 5),
                                            if (showBalance) const Icon(FontAwesomeIcons.coins, size: 12, color: Colors.black),
                                            const SizedBox(width: 3),
                                            SlideOdometerTransition(
                                              verticalOffset: 1,
                                              groupSeparator: const Text(','),
                                              letterWidth: 10,
                                              odometerAnimation: animation,
                                              numberTextStyle: const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const RText(
                                        title: '* * * * * * * * *',
                                      ),
                                if (showBalance) const RText(title: ' Xu'),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    if (!showBalance) {
                                      _animationCount();
                                      showBalance = true;
                                      setState(() {});
                                    } else {
                                      animationController!.reverse();
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
        loadedBalance = false;
        _loadRemainingFormData();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RText(title: 'Danh s??ch', type: RTextType.title, color: themeColor),
                RTextButton(
                  text: 'Th??m',
                  onPressed: () {
                    TextEditingController nameController = TextEditingController();
                    TextEditingController phoneController = TextEditingController();
                    TextEditingController noteController = TextEditingController();
                    showRDiaLog(
                      context,
                      [
                        const RText(title: 'Th??m kh??ch h??ng ', type: RTextType.title, color: themeColor),
                        RTextField(label: 'H??? v?? t??n ???*???', controller: nameController),
                        RTextField(
                          label: 'S??? ??i???n tho???i ???*???',
                          controller: phoneController,
                          type: RTextFieldType.number,
                          maxLength: 10,
                        ),
                        RTextField(
                          label: 'Ghi ch??',
                          controller: noteController,
                          type: RTextFieldType.multiline,
                        ),
                        RButton(
                          text: 'Th??m kh??ch h??ng',
                          onPressed: () {
                            BlocProvider.of<BlocCustomer>(context).add(
                              BlocCustomerCreateEvent(
                                userInfo: widget.user,
                                name: nameController.text,
                                phone: phoneController.text,
                                note: noteController.text,
                              ),
                            );
                          },
                          radius: 5,
                        ),
                      ],
                    );
                  },
                  icon: FontAwesomeIcons.plus,
                  type: RTextType.title,
                )
              ],
            ),
            const Divider(),
            if (listKhachhang.isNotEmpty)
              ...List<Widget>.generate(
                  listKhachhang.length,
                  (index) => _buildCustomerItem(
                        context,
                        customerInfo: listKhachhang[index],
                      )),
            if (listKhachhang.isNotEmpty) SizedBox(height: _getBottomSize(size.height, listKhachhang.length)),
          ],
        ),
      ),
    );
  }

  _loadFormData() {
    BlocProvider.of<BlocCustomer>(context).add(BlocCustomerLoadListEvent(
      userInfo: widget.user,
      page: currentPage,
      keySearch: _searchController.text,
    ));
  }

  _loadRemainingFormData() {
    setState(() {
      loadedKhachHang = false;
      listKhachhang = [];
      currentPage = 1;
      _loadFormData();
    });
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
          title: 'C???p nh???t phi??n b???n m???i',
          content: 'Phi??n b???n m???i ???? c?? s???n, xin vui l??ng c???p nh???t phi??n b???n m???i?',
          cancelButtonText: '????? sau',
          updateButtonText: 'C???p nh???t',
        );
      }
    });
  }

  Widget _buildCustomerItem(
    BuildContext context, {
    required Customer customerInfo,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: themeColor.withOpacity(0.1),
          blurRadius: 3,
          spreadRadius: 0,
          //offset: Offset(-2,2)
        )
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RIconText(
                maxLines: 1,
                width: MediaQuery.of(context).size.width - 180,
                title: customerInfo.name ?? '',
                icon: FontAwesomeIcons.solidUser,
                color: themeColor,
              ),
              _getCustomerLabel(customerInfo.active!),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RIconText(title: customerInfo.phone ?? '', icon: FontAwesomeIcons.phone),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: RTextButton(
                      icon: FontAwesomeIcons.eye,
                      text: 'Xem chi ti???t',
                      color: Colors.black,
                      alignment: MainAxisAlignment.start,
                      onPressed: () async {
                        Navigator.pop(context);
                        BlocProvider.of<BlocCustomer>(context).add(BlocCustomerDetailEvent(
                          customerInfo: customerInfo,
                          userInfo: widget.user,
                          id: customerInfo.id ?? 0,
                        ));
                      },
                    ),
                  ),
                  if (customerInfo.active == 'Ch??? x??c minh')
                    PopupMenuItem(
                      child: RTextButton(
                        icon: FontAwesomeIcons.pen,
                        text: 'S???a',
                        color: Colors.black,
                        alignment: MainAxisAlignment.start,
                        onPressed: () {
                          TextEditingController nameController = TextEditingController(text: customerInfo.name ?? '');
                          TextEditingController phoneController = TextEditingController(text: customerInfo.phone ?? '');
                          TextEditingController noteController = TextEditingController(text: customerInfo.note ?? '');
                          showRDiaLog(context, [
                            const RText(title: 'S???a kh??ch h??ng', type: RTextType.title),
                            RTextField(label: 'H??? v?? t??n ???*???', controller: nameController),
                            RTextField(
                              label: 'S??? ??i???n tho???i ???*???',
                              maxLength: 10,
                              controller: phoneController,
                              type: RTextFieldType.number,
                            ),
                            RTextField(
                              label: 'Ghi ch??',
                              controller: noteController,
                              type: RTextFieldType.multiline,
                            ),
                            RButton(
                                text: 'S???a kh??ch h??ng',
                                onPressed: () {
                                  BlocProvider.of<BlocCustomer>(context).add(BlocCustomerUpdateEvent(
                                    userInfo: widget.user,
                                    id: customerInfo.id ?? 0,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    note: noteController.text,
                                  ));
                                },
                                radius: 5),
                          ]);
                        },
                      ),
                    ),
                  if (customerInfo.active == 'Ch??? x??c minh')
                    PopupMenuItem(
                      child: RTextButton(
                        icon: FontAwesomeIcons.trashCan,
                        text: 'X??a',
                        color: Colors.red,
                        alignment: MainAxisAlignment.start,
                        onPressed: () {
                          showRYesNoDialog(
                            context,
                            'Th??ng b??o',
                            'B???n c?? ch???c ch???n mu???n x??a kh??ch h??ng kh??ng?',
                            () {
                              Navigator.pop(context);
                              BlocProvider.of<BlocCustomer>(context).add(BlocCustomerDeleteEvent(
                                userInfo: widget.user,
                                id: customerInfo.id ?? 0,
                              ));
                            },
                            () {},
                          );
                        },
                      ),
                    ),
                ],
                child: const Icon(FontAwesomeIcons.ellipsis),
              )
            ],
          )
        ],
      ),
    );
  }

  double _getBottomSize(double height, int length) {
    if (((height - 374) / 79.0) < length && length < ((height - 188) / 79.0)) {
      return ((height - 188)) - length * 79.0;
    }
    return 0;
  }

  _animationCount() async {
    await animationController!.forward();
    animationController!.reverse();
  }

  Widget _getUserLabel() {
    switch (widget.user.active) {
      case 'Ch??? x??c minh':
        return RStyledLabel(
          text: 'Ch??? x??c minh',
          color: rButtonBackground(RButtonType.warning),
          icon: FontAwesomeIcons.circleXmark,
        );
      default:
        // return const RStyledLabel(text: 'Chung', color: Colors.grey, icon: FontAwesomeIcons.circleDot);
        return Container();
    }
  }

  Widget _getCustomerLabel(String active) {
    switch (active) {
      case 'Ch??? x??c minh':
        return RStyledLabel(
          text: 'Ch??? x??c minh',
          color: rButtonBackground(RButtonType.warning),
          icon: FontAwesomeIcons.circleXmark,
        );
      case '???? x??c minh':
        return RStyledLabel(
          text: '???? x??c minh',
          color: rButtonBackground(RButtonType.success),
          icon: FontAwesomeIcons.circleCheck,
        );
      case '???? xem':
        return RStyledLabel(
          text: '???? xem',
          color: rButtonBackground(RButtonType.primary),
          icon: FontAwesomeIcons.eye,
        );
      case 'Giao d???ch':
        return const RStyledLabel(
          text: 'Giao d???ch',
          color: Colors.purple,
          icon: FontAwesomeIcons.circleDollarToSlot,
        );
      case 'Ti???m n??ng':
        return const RStyledLabel(
          text: 'Ti???m n??ng',
          color: themeColor,
          icon: FontAwesomeIcons.chartLine,
        );
      default:
        return const RStyledLabel(text: 'Chung', color: Colors.grey, icon: FontAwesomeIcons.circleDot);
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
