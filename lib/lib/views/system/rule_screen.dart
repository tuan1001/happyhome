import 'package:flutter/material.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-text/title.dart';

class RuleScreen extends StatefulWidget {
  final User user;
  const RuleScreen({super.key, required this.user});

  @override
  State<RuleScreen> createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  //* Form size
  Size formSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    formSize = MediaQuery.of(context).size;
    return RSubLayout(
      user: widget.user,
      globalKey: globalKey,
      bottomNavIndex: 4,
      enableAction: true,
      contenPadding: EdgeInsets.zero,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      title: 'Quy định - Điều khoản',
      body: _buildBody(formSize),
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
          children: const [
            RText(
              title: 'MinhHien Solutions follows a standard procedure  of using log files. '
                  'These files log visitors when they visit websites. All hosting companies'
                  'do this and a part of hosting services\' analytics. The information collected'
                  ' by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP).',
              fontSize: 15,
            ),
            SizedBox(height: 10),
            RText(
              title: 'Third-party ad servers or ad networks uses'
                  'technologies like cookies, JavaScript, or Web'
                  'Beacons that are used in their respective'
                  'advertisements and links that appear on'
                  'MinhHien Solutions, which are sent directly to'
                  'users\' browser. They automatically receive your'
                  'IP address when this occurs. These technologies'
                  'are used to measure the effectiveness of their'
                  'advertising campaigns and/or to personalize the'
                  'advertising content that you see on websites that'
                  'you visit.',
              fontSize: 15,
            ),
            SizedBox(height: 10),
            RText(
              title: 'You can choose to disable cookies through your'
                  'individual browser options. To know more'
                  'detailed information about cookie managernent'
                  'with specific web browsers, it can be found at ttE'
                  'browsers\' respective websites.',
              fontSize: 15,
            )
          ],
        ),
      ),
    ];
  }
}
