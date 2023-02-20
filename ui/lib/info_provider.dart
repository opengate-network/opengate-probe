import 'dart:async';
import 'dart:convert';
import 'dart:io';

class InfoProvider {
  static const ipAddressRefreshDelay = Duration(seconds: 10);
  static const wifiInfoRefreshDelay = Duration(seconds: 10);
  static const resultsRefreshDelay = Duration(seconds: 30);

  static Stream<List<NetworkInterface>> interfaces() {
    final controller = StreamController<List<NetworkInterface>>();

    _updateInterfaceList(controller);

    Timer.periodic(
      ipAddressRefreshDelay,
      (timer) => _updateInterfaceList(controller),
    );
    return controller.stream;
  }

  static _updateInterfaceList(
      StreamController<List<NetworkInterface>> controller) async {
    final interfaceList = await NetworkInterface.list();
    List<NetworkInterface> interfaces = [];

    for (final interface in interfaceList) {
      interfaces.add(interface);
    }

    controller.add(interfaces);
  }

  static Stream<List<ResultModel>> speedtestResults() {
    final controller = StreamController<List<ResultModel>>();

    _updateSpeedtestResults(controller);

    Timer.periodic(
      resultsRefreshDelay,
      (timer) => _updateSpeedtestResults(controller),
    );
    return controller.stream;
  }

  static _updateSpeedtestResults(
      StreamController<List<ResultModel>> controller) async {
    final resultFile = File('/results.json');

    String resultContent;
    try {
      resultContent = await resultFile.readAsString();
    } on PathNotFoundException catch (_, __) {
      resultContent = """[
    {
        "network_type": "ethernet",
        "timestamp": "2023-02-20T12:31:03.891784",
        "speedtest": {
            "download": 31,
            "upload": 41,
            "ping": 14.708
        },
        "ping": {
            "198.41.0.4": 17.41,
            "199.9.14.201": 28.51,
            "192.33.4.12": 17.26,
            "199.7.91.13": 30.22,
            "192.203.230.10": 17.7,
            "192.5.5.241": 22.51,
            "192.112.36.4": null,
            "198.97.190.53": 28.5,
            "192.36.148.17": 262.24,
            "192.58.128.30": 27.88,
            "193.0.14.129": 28.23,
            "199.7.83.42": 17.14,
            "202.12.27.33": 276.28
        }
    },
    {
        "network_type": "wifi",
        "timestamp": "2023-02-20T12:31:58.299910",
        "speedtest": {
            "download": 42,
            "upload": 41,
            "ping": 10.011
        },
        "ping": {
            "198.41.0.4": 18.4,
            "199.9.14.201": 31.14,
            "192.33.4.12": 16.7,
            "199.7.91.13": 28.36,
            "192.203.230.10": 16.32,
            "192.5.5.241": 17.38,
            "192.112.36.4": null,
            "198.97.190.53": 31.09,
            "192.36.148.17": 277.42,
            "192.58.128.30": 27.05,
            "193.0.14.129": 24.2,
            "199.7.83.42": 16.64,
            "202.12.27.33": 274.62
        }
    }
]""";
    }

    final resultData = jsonDecode(resultContent) as List<dynamic>;

    controller.add(resultData
        .map((res) => ResultModel(
              type: res['network_type'],
              download: res['speedtest']?['download'] ?? -1,
              upload: res['speedtest']?['upload'] ?? -1,
              ping: res['speedtest']?['ping'] ?? -1,
              date: DateTime.parse(res['timestamp']),
            ))
        .toList());
  }

  static Stream<List<WifiInfoModel>> wifiInfo() {
    final controller = StreamController<List<WifiInfoModel>>();

    _updateWifiInfo(controller);

    Timer.periodic(
      wifiInfoRefreshDelay,
      (timer) => _updateWifiInfo(controller),
    );
    return controller.stream;
  }

  static _updateWifiInfo(
      StreamController<List<WifiInfoModel>> controller) async {
    final commandResult =
        await Process.run('/home/pi/.local/bin/jc', ['iwconfig']);
    List<dynamic> wifi = [];
    try {
      wifi = jsonDecode(commandResult.stdout) as List<dynamic>;
    } on FormatException catch (e) {
      print(e);
      print(commandResult);
    }

    controller.add(wifi
        .map((e) => WifiInfoModel(
              interface: e['name'],
              ssid: e['essid'],
              signal: e['signal_level'],
              frequency: e['frequency'],
            ))
        .toList());
  }
}

class ResultModel {
  final String type;
  final int download;
  final int upload;
  final double ping;
  final DateTime date;

  const ResultModel({
    required this.type,
    required this.download,
    required this.upload,
    required this.ping,
    required this.date,
  });
}

class WifiInfoModel {
  final String interface;
  final String ssid;
  final int signal;
  final double frequency;

  const WifiInfoModel({
    required this.interface,
    required this.ssid,
    required this.signal,
    required this.frequency,
  });

  static const empty = WifiInfoModel(
    interface: "",
    ssid: "",
    signal: 1,
    frequency: -1,
  );
}
