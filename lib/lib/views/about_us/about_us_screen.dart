import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:rcore/models/user.dart';
import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/utils/r-button/type.dart';
import 'package:rcore/utils/r-layout/sub_layout.dart';
import 'package:rcore/utils/r-text/type.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/r-text/title.dart';

class AboutUsScreen extends StatefulWidget {
  final User user;
  const AboutUsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final MapController _mapController = MapController();
  final LatLng _happyHomeLocation = LatLng(20.82789718906527, 106.68430599874057);

  @override
  Widget build(BuildContext context) {
    return RSubLayout(
      user: widget.user,
      globalKey: globalKey,
      title: 'Về Happy Home',
      bottomNavIndex: 4,
      enableAction: true,
      body: [
        Column(
          children: [
            Image.asset(
              'lib/assets/images/landing-logo.png',
              width: MediaQuery.of(context).size.width / 2,
            )
          ],
        ),
        const RText(
          title: 'Địa chỉ',
          type: RTextType.title,
          color: themeColor,
        ),
        const RText(title: 'Số 19 đường 613 Thiên Lôi, Phường Vĩnh Niệm, Quận Lê Chân, Thành phố Hải Phòng'),
        Divider(
          color: Colors.grey.shade200,
        ),
        const RText(
          title: 'Điện thoại',
          type: RTextType.title,
          color: themeColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const RText(title: '02253.513.666'),
            InkWell(
              onTap: () {
                launchUrlString('tel://02253513666');
              },
              child: Icon(FontAwesomeIcons.phone, size: 20, color: rButtonBackground(RButtonType.success)),
            )
          ],
        ),
        Divider(
          color: Colors.grey.shade200,
        ),
        const RText(
          title: 'Hotline',
          type: RTextType.title,
          color: themeColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const RText(title: '0825.257.666'),
            InkWell(
              onTap: () {
                launchUrlString('tel://0825257666');
              },
              child: Icon(FontAwesomeIcons.phone, size: 20, color: rButtonBackground(RButtonType.success)),
            ),
          ],
        ),
        Divider(
          color: Colors.grey.shade200,
        ),
        const RText(
          title: 'Email',
          type: RTextType.title,
          color: themeColor,
        ),
        const RText(title: 'hphomevn@gmail.com'),
        Divider(
          color: Colors.grey.shade200,
        ),
        const RText(
          title: 'Website',
          type: RTextType.title,
          color: themeColor,
        ),
        const RText(title: 'https://happyhomehaiphong.com/'),
        Divider(color: Colors.grey.shade200),
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _happyHomeLocation,
              zoom: 15.0,
              maxZoom: 18.0,
              keepAlive: true,
              onTap: (tapPosition, tapPoint) => _mapController.move(_happyHomeLocation, _mapController.zoom),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'org.andin.histore',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _happyHomeLocation,
                    builder: (ctx) => const Icon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 50)
      ],
    );
  }
}
