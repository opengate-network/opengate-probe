import 'dart:io';

import 'package:flutter/material.dart';
import 'package:opengate_probe/black.dart';
import 'package:opengate_probe/interface_information_page.dart';
import 'package:opengate_probe/password.dart';
import 'package:opengate_probe/speedtest.dart';

import 'info_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTitle(),
          ConnectionBar(),
          HomeResult(),
          const HomeMenu(),
        ],
      ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            height: 30,
            child: Image.asset("assets/cropped_transparent-bleu.png"),
          ),
          const SizedBox(width: 9),
          Text(
            "Probe",
            style: textTheme.titleLarge?.merge(const TextStyle(fontSize: 28)),
          ),
        ],
      ),
    );
  }
}

class HomeResult extends StatelessWidget {
  HomeResult({super.key});

  final speedtestResults = InfoProvider.speedtestResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: StreamBuilder(
        stream: speedtestResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Speedtest results are loading...");
          }
          List<ResultModel> results = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Last speedtest : ${results[0].date}"),
            ],
          );
        },
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Center(
        child: Wrap(
          children: [
            HomeMenuButton(
              text: "Interfaces",
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      InterfaceInformationPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
            HomeMenuButton(
              text: "Speedtest results",
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      SpeedtestPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
            HomeMenuButton(
              text: "Change password",
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const PasswordPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
            HomeMenuButton(
              text: "Turn off screen",
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const BlackPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
            HomeMenuButton(
              text: "Reboot",
              onTap: () {
                Process.run('sudo', ['reboot']);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const HomeMenuButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 100,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Text(
                text,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectionBar extends StatelessWidget {
  final wifiInfo = InfoProvider.wifiInfo();
  final interfaceStream = InfoProvider.interfaces();

  static const IconColor = Color(0xff616161);

  ConnectionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          StreamBuilder(
            stream: wifiInfo,
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];
              final info = data.isNotEmpty ? data[0] : WifiInfoModel.empty;

              IconData wifiIcon = Icons.signal_wifi_off;

              if (!snapshot.hasData) {
                wifiIcon = Icons.wifi_find_outlined;
              } else if (info.signal > 0) {
                wifiIcon = Icons.signal_wifi_off;
              } else if (info.signal > -30) {
                wifiIcon = Icons.signal_wifi_4_bar;
              } else if (info.signal > -50) {
                wifiIcon = Icons.network_wifi;
              } else if (info.signal > -60) {
                wifiIcon = Icons.network_wifi_3_bar;
              } else if (info.signal > -70) {
                wifiIcon = Icons.network_wifi_2_bar;
              } else if (info.signal > -80) {
                wifiIcon = Icons.network_wifi_1_bar;
              } else {
                wifiIcon = Icons.signal_wifi_0_bar;
              }

              String freq = "";
              if (info.frequency >= 5) {
                freq = "(5G)";
              } else if (info.frequency > 2 && info.frequency < 5) {
                freq = "(2.4G)";
              }

              return Row(
                children: [
                  Icon(
                    wifiIcon,
                    color: IconColor,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(info.ssid, style: textTheme.titleSmall),
                  Text(" $freq", style: textTheme.titleSmall),
                ],
              );
            },
          ),
          const SizedBox(width: 5),
          StreamBuilder(
            stream: interfaceStream,
            builder: (context, snapshot) {
              List<NetworkInterface> interfaces = snapshot.data ?? [];

              final noEthernet = !snapshot.hasData ||
                  interfaces.indexWhere(
                          (interface) => interface.name == "eth0") ==
                      -1;

              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  noEthernet
                      ? const Icon(
                          Icons.not_interested,
                          color: IconColor,
                          size: 20,
                        )
                      : const SizedBox(),
                  const Icon(
                    Icons.settings_ethernet_sharp,
                    color: IconColor,
                    size: 20,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
